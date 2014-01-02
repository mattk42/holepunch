class AddReservationProtocol < ActiveRecord::Migration
  def change
  	change_table(:reservations) do |t|
  		t.string :protocol
  	end
  end
end
