class AddStatusToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :status, :integer, default: 0, null: false
  end
end
