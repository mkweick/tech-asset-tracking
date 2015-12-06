class CreateUnfixedAssets < ActiveRecord::Migration
  def change
    create_table :unfixed_assets do |t|
      t.integer :category_id, index: true
      t.string :mfg_name
      t.string :model_num
      t.string :serial_num, index: true
      t.text :description
      t.date :purchase_date
      t.timestamps null: false
    end
  end
end
