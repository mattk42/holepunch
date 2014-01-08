class AddDeletedColumnToReservations < ActiveRecord::Migration
  def change
        change_table(:reservations) do |t|
		t.string :deleted_by
		t.datetime :deleted_time
                t.boolean :deleted
        end
  end
end
