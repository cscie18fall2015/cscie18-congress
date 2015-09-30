xquery version "3.0" encoding "UTF-8";

declare namespace functx = "http://www.functx.com";

declare variable $stateseq := ('MA','CT','VT');

declare variable $state := request:get-parameter('state','*');
declare variable $party := request:get-parameter('party','*');

declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {

   $value = $seq
 };
 
<test>
<test name="stateseq" value="{$stateseq}"/>
<test name="state" value="{$state}"/>
<test name="party" value="{$party}"/>
<test desc="MA in $state" result="{if ('MA' eq $state) then true() else false()}"/>
<test desc="TX in $state" result="{if (functx:is-value-in-sequence('TX',$state)) then true() else false()}"/>   
<test desc="* in $state" result="{if (functx:is-value-in-sequence('*',$state)) then true() else false()}"/>    
{
        for $s in $stateseq
        return
            <item>{$s}</item>
    }
</test>