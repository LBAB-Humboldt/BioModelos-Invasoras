class Group < ActiveRecord::Base


	has_and_belongs_to_many :users
	has_and_belongs_to_many :species
  belongs_to :group_state
  has_many :group_users
  has_many :species_groups


  mount_uploader :logo, GroupLogoUploader

  # Notificaciones en el muro de un grupo
  def notifications
    Group.find_by_sql("
      SELECT * FROM (
        SELECT * FROM(
      SELECT u.id, u.name, '0' sp_id, u.bio info, gu.updated_at, 'new_user' type
        FROM users u, group_users gu
        WHERE u.id = gu.user_id AND gu.group_user_state_id = 1 AND gu.group_id = "+self.id.to_s+"
        ORDER BY gu.updated_at DESC 
        LIMIT 35) NUEVOS_USUARIOS
        UNION ALL
        SELECT * FROM(
      SELECT s.id, s.sci_name name, '0' sp_id, s.family info, sg.updated_at, 'new_species' type
        FROM species s, species_groups sg
        WHERE sg.species_id = s.id AND sg.species_group_state_id = 1 AND sg.group_id = "+self.id.to_s+"
        ORDER BY sg.updated_at DESC 
        LIMIT 35) NUEVAS_ESPECIES
        UNION ALL
        SELECT * FROM(
      SELECT u.id, u.name, s.id sp_id, s.sci_name info, r.updated_at, 'review' type
        FROM users u, species s, reviews r, models m, group_users gu, species_groups sg
        WHERE u.id = r.user_id AND u.id = gu.user_id AND m.id = r.model_id AND s.id=m.species_id AND s.id = sg.species_id AND gu.group_user_state_id = 1 AND sg.species_group_state_id = 1 AND gu.group_id = "+self.id.to_s+" AND sg.group_id = "+self.id.to_s+"
        ORDER BY sg.updated_at DESC
        LIMIT 35) NUEVA_EDICION
      )
      ORDER BY updated_at DESC
      LIMIT 35")
  end

  # Establece un ranking de usuarios por grupo, teniendo en cuenta los aportes relacionados con las especies del grupo
  def users_ranking
    User.find_by_sql("SELECT U.id, U.name, COUNT(R.id) ediciones
      FROM users U,  reviews R, species S, groups G, group_users GU, species_groups SG, models m
      WHERE U.id = R.user_id AND U.id = GU.user_id AND GU.group_id = G.id
            AND SG.group_id = G.id AND S.id=SG.species_id AND m.id =R.model_id
            AND m.species_id = S.id AND SG.species_group_state_id=1 AND GU.group_user_state_id=1
            AND G.id = "+self.id.to_s+"
      GROUP BY U.name
      ORDER BY COUNT(R.id) DESC
      LIMIT 10")
  end

end