class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.integer  :firm_id,           default: nil
      t.string   :name,              default: nil
      t.string   :banner,            default: nil
      t.text     :about_competition, default: nil
      t.text     :rules,             default: nil
      t.text     :about_prizes,      default: nil
      t.date     :start_date,        default: nil
      t.date     :deadline_date,     default: nil
      t.boolean  :is_started,        default: false

      t.timestamps
    end

    add_index :competitions, :firm_id
  end
end
