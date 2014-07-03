// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel({text: "Localytics"});
win.add(label);
win.open();

// Require the Module
var localytics = require('pw.localytics');
Ti.API.info("module is => " + localytics);

// Init Session
localytics.initSession( "73751065ccb7f4d7d24443e-0668acde-eb25-11e3-9e52-009c5fda0a25" );

// Register for push
Ti.Network.registerForPushNotifications({
	callback: function(evt){
		if( !evt.inBackground ) {
			alert( JSON.stringify(evt.data) );
		}
	},
	error: function(evt){
		Ti.API.error( "Code: " + evt.code + " - " + evt.error );
	},
	success: function(evt){
		localytics.registerForPush( evt.deviceToken );
	},
	types: [
		Titanium.Network.NOTIFICATION_TYPE_ALERT,
		Titanium.Network.NOTIFICATION_TYPE_SOUND
	]
});

// Log a visit to the Home Screen
localytics.logScreen("Home");

// Log an App Started event with some additional information
localytics.logEvent("App Started", {foo: "bar"});