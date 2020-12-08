# encoding: utf-8
class FirmCatalogTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :firm_catalog
  attr_accessible :firm_catalog_id, :task_id
end