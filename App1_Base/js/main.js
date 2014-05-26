var base_url = 'http://localhost:8080/exist/rest/db/apps/XMovie/movies.xql';
var base_params = {_xsl : '/db/apps/XMovie/movie_style.xsl'};

function init(){
    $('#btn_search').on('click', sendSearch);
    $('#div_results').on('click', 'a.movie_title', function(event){
        showMovie($(event.target).text());
    });
}

function sendPayload(payload){
     $.ajax({
        type: 'GET',
        url: base_url+'?'+$.param($.extend(payload, base_params)),
        dataType: 'text',
        success: function(data) {
            console.log(data);
            $('#div_results').empty().append(data);
        },
        beforeSend: console.log('sending to '+base_url+'?'+$.param($.extend(payload, base_params))),
        error: function(param1, param2, param3){
            $('#div_results').empty().append('Error occured!');
            console.log(param1);
            console.log(param2);
            console.log(param3)
        }
});
}

function sendSearch(){
    var payload = {
            action : 'search',
            title : $('#input_title').val(), 
            summary : $('#input_summary').val()
    };
    sendPayload(payload);
}

function showMovie(title){
    var payload = {
            action : 'show',
            title : title
    };
   sendPayload(payload);
}

$(document).load(init());
