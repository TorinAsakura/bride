class CreateCompetitionPrizes < ActiveRecord::Migration
  def change
    create_table :competition_prizes do |t|
      t.string  :title,       default: nil
      t.text    :description,  default: nil
      t.string  :picture,     default: nil
      t.integer :competition_id

      t.timestamps
    end

    add_index :competition_prizes, :competition_id
  end
end
