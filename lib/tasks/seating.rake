namespace :seating do
  desc 'Seating structure import'
  task import: :environment do
    SeatingPlan.where('tables is not null').each do |seating_plan|
      site = seating_plan.site
      plan = site.seating_plans.first_or_create
      data = JSON.parse(seating_plan.tables)
      data.each do |table_data|
        table = plan.tables.where(title: table_data['title'], form: table_data['table_type'], height: table_data['height'].to_i).first_or_initialize
        table.height = table_data['height']
        table.width = table_data['width']
        table.deg = table_data['deg']
        table.left_position = table_data['left_position']
        table.top_position = table_data['top_position']
        table.save
        table_data['seats'].each_with_index do |seat_data, i|
          seat = table.seats.find_or_initialize_by_position(i+1)
          seat.guest = site.guests.find(seat_data['guest_id']) if seat_data['guest_id'].present?
          seat.side = seat_data['seat_side']
          seat.gender = seat_data['guest_type']
          seat.save
        end
      end
    end
  end
end
