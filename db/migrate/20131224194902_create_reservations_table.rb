class CreateReservationsTable < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :aws_account_id
      t.integer :user_id
      t.string :sg_id
      t.string :instance_id
      t.string :region
      t.string :ip_address
      t.integer :start_port
      t.integer :end_port
      t.datetime :end_time

      t.timestamps
    end
  end
end
