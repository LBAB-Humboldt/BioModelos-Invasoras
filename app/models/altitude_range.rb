class AltitudeRange < ActiveRecord::Base
	validates_inclusion_of :alt_min, in: 0..9999
	validates_inclusion_of :alt_max, in: 0..9999
end