class UpdateFirmPages < ActiveRecord::Migration
  def up
    add_column :firm_pages, :rating, :integer, default: 0
    add_column :firm_pages, :shown, :boolean, default: true
    add_column :firm_pages, :name, :string
    remove_column :firms, :detail_page_id

    Firm.all.each do |firm|
      firm.firm_pages.create(name: 'journal')
      firm.firm_pages.create(name: 'albums')
      firm.firm_pages.create(name: 'videos')
      firm.firm_pages.create(name: 'comments')
      firm.firm_pages.create(name: 'addresses')
      firm.firm_pages.create(name: 'firm-services')
    end
  end

  def down
    remove_column :firm_pages, :rating
    remove_column :firm_pages, :shown
    remove_column :firm_pages, :name
    add_column :firms, :detail_page_id, :integer
  end
end
