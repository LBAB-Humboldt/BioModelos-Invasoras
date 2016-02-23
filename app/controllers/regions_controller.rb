class RegionsController < ApplicationController
	
  def create
  end


  def save_region_user
    @usr_sp_rg = UserSpeciesRegion.where(:species_id => params[:sid], :user_id => current_user.id, :region_id => params[:rid]).first

    if @usr_sp_rg.blank?
      UserSpeciesRegion.create({:species_id => params[:sid], :user_id => current_user.id, :region_id => params[:rid]})
    end

    respond_to do |format|
      format.js
    end
  end

  def regions_by_user
    @regions = UserSpeciesRegion.where(:species_id => params[:sid], :user_id => current_user.id)
    arr = []

    @regions.each do |m|
       arr.push(Region.find(m.region_id))
    end

    result = arr.collect do |t|
      { id: t.id, name: t.name }
    end

    render json: result
  end

  private

    def usr_sp_rg_params
      params.require(:review).permit(:user_id, :region_id, :species_id)
    end


end