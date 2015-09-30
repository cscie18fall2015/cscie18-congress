xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection');
declare variable $col := collection($col_path);

declare variable $state := request:get-parameter('state','*');
declare variable $party := request:get-parameter('party','*');
declare variable $type := request:get-parameter('type','*');

<congress>
    <filters>
        <filter name="state" value="{$state}"/>
        <filter name="party" value="{$party}"/>
        <filter name="type" value="{$type}"/>
    </filters>
    {
        for $p in $col/congress/person
        let $current_term := $p/terms/term[
        xs:date(start) <= current-date()
        and xs:date(end) >= current-date()
        ]
        where 
        ($state eq '*' or $current_term/state eq $state)
        and
        ($type eq '*' or $current_term/type eq $type)
        and 
        ($party eq '*' or $current_term/party eq $party)
        order by $p/name/last,
            $p/name/first
        return
            $p
    }
</congress>