//
//  ManagedParseUser.h
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MYGoogleAddress.h"

@interface ManagedParseUser : NSObject

@property (strong, nonatomic) NSOperationQueue *operationQueue;

+ (id) sharedInstance;
+ (void) addOperationToQueue:(NSOperation*) op;


+ (void)fetchFriendsListForUser:(PFUser*) user target:(id)target selector:(SEL)selector;

+ (void)fetchFriendUserByUsername:(NSString*)username target:(id)target selector:(SEL)selector;
+ (void) sendNotificationPush:(NSString*)usernameDest data:(NSDictionary*)data;
+ (void) fetchLocalEvents:(id)target selector:(SEL)selector;
+ (void) fetchGoogleAddress:(MYGoogleAddress*)googleAddressToFetch target:(id)target selector:(SEL)selector;
+ (void) updateEvent:(NSString*)eventId target:(id)target selector:(SEL)selector data:(NSDictionary*)data;

@end
