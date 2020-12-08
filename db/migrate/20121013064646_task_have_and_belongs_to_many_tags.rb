class TaskHaveAndBelongsToManyTags < ActiveRecord::Migration
  def self.up
    create_table :tags_tasks, :id => false do |t|
      t.references :task, :tag
    end
  end
 
  def self.down
    drop_table :tags_tasks
  end
end
