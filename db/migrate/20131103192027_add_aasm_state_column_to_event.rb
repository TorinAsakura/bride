class AddAasmStateColumnToEvent < ActiveRecord::Migration
  def up
    add_column :events, :aasm_state, :string
    remove_column :events, :state

    Event.all.each { |e| e.update_attribute(:aasm_state, 'uncompleted') }
  end

  def down
    remove_column :events, :aasm_state
    add_column :events, :state, :integer, default: 1
  end
end
