class AddDetailPageToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :detail_page_id, :integer
  end
end
