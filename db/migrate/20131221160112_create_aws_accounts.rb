class CreateAwsAccounts < ActiveRecord::Migration
  def change
    create_table :aws_accounts do |t|
      t.integer :account_id
      t.string :name
      t.string :access_key
      t.string :secret_key

      t.timestamps
    end
  end
end
