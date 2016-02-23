class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end
  
  def show

  end

  def create

    @review = Review.new(review_params)

    if @review.save
      flash[:success] = 'Anotación guardada con éxito.'

#********************* FRANK CODE **********************
      connection = ActiveRecord::Base.connection

      require 'csv'
      require "rubygems"
      require "json"

      @models = Model.find(@review.model_id)
      @species = Species.find(@models.species_id)
      file = "#{Rails.root}/public/registros/"+@species.ocurrence_records_url
      reviewCSV = Review.search(@models.species_id)

      CSV.open( file, 'w' ) do |writer|
        writer << ["ID","species","Nombre original","lon","lat","Localidad","Municipio","Departamento","País","Altitud","Fecha","Institución","Colector","Evidencia"]
        reviewCSV.each do |r|
          pointValues = JSON.parse(r.geoJSON)
          @lng = pointValues['features'][0]['geometry']['coordinates'][0]
          @lat = pointValues['features'][0]['geometry']['coordinates'][1]
          @alt = pointValues['features'][0]['properties']['Altura']
          @loc = pointValues['features'][0]['properties']['Localidad']
          @fec = pointValues['features'][0]['properties']['Fecha de Registro']
          @obs = pointValues['features'][0]['properties']['Observador']
          @evd = pointValues['features'][0]['properties']['Cita']
          writer << [r.id, r.sci_name, r.family, @lng, @lat, @loc, '','','', @alt, @fec,'', @obs, @evd]
        end
      end

#********************* END FRANK CODE **********************

    else
      flash[:error] = 'Ha ocurrido un error mientras se guardaba la anotación.'
    end
    respond_to do |format|
        format.js
    end
  end

  def destroy
    @review = Review.find(params[:id])

    if @review.destroy
        redirect_to user_path(@review.user_id)
      else
        render :js => "alert('Error eliminando edición');"
      end
  end

  def reviews_by_species
    @species = Species.find(params[:id])
    @models = Model.where(:species_id => params[:id], current: true)

    arr = []
    @models.each do |m|
        arr.push(m.id)
    end

    @species_reviews = Review.where({ model_id: arr}).order("created_at DESC")


    respond_to do |format|
        format.js
    end
  end

  private

    def review_params
      params.require(:review).permit(:user_id, :model_id, :geoJSON)
    end

end

