# encoding: utf-8

namespace :bonus do
  namespace :seed do
    desc "Load services, seasonal_factors, packages etc."
    task services: :environment do
      if Bonus::Subscription.count.zero?
        require 'active_record/fixtures'

        %w(services seasonal_factors packages loyalties).each do |table_name|
          ActiveRecord::Base.connection.execute("truncate table bonus_#{table_name}")
        end
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)

        ActiveRecord::Fixtures.create_fixtures(
            File.expand_path('../../../db/fixtures', __FILE__ ),
            %w(bonus_services bonus_seasonal_factors bonus_packages bonus_loyalties),
            bonus_services: Bonus::Service,
            bonus_seasonal_factors: Bonus::SeasonalFactor,
            bonus_packages: Bonus::Package,
            bonus_loyalties: Bonus::Loyalty
        )
      else
        puts 'Bonus Subscriptions already exist'
      end
    end
  end

  namespace :touch do
    desc 'Update firms bonus status'
    task firms: :environment do
      Firm.find_each(&:save)
    end
  end
end