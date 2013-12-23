class AddAccountName < ActiveRecord::Migration
  def change
  	change_table(:accounts) do |t|
  		t.string :name
  	end
  end
end
