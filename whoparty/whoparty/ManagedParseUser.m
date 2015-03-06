//
//  ManagedParseUser.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ManagedParseUser.h"
#import "WPHelperConstant.h"
#import "Event.h"

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

+ (void) fetchGoogleAddress:(MYGoogleAddress*)googleAddressTofetch target:(id)target selector:(SEL)selector
{
    [googleAddressTofetch fetchFromLocalDatastoreInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (error)
        {
            NSLog(@"WPReceiveEventViewController-viewdidload-Error fetchinglocaldatastore trying server mygoogleaddress, error: %@", error);
            [googleAddressTofetch fetchInBackgroundWithBlock:^(PFObject *object, NSError *error)
             {
                 if (error)
                     NSLog(@"WPReceiveEventViewController-viewdidload-Error fetching online mygoogleaddress, error: %@", error);
                 else
                     [object pinInBackground];
                 if ([target respondsToSelector:selector])
                     [target performSelectorOnMainThread:selector withObject:object waitUntilDone:YES];
                 else
                     NSLog(@"Error selector non declared in the target passed as parameters");
             }];
        }
        else
        {
            if (object)
            {
                if ([target respondsToSelector:selector])
                    [target performSelectorOnMainThread:selector withObject:object waitUntilDone:YES];
                else
                    NSLog(@"Error selector non declared in the target passed as parameters");
            }
        }
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

+ (void) fetchLocalEvents:(id)target selector:(SEL)selector
{
    PFQuery      *query = [[PFQuery alloc] initWithClassName:@"Event"];
    
    [query fromLocalDatastore];
    [query whereKey:@"isReceived" equalTo:[NSNumber numberWithBool:NO]];
    [query orderByDescending:@"createdDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        if (!error)
        {
            Event *event = [results objectAtIndex:0];
            
            __block PFUser *sendinguser = [event objectForKey:@"sendinguser"];
            
            PFQuery *querySendingUser = [[PFQuery alloc] initWithClassName:@"_User"];
            [querySendingUser fromLocalDatastore];
            [querySendingUser whereKey:@"objectId" equalTo:sendinguser.objectId];

            [querySendingUser getFirstObjectInBackgroundWithBlock:^(PFObject *sendinguser, NSError *error) {
                [event setObject:sendinguser forKey:@"sendinguser"];
                
                if ([target respondsToSelector:selector])
                    [target performSelectorOnMainThread:selector withObject:results waitUntilDone:YES];
                else
                    NSLog(@"Error selector non declared in the target passed as parameters");
            }];
        }
        else
            NSLog(@"Error fetching local events: %@", error);
    }];

}

@end
