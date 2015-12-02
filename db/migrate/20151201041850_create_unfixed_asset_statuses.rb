class CreateUnfixedAssetStatuses < ActiveRecord::Migration
  def change
    create_table :unfixed_asset_statuses do |t|
      t.integer :unfixed_asset_id, index: true
      t.datetime :checked_out
      t.datetime :checked_in
      t.datetime :return_date
      t.timestamps null: false
    end
  end
end
