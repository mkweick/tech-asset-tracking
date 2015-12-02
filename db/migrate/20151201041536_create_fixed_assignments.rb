class CreateFixedAssignments < ActiveRecord::Migration
  def change
    create_table :fixed_assignments do |t|
      t.integer :user_id, index: true
      t.integer :fixed_asset_id, index: true
      t.timestamps null: false
    end
  end
end
