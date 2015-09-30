xquery version "3.0";

(: exist variables :)        
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(: Other variables :)
declare variable $home-page-url := "index";
 
(: If trailing slash is missing, put it there and do a browser-redirect :)
if($exist:path eq "") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>
    
(: If there is no resource specified, browser-redirect to home page.
 : Because this is a browser redirct, the request will pass through the controller again :)
else if($exist:resource eq "") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{$home-page-url}"/>
    </dispatch>

(: home page :)
else if($exist:resource eq 'index') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/xquery/people_facets.xq")}">
            <set-attribute name="collection" value="{concat($exist:root, $exist:controller, "/data")}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, "/xsl/facets2index.xsl")}"/>   
            </forward>
        </view>
    </dispatch>  

(: Below is the part you need to edit to make the site work! 
 : 
 : The idea is have the "people" resource match 
 : forward to the "people.xq" XQuery and then sent to the 
 : view based on an XSLT transform using the "people.xsl" XSL
 : 
 : The main structure is set up below -- you'll just need to add
 : in the details to point to the XQuery and the XSLT.  
 : Use the example for the 'index' page above to see how that is configured
 : :)
else if($exist:resource eq 'people') then
     <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
         <forward url="{concat($exist:controller, "/xquery/people.xq")}">
             <set-attribute name="collection" value="{concat($exist:root, $exist:controller, "/data")}"/>
       </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, "/xsl/people.xsl")}"/>        
                <set-attribute name="xslt.view" value="{request:get-parameter('view','table')}" />
                <set-attribute name="xslt.querystring" value="{request:get-query-string()}"/>
            </forward>
        </view>
    </dispatch>    
    
(: everything is passed through :)
else
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>