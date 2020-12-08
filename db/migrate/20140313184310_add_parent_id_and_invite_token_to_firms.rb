class FirmStub < ActiveRecord::Base
  set_table_name :firms

  def generate_token
    begin
      token = Digest::SHA1.hexdigest([Time.now.to_i, (1..10).map{ rand.to_s }].flatten.join('--'))
    end while self.class.find_all_by_invite_token(token).nil?
    self.invite_token = token if self.invite_token.blank?
    self.save!
  end
end

class AddParentIdAndInviteTokenToFirms < ActiveRecord::Migration
  def migrate(direction)
    super
    FirmStub.find_each(&:generate_token) if direction == :up
  end
  def change
    add_column :firms, :parent_id, :integer
    add_column :firms, :invite_token, :string
    add_index :firms, :parent_id
    add_index :firms, :invite_token
  end
end