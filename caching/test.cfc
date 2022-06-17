<cfcomponent>
<cffunction name="getProduct" access="public" output="true" returnType="query" hint="Get product details" >

<cfscript>

var returnQry = queryNew("");

</cfscript>

<cfcache action="get" id="testQry" name="qryObj">


<cfif isDefined("qryObj")>

<cfset returnQry = qryObj>

<cfelse>

<cfquery name="qryObj" >

SELECT * FROM products;

</cfquery>


<cfcache action="put" id="testQry" value="#qryObj#">

<cfset returnQry = qryObj>

</cfif>

<cfreturn returnQry>

</cffunction>
<cffunction name="insertProduct" access="public" returnType="void" >

<cfargument name="name" required="false" type="string">

<cfargument name="code" required="false" type="string">

<cfargument name="price" required="false" type="numeric">

<cfquery name="insertProduct">

INSERT INTO products (product_code, product_title, product_price)

VALUES(

<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.name#">

, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.code#">

, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.price#">

)

</cfquery>


<cfcache action="flush" id="testQry">

</cffunction>
</cfcomponent>