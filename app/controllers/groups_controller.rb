class GroupsController < ApplicationController

  # Listado de todos los grupos aprobados en biomodelos
  def index
    if params[:q]
      @groups = Group.where("group_state_id = 1 AND name like ?", "%"+params[:q]+"%")
    else
      @groups = Group.where(:group_state_id => 1)
    end
  end

  # Pagina principal de Grupo
  def show
    @group = Group.find(params[:id])
    @species_groups = SpeciesGroup.where(:group_id => @group.id, :species_group_state_id => 1).joins(:species).order('species.sci_name');
    @pending_species_groups = SpeciesGroup.where(:group_id => @group.id, :species_group_state_id => 2);
    @members = GroupUser.where(:group_id =>  @group.id, :group_user_state_id => 1, :is_admin => false).joins(:user).order('users.name')
    @pending_members = GroupUser.where(:group_id =>  @group.id, :group_user_state_id => 2)
    @group_admins = GroupUser.where(:group_id =>  @group.id, :group_user_state_id => 1, :is_admin => true).joins(:user).order('users.name')
    @species = Species.all
    if user_signed_in?
      @user = User.find(current_user.id)
    else
      @user = User.new
    end
    @users_by_reviews = @user.users_most_reviews
    @species_group = SpeciesGroup.new
    @group_user = GroupUser.new
    @is_member = false
    @is_admin = false
    @text_join = "Unirse al Grupo"
    if user_signed_in?
      @user_group = GroupUser.find_by_group_id_and_user_id(@group.id, current_user.id)
      if @user_group
        case @user_group.group_user_state_id
          when 2
            @text_join = "Pendiente de Aprobación"
          when 1
            @is_member=true
            @text_join = "Abandonar Grupo"
          when 3
            @text_join = "Solicitar Aprobación Nuevamente"
          when 4
            @text_join = "Unirse al grupo Nuevamente"
        end
        if @user_group.is_admin
          @is_admin = true
        end
      end
    end
  end

  # Actualiza Información del Grupo
  def update
    group_params =params[:group]
    @group = Group.find(params[:id])
    @group.name=group_params[:name]
    @group.description=group_params[:description]
    @group.logo=group_params[:logo]
    @group.link=group_params[:link]
    @group.email=group_params[:email]
    if @group.save
      @message = "Cambios Guardados con exito"
    else
      @message = "Ocurrrió un error al guardar datos"
    end
    redirect_to group_path(id:params[:id])
  end

  # Envía un email Masivo a todos los Usuarios Activos del Grupo
  def bulk_email
    mails = []
    group = Group.find(params[:id])
    group_users = GroupUser.where(:group_id => params[:id], :group_user_state_id => 1)
    group_users.each do |f|
      mails.push(f.user.email)
    end
    ContactMailer.bulk_email_group(params[:message], params[:subject], mails, group.name, current_user.name).deliver_now
    redirect_to group_path(id:params[:id])
  end

  # Envía un email para invitar a un usuario externo a un grupo de biomodelos
  def email_invitation
    group = Group.find(params[:id])
    ContactMailer.email_invitation(params[:message], params[:name], params[:email], group, current_user).deliver_now
    redirect_to group_path(id:params[:id])
  end

  def form_new_group
    respond_to do |format|
      format.js
    end
  end

  # Envía un email al equipo de BioModelos cuando se sugiere un nuevo grupo
  def email_new_group
    mp = message_params
    mp[:name] = current_user.name
    mp[:email] = current_user.email
    @message = Message.new(mp)
    ContactMailer.email_new_group(@message).deliver
    redirect_to groups_path
  end

  private

    def message_params
      params.require(:message).permit(:name, :email, :subject, :content)
    end


end
