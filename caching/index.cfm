<cfset tickBegin = GetTickCount()> 
<cfoutput> 
    Welcome to our home page.<br> 
    The time is #TimeFormat(Now())#.<br> 
   
    <hr><br> 
    <cfquery result="res1" name="one">
  SELECT product_code, product_title
  FROM products
</cfquery>



<cfquery result="res3" name="three" >
  SELECT product_code, product_title
  FROM products
</cfquery>
1
<cfdump var=#one#/><br>2

<cfdump var=#three#/>



<cfquery result="res2" name="two" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
 SELECT product_code, product_title
  FROM products
</cfquery>

    <select name="country" id="country">
    	<cfloop query="two">
    		<option value="#two.product_code#">#two.product_title#</option>    
    	</cfloop>
    </select>
	

<cfset tickEnd = GetTickCount()>
<cfset loopTime = tickEnd - tickBegin>
<cfset loopTime = loopTime / 1000>

Messages (#loopTime# seconds)

<cfset price=10/>

<cfinvoke component = "test" method = "insertProduct" returnVariable = "res">
    <cfinvokeargument name="name" value="bag" >
     <cfinvokeargument name="code" value="bag01" >
      <cfinvokeargument name="price" value="#price#" >
</cfinvoke>
    
     
<cfinvoke component = "test" method = "getProduct" returnVariable = "res"></cfinvoke>
</cfoutput> 