class AddVisitedAtToClients < ActiveRecord::Migration
  def change
    add_column :clients, :visited_at, :datetime
  end
end
