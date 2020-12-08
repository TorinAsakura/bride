class CreateBonusServices < ActiveRecord::Migration
  def change
    create_table :bonus_services do |t|
      t.string   :identifier
      t.string   :slug
      t.string   :type
      t.string   :state
      t.integer  :position
      t.string   :name
      t.text     :description
      t.integer  :amount_cents,   default: 0
      t.integer  :discount,       default: 0
      t.integer  :dealer_percent, default: 0
      t.boolean  :pay_once,       default: false
      t.integer  :trial_duration, default: 0
      t.boolean  :list,           default: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :bonus_services, :identifier
    add_index :bonus_services, :slug
    add_index :bonus_services, :type
    add_index :bonus_services, :state
    add_index :bonus_services, :position
    add_index :bonus_services, :list
    add_index :bonus_services, :deleted_at
  end
end
