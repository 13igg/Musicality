class Recent
	attr_reader(:topRecent)
	def initialize()
		# Instance variables 
		@topRecent = "<table class='topRecent'><th></th><th><center><b>Top 5 Recent Artists:</b></center></th>"
		fillTop5() 
		require_relative 'LikedSong'
	end  

	def fillTop5()
		#find all the students with the passed in name

		DB[:LikedSong].with_sql("SELECT DISTINCT artist_name FROM liked_songs Group By artist_name ORDER BY MAX(date_liked) DESC limit 5").each { |recent| 
  			@topRecent << "<tr><td>#{recent[:artist_name]}</td></tr>"
  		}
		
		#correct sql to do it
		# SELECT DISTINCT artist_name
		# FROM liked_songs
		# Group By artist_name
		# ORDER BY MAX(date_liked) DESC
		# limit 5
	end


	def getTopRecent()
		return @topRecent << "</table>"
	end
	
	private 
	attr_writer(:topRecent)
end