ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :name, :role, :organization, :bio, :sign_in_count, :last_sign_in, :avatarUrl, :periodicity_id, :last_email_send, :current_sign_in_at, :interestGroups
  actions :index, :show, :new, :create, :edit, :update

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :bio
    column :organization
    column :periodicity
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :periodicity
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
      f.input :bio
      f.input :organization
      f.input :interestGroups
      f.input :periodicity
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
