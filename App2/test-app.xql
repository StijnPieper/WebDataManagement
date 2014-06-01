declare function local:display-scene($play, $desired_act, $desired_scene) {
  let $act := $play//ACT[position() = xs:int($desired_act)],
    $scene := $act/SCENE[position() = xs:int($desired_scene)]
  return
    <div class="container">
        <h4>{$act/TITLE/text()} - {$scene/TITLE/substring-before(text(), '.')}</h4>
        <div class="panel-group">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">Description</h4>
                </div>
                <div class="panel-body">
                   {$scene/TITLE/substring-after(text(), '.')}
                </div>
            </div>
        </div>
        <div class="accordion panel-group" id="accordion_personas">
            <div class="accordion-group panel panel-default">
                <div class="accordion-heading panel-heading">
                  <h4 class="panel-title">
                      <a class="accordion-toggle collapsed" 
                        data-toggle="collapse" 
                        data-parent="#accordion_personas"
                        href="#collapse_personas">
                        Speakers
                      </a>
                  </h4>
                </div>
                <div id="collapse_personas" 
                    class="accordion-body collapse panel-body">
                    <div class="accordion-inner">
                    {
                    let $speakers := distinct-values($scene//SPEAKER/text())
                    return for $speaker in $speakers 
                            let $params := concat('play=',encode-for-uri($play//PLAYSUBT/text()), 
                                '&amp;', 'char=',encode-for-uri($speaker),
                                '&amp;', 'act=',$desired_act,
                                '&amp;', 'scene=',$desired_scene)
                            return <div class="row">
                                    <a href="index.html?{$params}">
                                        <strong>{$speaker}</strong>
                                    </a>
                                </div>
                    }
                    </div>
                </div>
            </div>
       </div>
       <div class="accordion panel-group" id="accordion_outline">
            <div class="accordion-group panel panel-default">
                <div class="accordion-heading panel-heading">
                  <h4 class="panel-title">
                      <a class="accordion-toggle collapsed" 
                        data-toggle="collapse" 
                        data-parent="#accordion_outline"
                        href="#collapse_outline">
                        Content
                      </a>
                  </h4>
                </div>
                <div id="collapse_outline" 
                    class="accordion-body collapse panel-body">
                    <div class="accordion-inner">
                        {
                        for $elem in $scene/* return
                            if($elem/name() = 'SPEECH') then local:display-speech($elem)
                            else if($elem/name() = 'STAGEDIR') then
                                <p class="stagedir">{$elem/text()}</p>
                                else ()
                        }
                    </div>
                </div>
            </div>
       </div>
    </div>
};

declare function local:display-speech($speech_list as node()*){
   for $speech in $speech_list
   return <div class="row speech">
            <div class="col-sm-3 col-md-2"><p class="speech-speaker text-bold">{
                if ($speech/SPEAKER/text()) then
                    $speech/SPEAKER/text()
                else 'NARRATOR'
            }</p></div>
            <div class="col-sm-9 col-md-10">{
                for $line in $speech/LINE
                return <p class="speech-line">{$line/text()}</p>
            }</div>
        </div>
};

let $plays := collection('apps/demo/data')//PLAY,
    $play := $plays[descendant::PLAYSUBT/text() = 'ROMEO AND JULIET'],
    $char := 'ROMEO',
    $act := '',
    $scene := '',
    $personas := $play/PERSONAE//PERSONA,
    $speakers :=  distinct-values($play//SPEECH/SPEAKER/text())

return local:display-scene($play, '2', '4')


       