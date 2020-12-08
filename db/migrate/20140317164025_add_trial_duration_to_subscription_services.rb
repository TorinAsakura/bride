class AddTrialDurationToSubscriptionServices < ActiveRecord::Migration
  def up
    remove_column :subscription_services, :trial
    add_column :subscription_services, :trial_duration, :integer, default: 0
  end

  def down
    add_column :subscription_services, :trial, :boolean, default: false
    remove_column :subscription_services, :trial_duration
  end
end
