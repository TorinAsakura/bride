module Models
  module Wedding
    module GenerateWedding

      private
      def update_wedding
        ActiveRecord::Base.transaction do
          if self.script_id_changed?
            self.events.sys_event.each{ |tt| tt.update_attributes(timetable_id: nil) }
            self.timetables.each{ |tt| tt.plan_id = nil }
            create_wedding 'update'
            move_user_events
            self.timetables.each {|tt| tt.destroy if tt.plan.blank?}
          elsif self.wedding_date_changed?
            change_wedding_date
          end
        end
      end

      def create_events tasks, timetbl, date_to, param = nil
        tasks.each do |task|
          if param == 'update' && event = self.events.find_by_task_id(task.id)
            event.update_attributes(timetable_id: timetbl.id,
                                    date_to: date_to,
                                    wedding_id: timetbl.wedding.id)
          else
            Event.create(task_id: task.id,
                         task_category_id: task.task_category_id,
                         type_task: task.type_task,
                         service: task.service,
                         timetable_id: timetbl.id,
                         description: task.description,
                         name: task.name,
                         date_to: date_to,
                         wedding_id: timetbl.wedding.id)
          end
        end
      end

      def create_wedding param = nil
        #После свадьбы
        after_wedding = Plan.after_wedding.includes(:tasks).where("plans.script_id = ?", self.script_id).first
        timetbl = Timetable.create(wedding_id: self.id,
                                   t_type: after_wedding.plan_type,
                                   date_from: self.wedding_date,
                                   index_number: -1,
                                   plan_id: after_wedding.id)
        create_events(after_wedding.tasks, timetbl, timetbl.date_from, param)

        #День свадьбы
        @wedding_plan = Plan.wedding_day.includes(:tasks).where("plans.script_id = ?", self.script_id).first
        timetbl = Timetable.create(wedding_id: self.id,
                                   t_type: @wedding_plan.plan_type,
                                   date_from: self.wedding_date,
                                   index_number: 0,
                                   plan_id: @wedding_plan.id)
        create_events(@wedding_plan.tasks, timetbl, timetbl.date_from, param)

        #Неделя до свадьбы
        @day_plans = Plan.day.includes(:tasks).where("plans.script_id = ?", self.script_id)
        @day_plans.each_with_index do |day_plan, i|
          timetbl = Timetable.create(wedding_id: self.id,
                                     t_type: day_plan.plan_type,
                                     date_from: self.wedding_date - (i + 1).day,
                                     index_number: day_plan.index_number,
                                     plan_id: day_plan.id)
          create_events(day_plan.tasks, timetbl, timetbl.date_from, param)
        end

        #Оставшиеся недели
        @week_plans = Plan.week.includes(:tasks).where("plans.script_id = ?", self.script_id)
        date_from = timetbl.date_from - 1.week
        @week_plans.each_with_index do |week_plan, i|
          timetbl = Timetable.create(wedding_id: self.id,
                                     t_type: week_plan.plan_type,
                                     date_from: date_from,
                                     index_number: week_plan.index_number,
                                     plan_id: week_plan.id)
          create_events(week_plan.tasks, timetbl, date_from + 6.day, param)
          date_from = date_from - 1.week
        end

        #Планирование
        date_from = timetbl.date_from - 1.day
        @planning_plan = Plan.planning.includes(:tasks).where('plans.script_id = ?', self.script_id).first
        timetbl = Timetable.create(wedding_id: self.id,
                                   t_type: @planning_plan.plan_type,
                                   date_from: self.start_date,
                                   index_number: @week_plans.count + 2,
                                   plan_id: @planning_plan.id)
        create_events(@planning_plan.tasks, timetbl, date_from, param)
      end #create_wedding

      def move_user_events
        self.events.user_event.each do |event|
          tt = event.timetable
          find_timetables = self.timetables.where(t_type: tt.t_type, index_number: tt.index_number)
          tt_new = find_timetables.count == 2 ? find_timetables.last : self.timetables.planning.last
          date_to = case tt_new.t_type
                    when :planning, :week
                      tt_new.next.date_from - 1.day
                    else
                      tt.date_from
                    end
          event.update_attributes(timetable_id: tt_new.id, wedding_id: self.id, date_to: date_to)
        end
      end

      def change_wedding_date
        shift = (self.wedding_date - self.timetables.wedding_day.last.date_from).to_i
        self.timetables.reject{ |tt| tt.t_type == :planning }.each do |tt|
          tt.date_from += shift.day
          tt.events.each { |e| e.update_attribute(:date_to, e.date_to + shift.day) }
          tt.save
        end
        self.timetables.find_by_t_type(:planning).events.each do |e|
          e.update_attribute(:date_to, e.date_to + shift.day)
        end        
      end

    end
  end
end
