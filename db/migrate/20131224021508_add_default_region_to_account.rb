class AddDefaultRegionToAccount < ActiveRecord::Migration
  def change
  	  change_table(:aws_accounts) do |t|
  	  t.string :default_region
  	end
  end
end
