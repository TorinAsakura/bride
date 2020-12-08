class AddDurationToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :duration, :string
  end
end
