module TaskModule
  SIMPLY = 'simply'
  WITH_SERVICE = 'with_service'
  ADVICE = 'advice'
  CUSTOM = 'custom'
  
  SERVICE_1 = 'service_1'
  SERVICE_2 = 'service_2'
  SERVICE_3 = 'service_3'
  SERVICE_4 = 'service_4'
  SERVICE_5 = 'service_5'
  SERVICE_6 = 'service_6'

  def self.included(base)
    base.instance_eval do
      belongs_to :firm_catalog
      belongs_to :task_category
      
      symbolize :type_task, in: [SIMPLY, WITH_SERVICE, ADVICE, CUSTOM], scopes: true, default: SIMPLY
      symbolize :service, in: [SERVICE_1, SERVICE_2, SERVICE_3, SERVICE_4, SERVICE_5, SERVICE_6],  validate: false
      
      validates :service, presence: true, if: :with_service?
      validates :task_category_id, presence: true, unless: :custom?
      validates :name, presence: true
      
      attr_accessible :service, :type_task, :firm_catalog_id, :task_category_id
    end
  end
  
  def with_service?
    type_task.to_s == WITH_SERVICE 
  end
  
  def simply?
    type_task.to_s == SIMPLY
  end
  
  def advice?
    type_task.to_s == ADVICE
  end
  
  def custom?
    type_task.to_s == CUSTOM
  end
  
  def with_service!
    self[:type_task] = WITH_SERVICE 
  end
  
  def simply!
    self[:type_task] = SIMPLY
  end

  def advice!
    self[:type_task] = ADVICE
  end
      
  def custom!
    self[:type_task] = CUSTOM
  end
end
