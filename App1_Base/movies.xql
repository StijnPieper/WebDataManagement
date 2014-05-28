xquery version "3.0";

declare function local:search($title as xs:string, $years as xs:string, $director as xs:string, $actors as xs:string, $summary as xs:string) as node()?
{
    let $movies := doc('/db/movies/movies.xml')//movie
    return  <movie-list>
            {local:search_by_years(local:search_by_title($movies, $title), $years)/title}
        </movie-list>
};

declare function local:search_by_title($movies as node()*, $title as xs:string) as node()*
{
    if ($title) then $movies[contains(lower-case(title/text()), $title)]
    else $movies
};

declare function local:search_by_years($movies as node()*, $years as xs:string) as node()*
{
    if ($years) then $movies[year = tokenize(normalize-space($years), " ")]
    else $movies
};

let $action := lower-case(xs:string(request:get-parameter("action", ""))),
    $title := xs:string(request:get-parameter("title", ""))
return (if ($action = 'search') then (
    let $title := lower-case($title),
        $years := xs:string(request:get-parameter("years", "")),
        $director := lower-case(xs:string(request:get-parameter("director", ""))),
        $actors := lower-case(xs:string(request:get-parameter("actors", ""))),
        $summary := lower-case(xs:string(request:get-parameter("summary", "")))
    return
       local:search($title, $years, $director, $actors, $summary)
    )
    else doc('/db/movies/movies.xml')//movie[title = $title]
)


