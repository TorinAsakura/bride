class ActsAsVotableMigration < ActiveRecord::Migration
  def self.up
    drop_table :votes
    create_table :votes do |t|

      t.references :voteable, :polymorphic => true
      t.references :votable, :polymorphic => true
      t.references :voter, :polymorphic => true

      t.boolean :vote
      t.boolean :vote_flag
      t.string :vote_scope

      t.timestamps
    end

    # add_index :votes, [:votable_id, :votable_type]
    # add_index :votes, [:voter_id, :voter_type]
    # add_index :votes, [:voter_id, :voter_type, :vote_scope]
    # add_index :votes, [:votable_id, :votable_type, :vote_scope]
    # add_index :votes, [:voter_id, :voter_type, :voteable_id, :voteable_type], :unique => true, :name => 'fk_one_vote_per_user_per_entity'
  end

  def self.down
    create_table :votes, :force => true do |t|

      t.boolean    :vote,     :default => false,    :null => false
      t.references :voteable, :polymorphic => true, :null => false
      t.references :voter,    :polymorphic => true
      t.timestamps

    end

    add_index :votes, [:voter_id, :voter_type]
    add_index :votes, [:voteable_id, :voteable_type]


    # Comment out the line below to allow multiple votes per voter on a single entity.
    add_index :votes, [:voter_id, :voter_type, :voteable_id, :voteable_type], :unique => true, :name => 'fk_one_vote_per_user_per_entity'
  end
end
