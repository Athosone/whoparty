//
//  ManagedParseUser.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ManagedParseUser.h"
#import "WPHelperConstant.h"

@implementation ManagedParseUser

+ (void)fetchFriendsListForUser:(PFUser*) user target:(id)target selector:(SEL)selector
{
    PFQuery      *query = [[PFQuery alloc] initWithClassName:@"_User"];
    
    
    
    [query selectKeys:@[@"friendsId"]];
    [query whereKey:@"objectId" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        PFUser *user = (PFUser*)[results objectAtIndex:0];
        NSArray *friendsId = [user objectForKey:@"friendsId"];
        
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:friendsId waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }];
}

+ (void)fetchFriendUserByUsername:(NSString*)username target:(id)target selector:(SEL)selector
{
    PFQuery      *query = [[PFQuery alloc] initWithClassName:@"_User"];
    
    
    [query selectKeys:@[@"username", @"friendsId"]];
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        PFUser *user = nil;
        if (results.count > 0)
        {
            user = (PFUser*)[results objectAtIndex:0];
            NSLog(@"user.username: %@", user.username);
        }
        else
            NSLog(@"No User found");
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:user waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }];
}

+ (void) sendNotificationPush:(PFUser*)user data:(NSDictionary*)data
{
    
    NSString *channel = [CHANNELUSERPREFIX stringByAppendingString:user.objectId];
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"channels" equalTo:channel]; // Set channel
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    if (data)
        [push setData:data];
    
    NSLog(@"Channel: %@, Data: %@", channel, data);
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            NSLog(@"Notification sucessfully sent");
        else
            NSLog(@"Fail sending notification, error: %@", error);
    }];
}

@end
