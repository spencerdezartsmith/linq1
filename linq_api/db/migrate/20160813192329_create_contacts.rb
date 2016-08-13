class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :requester_id
      t.integer :acceptor_id

      t.timestamps null: false
    end
  end
end
