class CreateFixedAssets < ActiveRecord::Migration
  def change
    create_table :fixed_assets do |t|
      t.integer :category_id, index: true
      t.string :mfg_name
      t.string :model_num
      t.string :serial_num
      t.text :description
      t.datetime :purchase_date
      t.timestamps null: false
    end
  end
end
