require 'musicbrainz'


MusicBrainz.configure do |c|
  # Application identity (required)
  c.app_name = "Musicality"
  c.app_version = "1.0"
  c.contact = "mciaglia@carthage.edu"

  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end

 
  #a = MusicBrainz::Artist.search("kid")
  #@a = MusicBrainz::Artist.discography("ad0ecd8b-805e-406e-82cb-5b00c3a3a29e").release_groups[0]

@aa = MusicBrainz::Artist.find("e0e1db18-f7ba-4dee-95ff-7ae8cf545460")
@a = @aa
t1 = Time.now

#find the initial release group length 
@a = @a.release_groups
puts @a[5].releases[0].id
@a[5].releases.each do |x|
	puts x.title
end
release_group_size = @a.length
#set a random one
release_group_num = rand(0...release_group_size)

#find the size of the releases, based on the chosen release group
@a = @a[release_group_num].releases
releases_size = @a.length
releases_num = rand(0...releases_size)

#find the num of tracks, and pick a random one
@a = @a[releases_num].tracks
tracks_size = @a.length
track_num = rand(0...tracks_size)

puts "Artist: " + @aa.name.to_s;
puts "Release Groups: " + release_group_size.to_s
puts "Releases in the " + release_group_num.to_s + " Release Group: " + releases_size.to_s
puts "Tracks in the " + releases_num.to_s + " Release: " + tracks_size.to_s
puts "Track number " + track_num.to_s + ": " + @a[track_num].title
puts
# processing...
t2 = Time.now
delta = t2 - t1
puts "Processing took: " + delta.to_s
puts puts