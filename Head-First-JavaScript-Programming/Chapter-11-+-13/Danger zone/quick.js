function Album(title, artist, year) {
	this.title = title;
	this.artist = artist;
	this.year = year;
	this.play = function() {
		//code here
	};
}

var darkside = Album("Dark Side of the Cheese", "Pink Mouse", 1971);
darkside.play();
