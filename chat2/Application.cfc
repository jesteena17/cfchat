component {
	this.name="websocket_chat_apps_are_dumb_2b";

	this.wschannels = [
		{name="chat",cfclistener:"chatws"}
	];
	
	public boolean function onApplicationStart() {
		return true;
	}

	public boolean function onRequestStart(string req) {
		if(structKeyExists(url,"init")) {
			applicationStop();
			location(url="index.cfm",addToken="false");
		}
		return true;
	}

}