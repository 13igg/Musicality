function functionTop()
{
	var r = $.Deferred();

	$.post("/setTopX", //Post URL inside the .rb
		{ },
		function(data) { //function to call when the .rb returns the JSON
				$("#topX").append(data);
			}
		);	

	setTimeout(function () {
	    // and call `resolve` on the deferred object, once you're done
	    r.resolve();
	  }, 200);
	return r;
}

function functionRecent()
{
	$.post("/setRecent", //Post URL inside the .rb
		{ },
		function(data) { //function to call when the .rb returns the JSON
				$("#topX").append(data);
			}
		);	
}
function onLoad()
{
	//done for a delay...
	functionTop().done(functionRecent);
	
}
function createSuggestionList()
{
	$.post("/artistSearch", //Post URL inside the .rb
		{ name: $(artist_name).val() }, //Artist name user inputed
		function(data) { //function to call when the .rb returns the JSON
			createArtistButtons(data);	
			}
		);
}
function createArtistButtons(data)
{
	$("#artists").empty();
	//$("#artists").append("Select your Artist</br>");
    //for each of the options, make a buttone
	$.each(data, function( key, val ) {
		//add a button for each Artists name similar to the one searched
		$("#artists").append
		(
			$('<button/>', {
		        text: val.name, //set text of the name of the artist
		        id: val.id, //id of the button is the mbid of the artist
		        click: function () {document.location.href='/artist/'+this.id; }
		    })
	    );
	    $("#artists").append("</br>")
	});
}