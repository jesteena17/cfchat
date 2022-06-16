 
<cfscript>
component { 
  this.name = "wsChat";
  this.applicationTimeout = createTimeSpan(0,8,0,0); 
  this.sessionTimeout = createTimeSpan(0,4,0,0); 
  this.sessionManagement = true; 
  this.setClientCookies = false; 	
  this.scriptProtect = "all";
		
  this.wsChannels = [{
   name: "chat",
   cfcListener: "wsChatApplication"
  }];
 
  public boolean function  onWSAuthenticate(String username, String password, Struct connectionInfo) {
  
    connectionInfo.username=username;
    return true;     
  }
	
  public boolean function onApplicationStart() {
     Application.chatHistory = ""; 	 
     return true; 
  } 
	
  public void function onRequestEnd() {
    if( structKeyExists(url, "reset") ) {			
      ApplicationStop();
      onApplicationStart();
    } 
    return; 
  } 
	
}

</cfscript>