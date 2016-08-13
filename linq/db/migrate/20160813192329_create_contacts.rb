class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :requester_id
      t.integer :accepter_id

      t.timestamps null: false
    end
  end
end
