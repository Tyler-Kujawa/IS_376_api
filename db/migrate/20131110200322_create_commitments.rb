class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.date :deadline
      t.text :description
      t.integer :issuer_id
      t.string :name
      t.integer :reciever_id
      t.integer :status
      t.boolean :is_init

      t.timestamps
    end
  end
end
