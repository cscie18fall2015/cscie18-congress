xquery version "3.0" encoding "UTF-8";

declare namespace local = "http://cscie18.dce.harvard.edu/congress";

(: lookup function :)
declare function local:expand
  ( $arg as xs:string? )  as xs:string {
    if (exists($col/abbreviations/abbr[@short eq $arg]/@long))
    then $col/abbreviations/abbr[@short eq $arg]/@long
    else $arg
 } ;
 
declare variable $col_path := request:get-attribute('collection');
declare variable $col := collection($col_path);

declare variable $state := request:get-parameter('state','*');
declare variable $party := request:get-parameter('party','*');
declare variable $type := request:get-parameter('type','*');

declare variable $people := $col/congress/person[exists(terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()])];

<congress>
    <filters>
    {
        for $s in $state
        return <filter name="state" value="{$s}"/>
    }
     {
        for $s in $type
        return <filter name="type" value="{$s}"/>
    }    {
        for $s in $party
        return <filter name="party" value="{$s}"/>
    }       

    </filters>

    {
        for $p in $col/congress/person
        let $current_term := $p/terms/term[
        xs:date(start) <= current-date()
        and xs:date(end) >= current-date()
        ]
        where 
        ($current_term/state = $state or '*' = $state )
        and
        ($current_term/type = $type or '*' = $type)
        and 
        ($current_term/party = $party or '*' = $party)
        order by $p/name/last,
            $p/name/first
        return
            $p
    }
    
    <facets>
       <facet name="state" title="State">
       {
           for $item in distinct-values($col/congress/person/terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()]/state)
           order by local:expand($item)
           return
               <item code="{$item}">{local:expand($item)}</item>
       }
       </facet>
   
       <facet name="type" title="House">
       {
           for $item in distinct-values($col/congress/person/terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()]/type)
           order by local:expand($item)
           return
               <item code="{$item}">{local:expand($item)}</item>
       }
       </facet>
       
       <facet name="party" title="Political Party">
       {
           for $item in distinct-values($col/congress/person/terms/term[xs:date(start) <= current-date() and xs:date(end) >= current-date()]/party)
           order by local:expand($item)
           return
               <item code="{$item}">{local:expand($item)}</item>
       }
       </facet>
    </facets>
</congress>