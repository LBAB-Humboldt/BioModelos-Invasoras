ActiveAdmin.register Group do

  config.sort_order = "name_asc"
  menu :priority => 1
  actions :index, :show, :new, :create, :edit, :update

  filter :name
  filter :description
  filter :email
  filter :link
  filter :group_state
  filter :created_at
  filter :updated_at


  #For allowing the use of the UrlHelper
  controller do
    helper :url
  end

  index do
    column :id
    column :name
    column :description
    column :email
    column :link
    column :amount_users do |group|
      group.group_users.count
    end
    column :amount_species do |group|
      group.species_groups.count
    end
    column :logo do |group|
      image_tag(group.logo.url(:thumb120).to_s)
    end
    column :group_state
    column :created_at
    column :updated_at
    actions
  end

  permit_params :list, :of, :attributes, :on, :model, :name, :link, :description, :email, :logo, :group_state_id

  form do |f|
    f.inputs "" do
      f.input :name, :input_html => { :maxlength => 200  }, :hint => "Hasta 200 Caracteres."
      f.input :description, :as => :text, :input_html => { :rows => 3, :maxlength => 1000  }, :hint => "Hasta 1000 Caracteres."
      f.input :email, :label => "Email de Contacto", :input_html => { :maxlength => 100  }, :hint => "Hasta 100 Caracteres."
      f.input :link, :label => "Link Externo", :input_html => { :maxlength => 300  }, :hint => "Hasta 300 Caracteres."
      f.input :logo, :as => :file, :hint => "Imagen (jpg o png)"
      f.input :group_state, :label => "Estado"

    end
    f.actions
  end

  show do |group|
    attributes_table do
      row :name
      row :description
      row :email
      row :link
      row :group_state
      row :nit
      row :amount_species do
        group.species_groups.count
      end
      row :amount_species do
        group.species_groups.count
      end
      row :logo do
        image_tag(group.logo.url(:thumb250).to_s)
      end
      row :created_at
      row :updated_at
    end

    panel 'Especies' do
      table_for(group.species_groups) do
        column('specie') { |species_group| species_group.species.sci_name }
        column('state') { |species_group| species_group.species_group_state.name }
        column('') { |species_group| link_to 'View',  admin_group_species_group_path( group, species_group )}
        column('') { |species_group| link_to 'Edit', edit_admin_group_species_group_path( group, species_group )}
      end
    end

    panel 'Usuarios' do
      table_for(group.group_users) do
        column('user') { |group_user| group_user.user.name }
        column('is admin') { |group_user| group_user.is_admin }
        column('state') { |group_user| group_user.group_user_state.name }
        column('') { |group_user| link_to 'View',  admin_group_group_user_path( group, group_user )}
        column('') { |group_user| link_to 'Edit', edit_admin_group_group_user_path( group, group_user )}
      end
    end
  end

  action_item only:[:show] do
    link_to "Add User", new_admin_group_group_user_path(group)
  end
  action_item only:[:show] do
    link_to "Add Species", new_admin_group_species_group_path(group)
  end
end