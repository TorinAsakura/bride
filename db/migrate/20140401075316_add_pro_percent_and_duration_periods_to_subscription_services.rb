class AddProPercentAndDurationPeriodsToSubscriptionServices < ActiveRecord::Migration
  def change
    add_column :subscription_services, :pro_service_id,        :integer
    add_column :subscription_services, :pro_percent,           :integer, default: 0
    add_column :subscription_services, :duration_period,       :string,  default: 'days'
    add_column :subscription_services, :trial_duration_period, :string,  default: 'days'
  end
end
