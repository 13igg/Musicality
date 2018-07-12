class TopX
	attr_reader(:topXString)
	def initialize(topX)
		# Instance variables 
		@topXString = "<table class='test'><th></th><th><center><b>Top 5 Liked Songs:</b></center></th><td></td><tr><td><center><b>Artist</center><b></td><td><center><b>Song Title</center><b></td><td><center><b>Likes</center><b></td></tr>"
		fillTopX(topX) 
		require_relative 'LikedSong'
	end  

	def fillTopX(topX)
		#find all the students with the passed in name
		LikedSong.limit(topX).order(:number_of_likes).reverse_order.each do |likedSong|
			#print the artist INFO
			#Need to call a post on this information... yikes
			@topXString << "<tr><td>#{likedSong.artist_name}</td>               <td>#{likedSong.track}</td>  <td>#{likedSong.number_of_likes}</td><tr>"
		end
	end

	def getTopX()
		return @topXString << "</table>"
	end
	
	private 
	attr_writer(:topXString)
end