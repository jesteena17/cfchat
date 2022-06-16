component extends="CFIDE.websocket.ChannelListener" {

   public boolean function allowSubscribe(struct subscriberInfo) {
   	   if(!structKeyExists(arguments.subscriberInfo, "userinfo")) return false;
   	   var attemptuser = arguments.subscriberInfo.userinfo.username;
   	   //lock me baby
   	   lock type="exclusive" timeout=30 {
			//get all users 
			var users = wsGetSubscribers('chat');
			res = arrayfind(users, function(item) {
				return item.subscriberinfo.userinfo.username eq attemptuser;
			});
			if(res) return false;
			return true;
	   }
   }

	public any function beforeSendMessage(any message, Struct subscriberInfo) {
  	  	if(structKeyExists(message, "type") && message.type == "chat") message.chat=rereplace(message.chat, "<.*?>","","all");
		return message;
	}

}