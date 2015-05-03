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
+ (void) fetchLocalEvents:(id)target selector:(SEL)selector;
+ (void) fetchGoogleAddress:(MYGoogleAddress*)googleAddressToFetch target:(id)target selector:(SEL)selector;

+ (void) createEvent:(PFObject*)event success:(void(^)())success;
+ (void) updateEventWithCompletionBlock:(NSString*)eventId success:(void(^)(PFObject *event))success data:(NSDictionary*)data;
+ (void) sendNotificationPush:(NSString*)usernameDest data:(NSDictionary*)data completionBlock:(void(^)())success;
+ (void) sendNotificationPushSync:(NSArray*)userConcerned data:(NSDictionary*)data;

+ (void) fetchAllEvents:(id)target selector:(SEL)selector;
+ (void) sendErrorReport:(NSError*)error;

+ (void) fetchEvent:(PFObject*)event completionBlock:(void(^)(PFObject* obj))completionBlock;
+ (void) userWithUserName:(NSString*) username completionBlock:(void(^)(PFObject*))completion;
+ (void) isUsernameExist:(NSString *) username completionBlock:(void(^)(bool))completion;
+ (void) isEmailExist:(NSString *) email completionBlock:(void(^)(bool))completion;


@end
