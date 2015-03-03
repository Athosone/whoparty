//
//  ManagedParseUser.h
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ManagedParseUser : NSObject

+ (void)fetchFriendsListForUser:(PFUser*) user target:(id)target selector:(SEL)selector;

+ (void)fetchFriendUserByUsername:(NSString*)username target:(id)target selector:(SEL)selector;

@end
