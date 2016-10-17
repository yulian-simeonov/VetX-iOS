//
//  AppDelegate.m
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Keys.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Optimizely/Optimizely.h>
#import <Rollout/Rollout.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/Analytics.h>
#import <Braintree/BraintreeCore.h>
#import "Flurry.h"
#import "SelectUserTypeViewController.h"
#import "HomeFeedViewController.h"
#import "BottomTabBarController.h"
#import "UserManager.h"
#import <pop/POP.h>
#import "QuestionManager.h"
@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

@interface AppDelegate ()

@property(nonatomic, strong) void (^registrationHandler)
(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;

@property (nonatomic, strong) UIView *splashView;
@property (nonatomic, strong) UIImageView *splashImage;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    /**
     *  Rollout setup for hot patch
     */
//    #if defined( DEBUG )
//        [Rollout setupWithDebug:YES];
//    #else
//        [Rollout setupWithDebug:NO];
//    #endif
    [self clearNotifications];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];

    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:VETX_FONT_MEDIUM_17}];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:ORANGE_THEME_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:TAB_BAR_UNSELECTED_COLOR];
    [[UITabBar appearance] setTranslucent:NO];
    
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],  NSFontAttributeName : VETX_FONT_REGULAR_12}];
    
    [self migrateRealm];
    
    // Setup firebase
    [FIRApp configure];
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];

    [Flurry startSession:@"Q4NHDZH8QDVYBFN52MSN"];
    
//    [[UserManager defaultManager] logoutCurrentUser];
    
    // Configure tracker from GoogleService-Info.plist.
//    NSError *configureError;
//    [[GGLContext sharedInstance] configureWithError:&configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    
//    [GMSServices provideAPIKey:@"AIzaSyAoOn0ZQ7O_oh5rdGi3iBy5BnT4IXLV6c4"];
    
    
    [Fabric with:@[[Crashlytics class], [Optimizely class]]];
//    [Optimizely startOptimizelyWithAPIToken:@"AANNlwYB2BMQAhBCgSIgwrq7w6ozUTwy~5310110692" launchOptions:launchOptions];



    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [BTAppSwitch setReturnURLScheme:@"com.vetx.VetX.payments"];

    /**
     *  Navigate to the right page based on [PFUser currentUser]
     */
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];

    
    UINavigationController *nav;
    
    [[UserManager defaultManager] getLatestCurrentUserInfo];
    
    if ([[UserManager defaultManager] currentUser] && [[[UserManager defaultManager] currentUser] licenseID]) {
        // Show regular Feed or unanswered questions feed based on user type
        BottomTabBarController *bottomVC = [[BottomTabBarController alloc] initWithVetMainViews];
        nav = [[UINavigationController alloc] initWithRootViewController:bottomVC];
    } else {
        BottomTabBarController *bottomVC = [[BottomTabBarController alloc] initWithUserMainViews];
        nav = [[UINavigationController alloc] initWithRootViewController:bottomVC];
    }

    [Flurry logAllPageViewsForTarget:nav];

    [nav setNavigationBarHidden:YES];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    [self showSplash];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[QuestionManager defaultManager] stopRotateFeedQuestions];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FIRMessaging messaging] disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connectToFcm];
    [FBSDKAppEvents activateApp];
    [self clearNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    return [self application:app openURL:url sourceApplication:nil annotation:@{}];
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.vetx.VetX.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
//    else if ([url.scheme localizedCaseInsensitiveCompare:@"com.vetx.VetX"] == NSOrderedSame) {
//        FIRDynamicLink *dynamicLink =
//        [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
//        
//        if (dynamicLink) {
//            // Handle the deep link. For example, show the deep-linked content or
//            // apply a promotional offer to the user's account.
//            // ...
//            return YES;
//        }
//        
//        return NO;
//    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

//- (BOOL)application:(UIApplication *)application
//continueUserActivity:(NSUserActivity *)userActivity
// restorationHandler:(void (^)(NSArray *))restorationHandler {

//    BOOL handled = [[FIRDynamicLinks dynamicLinks]
//                    handleUniversalLink:userActivity.webpageURL
//                    completion:^(FIRDynamicLink * _Nullable dynamicLink,
//                                 NSError * _Nullable error) {
//                        // ...
//                    }];
//    
//    
//    return handled;
//}

#pragma mark - Remote Notification Related Function
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = deviceToken.description;
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"[< >]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, deviceTokenString.length)];
    if ([[UserManager defaultManager] currentUser]) {
        [[UserManager defaultManager] addDeviceToken:deviceTokenString];
    }
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    NSLog(@"Did register remote notification: %@", deviceTokenString);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register remote notification: %@", [error localizedDescription]);
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
}
// [END receive_message]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)onTokenRefresh {
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@"The GCM registration token needs to be changed.");
}

// [START upstream_callbacks]
- (void)willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    if (error) {
        // Failed to send the message.
    } else {
        // Will send message, you can save the messageID to track the message
    }
}

- (void)didSendDataMessageWithID:(NSString *)messageID {
    // Did successfully send message identified by messageID
}
// [END upstream_callbacks]

- (void)didDeleteMessagesOnServer {
    // Some messages sent to this device were deleted on the GCM server before reception, likely
    // because the TTL expired. The client should notify the app server of this, so that the app
    // server can resend those messages.
}

- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)showSplash {
    
    if (!self.splashView) {
        self.splashView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.splashView setBackgroundColor:ORANGE_THEME_COLOR];
        [self.window addSubview:self.splashView];
    }
    
    if (!self.splashImage) {
        self.splashImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 225)];
        [self.splashImage setImage:[UIImage imageNamed:@"logo_vertical"]];
        self.splashImage.center = self.splashView.center;
        [self.splashView addSubview:self.splashImage];
    }
    
    POPSpringAnimation *popanim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    popanim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 300)];
    popanim.springBounciness = 20.0f;
    popanim.springSpeed = 3.0f;
    [self.splashImage.layer pop_addAnimation:popanim forKey:@"size"];
    popanim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.splashView.alpha = 0.0f;
            POPBasicAnimation *popanim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBounds];
            popanim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)];
            popanim.duration = .5f;
            [self.splashImage.layer pop_addAnimation:popanim forKey:@"size"];
        } completion:^(BOOL finished) {
            [self.splashView removeFromSuperview];
        }];
    };
    [self.window bringSubviewToFront:self.splashView];
}

- (void)migrateRealm {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 10;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 10) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
}

@end
