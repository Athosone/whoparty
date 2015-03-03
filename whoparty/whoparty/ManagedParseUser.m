//
//  ManagedParseUser.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ManagedParseUser.h"

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
    
    
    
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        if (results.count > 0)
        {
            PFUser *user = (PFUser*)[results objectAtIndex:0];
            NSLog(@"user.username: %@", user.username);
            if ([target respondsToSelector:selector])
                [target performSelectorOnMainThread:selector withObject:user waitUntilDone:YES];
            else
                NSLog(@"Error selector non declared in the target passed as parameters");
        }
        else
            NSLog(@"No User found");
    }];
  
}


@end
