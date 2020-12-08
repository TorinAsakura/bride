class CreateBonusCertificates < ActiveRecord::Migration
  def change
    create_table :bonus_certificates do |t|
      t.references :owner, polymorphic: true
      t.belongs_to :payment
      t.belongs_to :service
      t.string     :name
      t.text       :description
      t.date       :starts_at
      t.date       :ends_at
      t.datetime   :deleted_at
      t.integer    :amount_cents
      t.integer    :quantity,      default: 1
      t.integer    :used_quantity, default: 0
      t.integer    :limit,         default: 1
      t.string     :number

      t.timestamps
    end

    add_index :bonus_certificates, [:owner_id, :owner_type], name: :bonus_promotions_owner_index
    add_index :bonus_certificates, :payment_id
    add_index :bonus_certificates, :service_id
    add_index :bonus_certificates, :starts_at
    add_index :bonus_certificates, :ends_at
  end
end
