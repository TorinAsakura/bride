class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    drop_table :tags
    drop_table :clouds
    create_table :tags do |t|
      t.string :name
      t.string :color
      t.boolean :accepted, :default=>false
    end

    create_table :taggings do |t|
      t.references :tag
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true
      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, :limit => 128
      t.datetime :created_at
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end

  def self.down
    drop_table :taggings
    drop_table :tags
    create_table :tags do |t|
      t.string :name
      t.references :tag_category
      t.text :description
      t.string :tag_type
      t.timestamps
    end
    create_table :clouds do |t|
      t.references :tag
      t.references :taggable, :polymorphic => true

      #t.timestamps
    end
    add_index :clouds, :tag_id
    add_index :clouds, [:taggable_id, :taggable_type]
  end
end
