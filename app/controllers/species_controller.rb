class SpeciesController < ApplicationController
  
#  def species_by_class
#    if params[:class_id].blank?
#      @species = Species.all.order('sci_name ASC')
#    else
#      @species = Species.where(:class_id => params[:class_id], :current => true).order('sci_name ASC')
#    end
#    respond_to do |format|
#      format.js
#    end
#  end

#************** FRANK CODE ***********************
  def species_by_class
     if !params[:class_id].blank?
      classId = "AND S.`class_id` =#{params[:class_id]}"
    end 
    if !params[:category_id].blank?
      category = "AND C.`categories_id` IN(#{params[:category_id]})"
      join = "JOIN categories_species C ON S.`id` = C.`species_id`"
    end

    @species = Species.find_by_sql("
      SELECT
        --S.`id`,S.`sci_name`
        S.*
      FROM
        species S
        #{join}
      WHERE
        S.`current` = 't'
        #{classId}
        #{category}
      ORDER BY
        S.`sci_name`
    ")


    respond_to do |format|
      format.js
    end
  end

#************** END FRANK CODE **********************



#************** FRANK CODE **********************
  def regions_by_species
    if params[:class_id].blank?
      @species = nil
    else
      @species = Species.find_by_sql("
        SELECT 
          R.id,R.name
        FROM 
          species 
          LEFT JOIN user_species_regions AS US ON US.species_id = species.id
          JOIN regions R ON R.id = US.region_id
        WHERE
          species.`class_id` = "+ params[:class_id] +"
          AND species.`current` = 't'
        GROUP BY
          R.id
        ORDER BY
          R.name
        ")
      #where(:class_id => params[:class_id], :current => true).order('sci_name ASC')
    end
    respond_to do |format|
      format.js
    end
  end

  def adv_search
    require 'csv'
    require "rubygems"
    require "json"

    file = "#{Rails.root}/public/registros/tmp/"+params[:uid]+".csv"
    reviewCSV = Species.searchAdv(params[:classId], params[:from], params[:to], params[:altitudfrom], params[:altitudto], params[:localidad], params[:tiporeg], params[:fuente], params[:institucion])

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
    render json: ""
  end

#************** END FRANK CODE **********************

#************** FRANK CODE **********************
  def autocomplete
    species = Species.search(query: params[:query], class_id:params[:classId], category:params[:category])
    result = species.collect do |t|
      { value: t.sci_name, id: t.id }
    end

    render json: result
  end

#************** END FRANK CODE **********************


#  def autocomplete
#    if params[:classId].blank?
#      species = Species.search(query: params[:query])
#    else
#      species = Species.search(query: params[:query], class_id:params[:classId])
#    end
#    result = species.collect do |t|
#      { value: t.sci_name, id: t.id }
#    end
#
#    render json: result
#  end

  def regions_autocomplete
    regions = Region.search(params[:q])
    result = regions.collect do |t|
      { id: t.id, name: t.name }
    end

    render json: result
  end  

  def eco_variables_search
    ecovar = EcoVariablesSpecies.search(params[:user_id], params[:species_id])
    result = ecovar.collect do |t|
      { eco_id: t.eco_variable_id, max: t.max, min: t.min, mean: t.mean}
    end

    render json: result
  end

  def get_altitude_range
    alt = AltitudeRange.where(:species_id => params[:sid], user_id: current_user.id).first

    render json: alt

  end

  def species_models

    if params[:species_id].blank?
      @species = nil
    else
      @species = Species.find(params[:species_id])
      @models = Model.where(:species_id => params[:species_id], current: true).limit(10)
      @all_comments = @species.root_comments.order('created_at desc')

      @ratings = Hash.new 

      @models.each do |m|
        if user_signed_in?
          @rating = Rating.where(model_id: m.id, user_id: current_user.id).first
          @ratings[m.id] = @rating.blank? ? 0 : @rating.score
        end
      end

      if user_signed_in?
        @new_comment = Comment.build_from(@species, current_user.id, '')
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def show
    @species = Species.find(params[:id])
    # render :partial=>'show'

    respond_to do |format|
      # format.html {render :partial => 'show'}
      format.js   # show_rec_horses.js.erb
    end
   
  end

  def new
    @species = Species.new
  end

  def create
    @species = Species.new(species_params)
    if @species.save
      flash[:sci_name] = 'Species created!!!'
      redirect_to new_species_path
    else
      render :action => "new"
    end
  end

  def comment_point
    @point_comment = PointComment.new

    respond_to do |format|
      format.js
    end
  end

  def create_comment_point
    @point_comment = PointComment.new(point_comment_params)
    if @point_comment.save

      #**************  FRANK CODE **********************
      # Envía la notificación de error vía e-mail
      @user = User.find(@point_comment.user_id);
      @species = Species.find(@point_comment.species_id);
      ErrorPointMailer.error_point_email("ingeniero.frank@gmail.com", "ingeniero.frank@gmail.com", "Administrador" ,@user, @point_comment, @species).deliver_now
      #************** END FRANK CODE **********************


      flash[:success] = 'Anotación guardada con éxito.'
    else
      flash[:error] = 'Ha ocurrido un error mientras se guardaba la anotación.'
    end

     respond_to do |format|
        format.html
        format.js
     end
  end

  def workshop_test
    @workshop_test = WorkshopTest.new

    respond_to do |format|
      format.js
    end
  end

  def add_ecological_variable
    @eco_variable = EcoVariablesSpecies.where(:species_id => params[:species_id], :user_id => current_user.id, :eco_variable_id => params[:eco_variable_id]).first

    if @eco_variable.blank?
      EcoVariablesSpecies.create({:species_id => params[:species_id], :user_id => current_user.id, :eco_variable_id => params[:eco_variable_id], :min => params[:min], :max => params[:max], :mean => params[:mean]})
    else
      EcoVariablesSpecies.update(@eco_variable.id, {:min => params[:min], :max => params[:max], :mean => params[:mean]})
    end

    respond_to do |format|
        format.js
    end
  end

  def add_altitude_range
    @alt_range = AltitudeRange.where(:species_id => params[:sid], :user_id => current_user.id).first

    if @alt_range.blank?
      AltitudeRange.create({:species_id => params[:sid], :user_id => current_user.id, :alt_min => params[:alt_min], :alt_max => params[:alt_max]})
    else
      AltitudeRange.update(@alt_range.id, {:alt_min => params[:alt_min], :alt_max => params[:alt_max]})
    end

    respond_to do |format|
        format.js
    end
  end

  def update
    
  end

  private

    def species_params
      params.require(:species).permit(:class_id, :sci_name, :order, :family, :sib_url, :ocurrence_records)
    end

    def point_comment_params
      params.require(:point_comment).permit(:user_id, :species_id, :lat, :lon, :wrong_id, :geo_problem, :comment)
    end

    def eco_params
      params.require(:eco_variables_species).permit(:species_id, :user_id, :eco_variable_id, :max, :min, :mean)
    end
end
