#a SONG has information as such
#Artist mbid
#Artist Name
#Album mbid
#Album Name
#Track mbid
#Track Name
class Song
	attr_accessor(:artistMbid)
	attr_accessor(:artistName)
	attr_accessor(:albumMbid)
	attr_accessor(:albumName)
	attr_accessor(:albumDate)
	attr_accessor(:trackMbid)
	attr_accessor(:trackName)
	attr_accessor(:dateLiked)	
	attr_reader(:songData)
 
	def initialize
		# Instance variables  
		@songData = {}
	end  

	def artistMbid=(artistMbid)
		@songData["artistMbid"] = artistMbid
		@artistMbid = artistMbid
	end

	def dateLiked=(dateLiked)
		@songData["dateLiked"] = dateLiked
		@dateLiked = dateLiked
	end

	def artistName=(artistName)
		@songData["artistName"] = artistName		
		@artistName = artistName
	end

	def albumDate=(albumDate)
		@songData["albumDate"] = albumDate
		@albumDate = albumDate
	end

	def albumMbid=(albumMbid)
		@songData["albumMbid"] = albumMbid
		@albumMbid = albumMbid
	end

	def albumName=(albumName)
		@songData["albumName"] = albumName
		@albumName = albumName
	end

	def trackMbid=(trackMbid)
		@songData["trackMbid"] = trackMbid
		@trackMbid = trackMbid
	end

	def trackName=(trackName)
		@songData["trackName"] = trackName
		@trackName = trackName
	end

	def getSongData()
		return @songData
	end
	
	private 
	attr_writer(:songData)
end