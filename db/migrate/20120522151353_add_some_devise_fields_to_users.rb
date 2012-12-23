class AddSomeDeviseFieldsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Lockable
      t.integer  :failed_attempts, :default => 0
      t.string   :unlock_token
      t.datetime :locked_at

      add_index :users, :confirmation_token,   :unique => true
      add_index :users, :unlock_token,         :unique => true
    end
  end
end
