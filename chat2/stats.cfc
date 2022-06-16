component {

	remote function getUserList() {
		var users = [];
		arrayEach(wsGetSubscribers('chat'), function(item) {
			arrayAppend(users, item.subscriberinfo.userinfo.username);
		});
		return {"type":"list", "list":users};
	}

}