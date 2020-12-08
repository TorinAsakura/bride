class CreateMediaContents < ActiveRecord::Migration
  def change
    create_table :media_contents do |t|
      t.string :title
      t.text :description
      t.text :content
      t.boolean :video
      t.references :multimedia, :polymorphic => true

      t.timestamps
    end
    add_index :media_contents, [:multimedia_type, :multimedia_id]
  end
end
