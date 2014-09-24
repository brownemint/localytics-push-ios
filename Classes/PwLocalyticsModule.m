/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "PwLocalyticsModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "LocalyticsSession.h"

@implementation PwLocalyticsModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"097599aa-1911-43cf-8249-d13214ff97eb";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"pw.localytics";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma mark Localytics

-(void)initSession:(id)key
{
    ENSURE_SINGLE_ARG(key, NSString);
    [[LocalyticsSession shared] LocalyticsSession:key];
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

-(void)pauseSession
{
    // 16/09/2014 - Reversed order to upload first and then close
    [[LocalyticsSession shared] upload];
    [[LocalyticsSession shared] close];
}

-(void)resumeSession
{
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

-(void)registerForPush:(id)deviceToken
{
    ENSURE_SINGLE_ARG(deviceToken, NSString);
    [[LocalyticsSession shared] setPushToken:deviceToken];
}

-(void)logEvent:(id)args
{
    NSString *name = [TiUtils stringValue:[args objectAtIndex:0]];
    
    if ( [args objectAtIndex:1] != nil )
    {
        NSDictionary *options = (NSDictionary *)[args objectAtIndex:1];
        [[LocalyticsSession shared] tagEvent:name attributes:options];
    }
    else
    {
        [[LocalyticsSession shared] tagEvent:name];
    }
    
    // Upload event information as soon as it is triggered!
    [[LocalyticsSession shared] upload];
}

-(void)logScreen:(id)args
{
    NSString *name = [TiUtils stringValue:[args objectAtIndex:0]];
    [[LocalyticsSession shared] tagScreen:name];
}

#pragma mark App Delegate Methods

/*+(void) load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLaunching:) name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
}*/

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Did Receive Remove Notification: Localytics");
    
    [[LocalyticsSession shared] handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Did Receive Remove Notification: Localytics");
    
    // Handle situation when device is inActive!
    [[LocalyticsSession shared] handleRemoteNotification:userInfo];
}*/

/*-(void)finishedLaunching:(NSDictionary *)launchOptions
{
    NSLog(@"Did Finish Launching with Options: Localytics");
    
    if ([[launchOptions allKeys] containsObject:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        [[LocalyticsSession shared] resume];
        [[LocalyticsSession shared] handleRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
}*/

@end
