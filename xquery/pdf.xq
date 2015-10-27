xquery version "1.0" encoding "UTF-8";

import module namespace xslfo="http://exist-db.org/xquery/xslfo";
import module namespace local='http://cscie18.dce.harvard.edu/congress' at 'functions.xqm';

let $source-document := local:people()
let $xslt-document := doc('../xsl/people-fo.xsl')
let $parameters := 
<parameters>
    <param name="view" value="{request:get-parameter('view','table')}"/>
    <param name="param2" value="value2"/>
</parameters>

let $xslfo-document  := transform:transform($source-document,$xslt-document,$parameters)
let $media-type as xs:string := "application/pdf"

return   
    response:stream-binary(
        xslfo:render($xslfo-document, $media-type, ()),
        $media-type,
        "people.pdf"
    )