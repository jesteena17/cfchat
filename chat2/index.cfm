<cfwebsocket name="chatWS" onMessage="msgHandler">

<!DOCTYPE html>
<html>
<head>
    <title>Chat</title>
	<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1" />	
	<meta name="description" content="" />
	<meta name="keywords" content="" />

	<link rel="stylesheet" href="bootstrap.min.css">
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
	<script type="text/javascript" src="bootstrap-modal.js"></script>
	<script type="text/javascript">
	var username="";
	function msgHandler(message){
console.dir(message);
		if (message.type == "data") {
			if (message.data.type == "chat") {
				$("#chatlog").append(message.data.username + " says: " + message.data.chat + "\n");
				$("#chatlog").scrollTop($('#chatlog')[0].scrollHeight);
			}
			else if (message.data.type == "subscribe") {
					$("#chatlog").append(message.data.chat + "\r");
					$("#chatlog").scrollTop($('#chatlog')[0].scrollHeight);
			} else if (message.type == "data") {
				console.log("redraw list");
				var list = message.data.list.join(", ");
				$("#userCount").html(list);
			}
		}

		//handle failed sub
		if (message.type == "subscribe" && message.code == -1) {
			$("#modalerror").text("Username already taken!");
		}
		
		//handle subscription
		if(message.type == "response" && message.reqType == "subscribe") {
			msg = {
				type: "subscribe",
				username: username,
				chat: username+" joins the chat."
			};
			chatWS.publish("chat",msg);

			$("#usernamemodal").modal("hide");

			window.setInterval(function(){
				chatWS.invokeAndPublish("chat", "stats","getUserList");
			},2000);

		}
		
		//handle user count
		if(message.type == "response" && message.reqType == "getSubscriberCount") {
			$("#userCount").text(message.subscriberCount);
		}
	}


	$(function() {
		
		$("#usernamemodal").modal({
			backdrop:"static",
			show:true
		});

		$("#usernamebutton").click(function() {
			var u = $.trim($("#username").val());
			if (u == "") {
				return;
			}
			username=u;
			chatWS.subscribe("chat", {userinfo: {
				username: u
			}});
			
		});
		
		$("#sendmessagebutton").click(function() {
			var txt = $.trim($("#newmessage").val());
			if(txt == "") return;
			msg = {
				type: "chat",
				username: username,
				chat: txt
			};
			chatWS.publish("chat",msg);
			$("#newmessage").val("");
		});

		$(document).keypress(function(e) {
		    if(e.keyCode == 13) {
				//if not logged in, fire that,else chat
				if(username=="") $("#usernamebutton").trigger("click"); 
				else $("#sendmessagebutton").trigger("click")
		    }
		});
		
	});	
	</script>
	<style>
	#chatlog {
		width: 100%;
		height: 300px;	
	}
	#newmessage {
		width: 78%;
	}
	#sendmessage {
		width: 20%;
	}
	
	#modalerror {
		color: red;
	}
	</style>
</head>
<body>

	<div class="container">

	<h2>Obligatory Chat Demo</h2>
	
	<textarea id="chatlog"></textarea>
	<input type="text" id="newmessage">
	<input type="button" id="sendmessagebutton" value="Chat" class="btn primary">
	<p>Users Present: <span id="userCount"></span></p>
	</div>

	<div id="usernamemodal" class="modal hide fade">

		<div class="modal-header">
		<h3>Pick a Username</h3>
		</div>
		<div class="modal-body">
		<p>
		Enter a username:
		<input type="text" id="username" value=""> <span id="modalerror"></span>
		</p>
		</div>
		<div class="modal-footer">
		<a href="#" id="usernamebutton" class="btn primary">Enter</a>
		</div>
			
	</div>
	
</body>
</html>