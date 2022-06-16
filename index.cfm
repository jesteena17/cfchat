
<cfwebsocket
  name="chatWS"
  onMessage="messageHandler"
  onError="errorHandler"
  onOpen="openHandler"
  onClose="closeHandler"
  subscribeTo="chat" />
<doctype html>
<html>
	<head>
		<script
			src="https://code.jquery.com/jquery-3.1.0.min.js"
			integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s="
			crossorigin="anonymous">
		</script>
		<script type="text/javascript">
			messageHandler =  function(aEvent,aToken) {
				if (aEvent.data) {
					$( "#myChatArea" ).append( aEvent.data  + "<br />");
				}
			}

         	openHandler = function() {

			}

			closeHandler= function() {
				// What happens when the connection to the web socket is closed.
			}

			errorHandler = function() {
				alert("An error occured. Please try again at a later time.");
				console.log(arguments);
			}

			sendMessage = function() {
				chatWS.authenticate("test","pass");
				var msg2Send = $( "#myMessage" ).val();
				if (msg2Send) {
					chatWS.publish("chat", msg2Send);
				}
			}
    	</script>
    	<style>
    		.small {font-size:.75em;}
    		#myChatArea {
    			display:block;
    			overflow:scroll;
    			border:1px solid black;
    			width: 300px;
    			height: 375px;
    			margin-bottom: 10px;
    		}
    		#myMessage {
    			width: 202px;
    		}
    		#myButton {
    			width:100px;
    		}
    	</style>
	</head>
	<body>
		<div id="myChatArea"><cfoutput>#Application.chatHistory#</cfoutput></div>
		<input type="text" id="myMessage" /><input id="myButton" type="button" value="Send Message" onClick="sendMessage()" />
	</body>
</html>

