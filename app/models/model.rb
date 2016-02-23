class Model < ActiveRecord::Base

	validates :species_id, :presence => true
    validates :img_url, :presence => true #, format:  { 	with: /((?:https?\:\/\/|www\.)(?:[-a-z0-9]+\.)*[-a-z0-9]+.*)/i,
    # 												message: "only allows valid urls" }
    validates :model_date, :presence => true
    validates :rating, inclusion: { in: 0..9 }

	has_many :reviews
	has_many :ratings


	def self.search(query)
		where(":species_id like ?", "%#{query}%")
	end

	def average_rating
		ratings.where("score > 0").count == 0 ? 0.0 : ratings.sum(:score).fdiv(ratings.where("score > 0").count).round(2)
	end

	def total_votes
		ratings.where("score > 0").count
	end

end
