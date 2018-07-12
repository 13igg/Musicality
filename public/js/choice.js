function onLoad(artistsID)
{
	$("#songsButtonLeft").empty();
	$("#songsButtonRight").empty();
	postForSongs(artistsID);
}

function postForSongs(artistsID)
{
	$("#headerLoadingBar").append("<img src='/img/loading.gif'/>");
	$.post("/artist/songSearch", //Post URL inside the .rb
		{ artistID: artistsID, songsNeeded: 2 - ( $("#songsButtonLeft").contents().length + $("#songsButtonRight").contents().length ) }, //Data sent to the .rb
			function(data) { //function to call when the .rb returns the JSON
				$("#headerText").empty();
				$("#headerLoadingBar").empty();
				$("#headerText").append("<p>Click the song which you prefer more!</p>");
				$.each(data, function( key, val ) {
					addContent(val.trackName,val.trackMbid, val.artistMbid, val.artistName, val.albumName, val.albumMbid, val.albumDate,val.dateLiked);//val);
				});	        	
	        }
		);
}

function addContent(track,trackID,artistsID, artistsName, albumName,albumID,albumDate,dateLiked)
{
	//a9659633-53ce-49f4-b399-8a3ed68f6f69
	//7c0196c7-dc42-483c-9d2e-bfcf56b25ef7
	// track = val.trackName;
	// trackID = val.trackMbid;
	// artistID = val.artistMbid;
	// artistName = val.artistName;
	// albumName = val.albumName;
	// albumID =  val.albumMbid;
	// albumDate = val.albumDate;
	//if there are no songs yet (songsLeft is empty, add one to the left, and one to the right
	if($("#songsButtonLeft").contents().length == 0 )
	{
		buttonDiv = "#songsButtonLeft";
		contentDiv = "#songsLeftContent";

	}
	else
	{
		buttonDiv = "#songsButtonRight";
		contentDiv = "#songsRightContent";
	}

	$(buttonDiv).append
	(
		$('<button/>', {
	        text: track, 
	        id: trackID, 
	        click: function () {
	        	if ( ($("#songsButtonRight").contents().length != 0) && ($("#songsButtonLeft").contents().length != 0) ) 
	        		songChosen(track,trackID,artistsID,artistsName,dateLiked);
	         }
	    })
    );

	$(contentDiv).append("Album Name: " + albumName + "</br>");
	$(contentDiv).append("Album Date: " + albumDate + "</br>");
	$(contentDiv).append("<center><img src='http://coverartarchive.org/release/" + albumID + "/front' width='200' height='200' onerror= \"this.src='http://musicunderfire.com/wp-content/uploads/2012/06/No-album-art-itunes-300x300.jpg';\"style='padding-top: 5px' align='middle'></center>");

}

function songChosen(track,trackID,artistsID,artistsName, dateLiked)
{
	//when clicked, remove the other one, then start over again
	$.post("/artist/selection", //Post URL inside the .rb
		{track: track, artist_name: artistsName, artist_id: artistsID, recording_id: trackID, date_liked: dateLiked}, //Selected artists ID and TrackID are sent back to the server
		function(data) { //function to call when the .rb returns the JSON
				
			//if the left song is chosen, clear the right.
			//if the right song is chosen, clear the left, move right to the left
				if($("#songsButtonLeft").contents()[0].id == trackID)
				{					
					$("#songsButtonRight").empty();
					$("#songsRightContent").empty();
				}
				else
				{
					$("#songsButtonLeft").empty();
					$("#songsLeftContent").empty();
				}

				$("#headerText").empty();
				postForSongs(artistsID);	
				$("#headerText").append("<p>Searching for similar songs by: " + artistsName + "</p>");
			}
		);
}