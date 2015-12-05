class UnfixedAssetsController < ApplicationController
  before_action :require_user, only: [:check_out]
  before_action :set_uf_asn, only: [:check_in]
  before_action only: [:check_in] { require_owner(@uf_asn) }
  
  def check_in
    current_user.unfixed_assets.delete(params[:id])
    flash.notice = "Loaned asset sucessfully checked in"
    redirect_to user_path(current_user)
  end
  
  def check_out
    current_user.unfixed_assets << UnfixedAsset.find(params[:id])
    flash.notice = "Loaned asset sucessfully checked out. Return within 1 week"
    redirect_to user_path(current_user)
  end
  
  private
  
  def set_uf_asn
    @uf_asn = UnfixedAsset.find(params[:id]).unfixed_assignment
  end
end