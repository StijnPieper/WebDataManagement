xquery version "3.0";

declare function local:search($movies as node()*, $title as xs:string, $years as xs:string, $director as xs:string, $actors as xs:string, $summary as xs:string) as node()*
{
    if (count($movies)>0 and $title) then
        let $res := local:search_by_title($movies, $title)
        return local:search($res, "", $years, $director, $actors, $summary)
    else if (count($movies)>0 and $years) then 
        let $res := local:search_by_years($movies, tokenize(normalize-space($years), ' '))
        return local:search($res,  $title, "", $director, $actors, $summary)
    else if (count($movies)>0 and $director) then 
        let $res := local:search_by_director($movies, normalize-space($director))
        return local:search($res,  $title, $years, "", $actors, $summary)
    else if (count($movies)>0 and $actors) then 
        let $res := local:search_by_actor($movies, tokenize($actors, ','))
        return local:search($res,  $title, $years, $director, "", $summary)
    else if (count($movies)>0 and $summary) then 
        let $res := local:search_by_summary($movies, tokenize(normalize-space($summary), ' '))
        return local:search($res,  $title, $years, $director, $actors, "")
    else
        $movies
};

declare function local:search_by_title($movies as node()*, $title as xs:string) as node()*
{
    if ($title) then $movies[contains(lower-case(title/text()), $title)]
    else $movies
};

declare function local:search_by_years($movies as node()*, $years as xs:string*) as node()*
{
    $movies[year = $years]
};

declare function local:search_by_director($movies as node()*, $director as xs:string) as node()*
{
    if ($director) then 
        $movies[lower-case(concat(director/first_name/text(), ' ', director/last_name/text())) = $director]
    else $movies
};

declare function local:search_by_actor($movies as node()*, $actors as xs:string*) as node()*
{
    if (count($actors)>0) then (
        let $actor := normalize-space($actors[1]),
            $res :=  $movies/actor[lower-case(concat(first_name, ' ', last_name)) = $actor]/parent::movie
        return
            local:search_by_actor($res, subsequence($actors, 2))
    )
    else $movies
};

declare function local:search_by_summary($movies as node()*, $keywords as xs:string*) as node()*
{
    if (count($keywords)>0) then (
        let $keyword := normalize-space($keywords[1]),
            $res :=  $movies[matches(lower-case(summary/text()), $keyword)]
        return
            local:search_by_summary($res, subsequence($keywords, 2))
    )
    else $movies
};

let $action := lower-case(xs:string(request:get-parameter("action", ""))),
    $movies := doc('/db/movies/movies.xml')//movie
return 
    if ($action = 'search') then
        let $title := lower-case(xs:string(request:get-parameter("title", ""))),
            $years := xs:string(request:get-parameter("years", "")),
            $director := lower-case(xs:string(request:get-parameter("director", ""))),
            $actors := lower-case(xs:string(request:get-parameter("actors", ""))),
            $summary := lower-case(xs:string(request:get-parameter("summary", "")))
        return
            <movie-list>
            {local:search($movies, $title, $years, $director, $actors, $summary)//title}
            </movie-list>
    else 
        $movies[title/text() = request:get-parameter("title", "")]


