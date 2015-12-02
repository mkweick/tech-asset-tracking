class CreateUnfixedAssignments < ActiveRecord::Migration
  def change
    create_table :unfixed_assignments do |t|
      t.integer :user_id, index: true
      t.integer :unfixed_asset_id, index: true
      t.timestamps null: false
    end
  end
end
