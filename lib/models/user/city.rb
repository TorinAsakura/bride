module Models
  module User
    module City
      extend ActiveSupport::Concern

      included do
        attr_accessor :region, :country
        attr_accessible :region, :country, :city_id
        belongs_to :city
      end

      module InstanceMethods
        def region
          city.region
        end

        def country
          region.country
        end

        def first_city_id
          self.client_city_id || self.firm_city_id || self.firm.try(:cities).try(:first).try(:id)
        end
      end
    end
  end
end
