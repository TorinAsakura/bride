class CreateIdeaCategoryTasks < ActiveRecord::Migration
  def change
    create_table :idea_category_tasks do |t|
      t.references :task
      t.references :idea_category
      t.references :wedding_idea_section

      t.timestamps
    end
    add_index :idea_category_tasks, :task_id
    add_index :idea_category_tasks, :idea_category_id
    add_index :idea_category_tasks, :wedding_idea_section_id
  end
end
