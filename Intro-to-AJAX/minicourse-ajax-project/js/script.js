
function loadData() {

    var $body = $('body');
    var $wikiElem = $('#wikipedia-links');
    var $nytHeaderElem = $('#nytimes-header');
    var $nytElem = $('#nytimes-articles');
    var $greeting = $('#greeting');

    // clear out old data before new request
    $wikiElem.text("");
    $nytElem.text("");

    // load streetview
    
    // YOUR CODE GOES HERE!
    
    var $street =  $('#street').val();
    var $city = $('#city').val();
    var $address = $street? $street + ', ' +$city : $city;
    $greeting.text('So you want to live at '+ $address +'?');
    $address = encodeURIComponent($address);
    $city = encodeURIComponent($city);
    
    var $streetviewUrl = 'https://maps.googleapis.com/maps/api/streetview?size=600x400&location=' + $address;
    $body.append('<img class="bgimg" src=' + $streetviewUrl + '>');

    
    // NYTime AJAX request
    // KEY: ea341699db31ddf3ecac8b5f725b82d8:10:68976353
    var nyTimesURI = 'http://api.nytimes.com/svc/search/v2/articlesearch.json?q=' +$city +"&sort=newest&api-key=ea341699db31ddf3ecac8b5f725b82d8:10:68976353"
    console.log(nyTimesURI);
    $.getJSON(nyTimesURI, function( data ) {
        var $nytimesArticles = $('#nytimes-articles')
        var articles = data.response.docs;
        for(i in articles)
        {
            var article = articles[i];
            var articleURL = article.web_url;
            var articleParagraph = article.snippet;
            var articleHeadline = article.headline.main;

            $nytimesArticles.append(
                $('<li>').attr('class','article').append(
                  $('<a>').attr('href',articleURL).append(
                      articleHeadline
                    )).append(
                      $('<p>').append(
                          articleParagraph
                      )
            ));
        }
    })
    .fail(function() {
        $('#nytimes-articles').append('Could not reach NYTimes.com')
    });
    
    
    
    // Wikipedia 
    // What is wrong with this???
    // I will come back later
    var remoteURLWithOrigin = 'https://en.wikipedia.org/w/api.php?action=query&titles=' + $city +
        '&format=jsonp';
    $.ajax( {
        url: remoteURLWithOrigin,
        dataType: 'jsonp',
        type: 'POST',
        headers: {'Api-User-Agent':'IntroToAJAX/1.0 (tomtclai@gmail.com)'},
        success: (function( data ) {
                
                    })
        
        }
    );
        return false;
};

$('#form-container').submit(loadData);
