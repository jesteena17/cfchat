
<cfscript>
component extends="CFIDE.websocket.ChannelListener" {
 
 public any function beforeSendMessage(any message, Struct publisherInfo) {					
    return message;
  }
      
  public any function beforePublish(any message, Struct publisherInfo) {
    message = "" & publisherInfo.connectionInfo.username & ":" & StripHTML(message);
    Application.chatHistory &= message & "
"; 
    return message;
  } 	
	
  private function StripHTML(str){
    return REReplaceNoCase(str,"<[^>]*>","","ALL");		 
  }   		

}
</cfscript>