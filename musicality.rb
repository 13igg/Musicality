require 'musicbrainz'
require 'sinatra'
require 'sequel'
require 'sinatra/json'
require 'date'

configure do
  #connect to the sqlite database
 #DB = Sequel.connect('sqlite://Musicality.db') 
DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://musicality.db')
  #create a liked_songs table
  DB.create_table? :liked_songs do
    primary_key :id #basic counter
    String :recording_id, :unique => true  #id of the track
    String :artist_id #id of the artist
    String :artist_name
    String :track
    String :date_liked
    Integer :number_of_likes #number of likes the song has
  end

  #after the db has been created for sure, open up the Visitor model
  #ruby will make the correct associations from the database file
  require_relative 'LikedSong'
  require_relative 'Song'
  require_relative 'TopX'
  require_relative 'Recent'

end

MusicBrainz.configure do |c|
  # Application identity (required)
  c.app_name = "Musicality"
  c.app_version = "1.0"
  c.contact = "mciaglia@carthage.edu"

  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2 
end

helpers do
#with the artist ID, return their MB info
  def getArtistByID(id)
    MusicBrainz::Artist.find(id)
  end
#with the artist name, return a list of possible names
  def getArtists(name)
    MusicBrainz::Artist.search(name)
  end
#given a artistID and num, return a SONG object conerted to JSON
  def getTrack(artistID,songsNeeded)
    #hash of songs
    songs = {}
    #depending on the amount of songs needed -1 or 2, make a new song
    (0..songsNeeded.to_i-1).each do
      song = Song.new()
      #fetch the artist info
      artist = getArtistByID(artistID)    
      song.artistName = artist.name #sets artists name
      song.artistMbid = artistID #sets artists Mbid

      #find the number of albums and pick a random one
      a = artist.release_groups
      release_group_size = a.length
      release_group_num = rand(0...release_group_size)

      #each album has many releases, pick one of them as the album 
      a = a[release_group_num].releases
      releases_size = a.length
      releases_num = rand(0...releases_size)
      song.albumMbid = a[releases_num].id
      song.albumName = a[releases_num].title
      song.albumDate = a[releases_num].date

      #find the num of tracks, and pick a random one
      a = a[releases_num].tracks
      tracks_size = a.length
      track_num = rand(0...tracks_size)
      song.trackMbid = a[track_num].recording_id
      song.trackName = a[track_num].title
      song.dateLiked = Time.now.strftime("%m/%d/%Y %H:%M")

      #add that song to the hash
      songs[song.trackName] = song.getSongData()
    end
    return json songs #return a json of songs
  end
end

get '/' do    
   erb :main
end

post '/setTopX' do
  topX = TopX.new(5)
  return topX.getTopX();
end

post '/setRecent' do
  topRecent = Recent.new()
  return topRecent.getTopRecent();
end

#take in a artist name, and find the names/ids of similar people 
post '/artistSearch' do
    artistList = getArtists("#{params[:name]}") #hash of up to 10 artists info with a similar name to the one provided
    if(artistList.size != 0)
      return json artistList #json object holding a mbid hash of the suggested artists
    end
end

#take in TrackID and the ArtistsID
post '/artist/selection' do
  song = LikedSong[:recording_id => params[:recording_id]] #check to see if the song has already been liked previously
  if song.nil? #if not, create a new spot in the table for it
    song = LikedSong.create(:artist_id => params[:artist_id],
                      :recording_id => params[:recording_id],
                      :artist_name => params[:artist_name],
                      :track => params[:track],
                      :date_liked => params[:date_liked],
                      :number_of_likes => 1)
  else
    song.record_like #if it has, then add one to that location
    song.record_time
  end
return json ""#getArtistByID(:artist_id)
end

#once an artist is chosen, use the ID to display 2 songs to be compared
get '/artist/:artistID' do  
  @artistID = "#{params[:artistID]}"
  erb :choice
end

#take in a artist id, send out 1 or 2 songs depending if it is initial showing, or repopulating search
post '/artist/songSearch' do
  getTrack("#{params[:artistID]}","#{params[:songsNeeded]}")
end