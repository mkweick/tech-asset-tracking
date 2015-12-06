module AssetsHelper  
  
  def asset_btn(asset)
    asset.new_record? ? "Create Asset" : "Update Asset"
  end
end