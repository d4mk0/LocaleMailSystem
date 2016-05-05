class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false, index: true
      t.integer :recepient_id, null: false, index: true
      t.string :subject, null: false
      t.text :text, null: false
      t.boolean :deleted, null: false, default: false
      t.boolean :read, null: false, default: false

      t.timestamps null: false
    end
  end
end
