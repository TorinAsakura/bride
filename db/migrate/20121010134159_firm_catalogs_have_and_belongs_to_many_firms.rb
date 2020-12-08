class FirmCatalogsHaveAndBelongsToManyFirms < ActiveRecord::Migration
  def self.up
    create_table :firm_catalogs_firms, :id => false do |t|
      t.references :firm, :firm_catalog
    end
  end
 
  def self.down
    drop_table :firm_catalogs_firms
  end
end