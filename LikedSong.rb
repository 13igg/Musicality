require 'sequel'
require 'date'

class LikedSong < Sequel::Model
	def record_like
		set(:number_of_likes => number_of_likes + 1)
		save
	end
	def record_time
		set(:date_liked => Time.now.strftime("%m/%d/%Y %H:%M"))
		save
	end
end