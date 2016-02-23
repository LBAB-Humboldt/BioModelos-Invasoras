ActiveAdmin.register SpeciesGroup do

  # menu :parent => "More options"
  belongs_to :group, parent_class: Group

  permit_params :list, :of, :attributes, :on, :model, :group_id, :species_id, :species_group_state_id

  form do |f|
    f.inputs "" do
      f.input :species, :required => true, :as => :select, :collection => Species.all.map{|c| ["#{c.sci_name}", c.id]}
      f.input :species_group_state, :required => true
    end
    f.actions
  end

  show do |species_group|
    attributes_table do
      row :id
      row :group
      row :species do
        species_group.species.sci_name
      end
      row :species_group_state
      row :created_at
      row :updated_at
    end
  end
end