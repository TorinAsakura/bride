class AddSitesCountAndHeaderToBackgroundProperties < ActiveRecord::Migration
  def change
    add_column :background_properties, :sites_count, :integer, default: 0
    add_column :background_properties, :header, :boolean, default: false
    add_index  :background_properties, :header
    add_index  :background_properties, [:header, :sites_count], name: :index_header_and_sites_count
  end
end
