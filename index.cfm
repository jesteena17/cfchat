<!DOCTYPE HTML>
<html>
<head>
	<title>Pusher And ColdFusion Powered Chat</title>
	<style type="text/css">

		form {
			width: 500px ;
			}

		#chatLog {
			background-color: #FAFAFA ;
			border: 1px solid #D0D0D0 ;
			height: 200px ;
			margin-bottom: 10px ;
			overflow-x: hidden ;
			overflow-y: scroll ;
			padding: 10px 10px 10px 10px ;
			width: 480px ;
			}

		#handle {
			float: left ;
			margin-bottom: 5px ;
			}

		#handleLabel {
			font-weight: bold ;
			}

		#handleTools {
			font-size: 90% ;
			font-style: italic ;
			}

		#handleTools a {
			color: #333333 ;
			}

		#typeNote {
			color: #999999 ;
			display: none ;
			float: right ;
			font-style: italic ;
			background-color:red;
			}

		#message {
			clear: both ;
			font-size: 16px ;
			width: 420px ;
			}

		#submit {
			font-size: 16px ;
			width: 70px ;
			}

		div.chatItem {
			border-bottom: 1px solid #F0F0F0 ;
			margin: 0px 0px 3px 0px ;
			padding: 0px 0px 3px 0px ;
			}

		div.chatItem span.handle {
			color: blue ;
			font-weight: bold ;
			}

		div.myChatItem span.handle {
			color: red ;
			}

	</style>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.4.4/jquery.js"></script>
	<script type="text/javascript" src="http://js.pusherapp.com/1.4/pusher.min.js"></script>
	<script src="https://js.pusher.com/7.0.3/pusher.min.js"></script>
	<script type="text/javascript">

		WebSocket.__swfLocation = "./WebSocketMain.swf";

		$(function(){

		
			<cfoutput>
				var userID = "#createUUID()#";
			</cfoutput>

			var server = new Pusher(
				"9615e51bcd47798d3738",
				{cluster: 'ap2'}
			);

			// Get references to our DOM elements.
			var form = $( "form" );
			var chatLog = $( "#chatLog" );
			var handleLabel = $( "#handleLabel" );
			var handleToggle = $( "#handleTools a" );
			var typeNote = $( "#typeNote" );
			var typeLabel = $( "#typeLabel" );
			var message = $( "#message" );

			handleToggle
				.attr( "href", "javascript:void( 0 )" )
				.click(
					function( event ){
						// Prevent default click.
						event.preventDefault();

						// Prompt user for new name.
						handleLabel.text(
							prompt( "New Handle:", handleLabel.text() )
						);

						
						message.focus();
					}
				)
			;

		
			form.submit(
				function( event ){

					event.preventDefault();

				
					if (!message.val().length){
						return;
					}

					// Send the message to the server.
					$.get(
						"./send.cfm",
						{
							userID: userID,
							handle: handleLabel.text(),
							message: message.val()
						},
						function(){
							// Clear the message and refocus it.
							message
								.val( "" )
								.focus()
							;
						}
					).done(function( data ) {
    alert( "Dataww Loaded: " + data );
  });;

					clearTimeout( message.data( "timer" ) );

				
					message.data( "isTyping", false );

					$.get(
						"./type.cfm",
						{
							userID: userID,
							handle: handleLabel.text(),
							isTyping: false
						}
					).done(function( data ) {
    alert( "Data00 Loaded: " + data );
  });;

				}
			);

			
			message.keydown(
				function( event ){

				
					clearTimeout( message.data( "timer" ) );

			
					if (message.data( "isTyping" )){
						return;
					}

			
					message.data( "isTyping", true );

				
					$.get(
						"./type.cfm",
						{
							userID: userID,
							handle: handleLabel.text(),
							isTyping: true
						}
					).done(function( data ) {
    alert( "Data0 Loaded: " + data );
  });;

				}
			);

			message.keyup(
				function( event ){

					clearTimeout( message.data( "timer" ) );

					message.data(
						"timer",
						setTimeout(
							function(){
								
								message.data( "isTyping", false );

							
								$.get(
									"./type.cfm",
									{
										userID: userID,
										handle: handleLabel.text(),
										isTyping: false
									}
								).done(function( data ) {
    alert( "Data1 Loaded: " + data );
  });;
							},
							750
						)
					);

				}
			);

		
			server.bind(
				"messageEvent",
				function( chatData ) {

					var chatItem = $(
						"<div class='chatItem'>" +
							"<span class='handle'>" +
								chatData.handle +
							"</span>: " +
							"<span class='message'>" +
								chatData.message +
							"</span>" +
						"</div>"
					);

				
					if (chatData.userID == userID){

						// Add the "mine" item.
						chatItem.addClass( "myChatItem" );

					}

				
					chatLog.append( chatItem );

					chatLog.scrollTop( chatLog.outerHeight() );

				}
			);

			server.bind(
				"typeEvent",
				function( typeData ){

					if (typeData.userID == userID){
						return;
					}

					if (typeData.isTyping){

						// Set the typing label.
						typeLabel.text( typeData.handle );

						// Set the REL attribute.
						typeLabel.attr( "rel", typeData.userID );

						// Show the label.
						typeNote.show();

			
					} else if (typeLabel.attr( "rel" ) == typeData.userID){

						// Hide the note.
						typeNote.hide();

					}

				}
			);

		});

	</script>
</head>
<body>

	<h1>
		Pusher And ColdFusion Powered Chat
	</h1>

	<form>

		<div id="chatLog">
			<!--- To be populated dynamically. --->
		</div>

		<div id="handle">
			<span id="handleLabel">RandomDude</span>
			<span id="handleTools">( <a>Change Handle</a> )</span>
		</div>

		<div id="typeNote" style="border:3px solid green !important" >
			<span id="typeLabel" rel="">Unknown</span> is typing.
		</div>

		<div id="messageTools">
			<input id="message" type="text" name="message" />
			<input id="submit" type="submit" value="SEND" />
		</div>

	</form>

</body>
</html>