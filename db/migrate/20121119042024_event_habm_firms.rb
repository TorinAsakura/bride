class EventHabmFirms < ActiveRecord::Migration
  def up
    create_table :events_firms, :id => false do |t|
      t.references :event, :firm
    end
    add_index :events_firms, :event_id
    add_index :events_firms, :firm_id
  end

  def down
    drop_table :events_firms
  end
end
