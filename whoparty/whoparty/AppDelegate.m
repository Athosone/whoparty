//
//  AppDelegate.m
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import <NUI/NUIAppearance.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "WPHelperConstant.h"
#import "Event.h"
#import "WPLoginViewController.h"

@interface AppDelegate ()

- (void) handleMyPushNotification:(NSDictionary*)notificationPayload;

@end

@implementation AppDelegate


- (void) handleMyPushNotification:(NSDictionary*)notificationPayload
{
    NSString *eventId = [notificationPayload objectForKey:@"eventId"];
    
    Event *event = [Event objectWithoutDataWithClassName:@"Event" objectId:eventId];
    
    [event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error)
            NSLog(@"Error receing notfication in didFinishLaunchingWithOptions, erorr: %@", error);
        else
        {
            PFObject *sendinguser = [object objectForKey:@"sendinguser"];
            [sendinguser fetchIfNeededInBackgroundWithBlock:^(PFObject *sendingUserObject, NSError *error) {
                
                if (!error)
                {
                    
                   [event setObject:sendingUserObject forKey:@"sendinguser"];
                    [sendingUserObject pinInBackground];
                    [object pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                     {
                        if (succeeded)
                        {
                            
                            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:object, @"event", nil];
                            NSNotification *notification = [[NSNotification alloc] initWithName:HASRECEIVEDPUSHNOTIFICATION object:nil userInfo:event];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                        else
                        {
                            NSLog(@"AppDelegate-HandlePushNotification-Error pinning Event object\nerror: %@", error);
                        }
                    }];
                }
                else
                    NSLog(@"AppDelegate-HandlePushNotification-Error fetchIfNeeded sendinguser object\nerror: %@", error);

            }];
        }
    }];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    //Receiving push when open from notfication
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (notificationPayload)
    {
        [self handleMyPushNotification:notificationPayload];
    }
    
    
    [NUISettings initWithStylesheet:@"WPTheme"];
   
    NSDictionary *attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIBarItem appearance] setTitleTextAttributes:attrs
                                          forState:UIControlStateNormal];
    [UIBarButtonItem configureFlatButtonsWithColor:DEFAULTNAVBARITEMBGCOLOR
                                  highlightedColor:DEFAULTNAVBARITEMBGCOLOR
                                      cornerRadius:3];
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"I2MSBxXHEXCm3uULbcYF5Io7tH1xu8bZVMx0Eryw"
                  clientKey:@"KB7nVbC7d3D8lLRZm9rjlQhdmEzuL0yRsG9dXBMb"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [GMSServices provideAPIKey:GOOGLEIOSAPIKEY];
   
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //Right, that is the point
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    
    NSLog(@"Notification received userinfo:%@", userInfo);
    [self handleMyPushNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.nyuwebdeveloppement.whoparty" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"whoparty" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"whoparty.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
