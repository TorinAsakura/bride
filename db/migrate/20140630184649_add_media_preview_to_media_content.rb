class AddMediaPreviewToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :media_preview, :string
  end
end
