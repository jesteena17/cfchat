
<cfparam name="url.userID" type="string" default="" />
<cfparam name="url.handle" type="string" default="" />
<cfparam name="url.message" type="string" default="" />





<cfset pusherAppID = "1423839" />
<cfset pusherKey = "9615e51bcd47798d3738" />
<cfset pusherSecret = "ba809b9a851a68a6dc2e" />
<cfset pusherChannel = "chat" />

<cfset pusherEvent = "messageEvent" />


<cfset chatData = {} />
<cfset chatData[ "userID" ] = url.userID />
<cfset chatData[ "handle" ] = htmlEditFormat( url.handle ) />
<cfset chatData[ "message" ] = htmlEditFormat( url.message ) />


<cfset pusherData = serializeJSON( chatData ) />


<cfset authVersion = "1.0" />
<cfset authMD5Body = lcase( hash( pusherData, "md5" ) ) />
<cfset authTimeStamp = fix( getTickCount() / 1000 ) />


<cfset pusherResource = "/apps/#pusherAppID#/channels/#pusherChannel#/events" />



<cfsavecontent variable="queryStringData">
	<cfoutput>
		auth_key=#pusherKey#
		auth_timestamp=#authTimeStamp#
		auth_version=#authVersion#
		body_md5=#authMD5Body#
		name=#pusherEvent#
	</cfoutput>
</cfsavecontent>


<cfset signatureData = (
	("POST" & chr( 10 )) &
	(pusherResource & chr( 10 )) &
	reReplace(
		trim( queryStringData ),
		"\s+",
		"&",
		"all"
		)
	) />


<cfset secretKeySpec = createObject(
	"java",
	"javax.crypto.spec.SecretKeySpec"
	).init(
		toBinary( toBase64( pusherSecret ) ),
		"HmacSHA256"
		)
	/>


<cfset mac = createObject( "java", "javax.crypto.Mac" )
	.getInstance( "HmacSHA256" )
	/>


<cfset mac.init( secretKeySpec ) />


<cfset encryptedBytes = mac.doFinal( signatureData.getBytes() ) />



<cfset bigInt = createObject( "java", "java.math.BigInteger" )
	.init( 1, encryptedBytes )
	/>

<cfset secureSignature = bigInt.toString(16) />


<cfset secureSignature = replace(
	lJustify( secureSignature, 32 ),
	" ",
	"0",
	"all"
	) />




<cfhttp
	result="result"
	method="post"
	url="http://api.pusherapp.com#pusherResource#">


	<cfhttpparam
		type="header"
		name="content-type"
		value="application/json"
		/>



	<cfhttpparam
		type="url"
		name="auth_version"
		value="#authVersion#"
		/>

	<cfhttpparam
		type="url"
		name="auth_key"
		value="#pusherKey#"
		/>

	<cfhttpparam
		type="url"
		name="auth_timestamp"
		value="#authTimeStamp#"
		/>

		<cfhttpparam
		type="url"
		name="body_md5"
		value="#authMD5Body#"
		/>

	<cfhttpparam
		type="url"
		name="name"
		value="#pusherEvent#"
		/>

	<cfhttpparam
		type="body"
		value="#pusherData#"
		/>

	
	<cfhttpparam
		type="url"
		name="auth_signature"
		value="#secureSignature#"
		/>

</cfhttp>

<cfdump var=#result#/>

<cfcontent
	type="text/plain"
	variable="#toBinary( toBase64( 'success' ) )#"
	/>