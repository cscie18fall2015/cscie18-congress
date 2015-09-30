xquery version "3.0" encoding "UTF-8";

declare namespace cscie18 = "http://cscie18.dce.harvard.edu/";

declare variable $col_path := request:get-attribute('collection');
declare variable $col := collection($col_path);
declare variable $people := $col/congress/person[exists(terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()])];

(: lookup function :)
declare function cscie18:expand
  ( $arg as xs:string? )  as xs:string {
    if (exists($col/abbreviations/abbr[@short eq $arg]/@long))
    then $col/abbreviations/abbr[@short eq $arg]/@long
    else $arg
 } ;
 
 <facets>
    <facet name="state" title="State">
    {
        for $item in distinct-values($col/congress/person/terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()]/state)
        order by cscie18:expand($item)
        return
            <item code="{$item}">{cscie18:expand($item)}</item>
    }
    </facet>

    <facet name="type" title="House">
    {
        for $item in distinct-values($col/congress/person/terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()]/type)
        order by cscie18:expand($item)
        return
            <item code="{$item}">{cscie18:expand($item)}</item>
    }
    </facet>
    
    <facet name="party" title="Political Party">
    {
        for $item in distinct-values($col/congress/person/terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()]/party)
        order by cscie18:expand($item)
        return
            <item code="{$item}">{cscie18:expand($item)}</item>
    }
    </facet>

</facets>