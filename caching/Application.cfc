<cfcomponent>
     <cfset this.name = "cachetestapp">
     <cfset this.clientStorage="Cookie"/>
     <cfset this.Sessionmanagement = TRUE>
     <cfset this.sessionTimeout = CreateTimeSpan(0, 0, 20, 0)/>
     <cfset this.clientManagement = true>
     <cfset this.setClientCookies = true /> 
     <cfset this.datasource="testdbdsn" />
     <cfset Application.ProductCache=true/>
    </cfcomponent>