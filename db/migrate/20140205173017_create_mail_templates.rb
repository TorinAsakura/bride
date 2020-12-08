class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.string :title
      t.text :body
      t.date :send_date

      t.timestamps
    end
  end
end
