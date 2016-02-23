ActiveAdmin.register GroupUser do

  # menu :parent => "More options"
  belongs_to :group, parent_class: Group

  permit_params :list, :of, :attributes, :on, :model, :group_id, :user_id, :is_admin, :group_user_state_id

  form do |f|
    f.inputs "" do
      f.input :user, :required => true
      f.input :group_user_state, :required => true
      f.input :is_admin
    end
    f.actions
  end

end