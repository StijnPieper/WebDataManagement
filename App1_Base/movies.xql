xquery version "3.0";

declare function local:search($title as xs:string, $summary as xs:string) as node()?
{
    let $movies := doc('/db/movies/movies.xml')
    return  <movie-list>
            {$movies//movie/title[contains(lower-case(text()), $title)]}
        </movie-list>
};

let $action := lower-case(xs:string(request:get-parameter("action", ""))),
    $title := xs:string(request:get-parameter("title", ""))
return (if ($action = 'search') then (
    let $title := lower-case($title),
        $summary := lower-case(xs:string(request:get-parameter("summary", "")))
    return
       local:search($title, $summary)
    )
    else doc('/db/movies/movies.xml')//movie[title = $title]
)


