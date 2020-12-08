class CreateBackgroundProperties < ActiveRecord::Migration
  def change
    create_table :background_properties do |t|
      t.string :title,      default: nil
      t.string :color,      default: nil
      t.string :image,      default: nil
      t.string :attachment, default: nil
      t.string :position,   default: nil
      t.string :repeat,     default: nil
      t.boolean :is_active, default: false

      t.timestamps
    end
  end
end
