//
//  Event.h
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import "MYGoogleAddress.h"

@interface Event : PFObject<PFSubclassing>

+ (NSString*)parseClassName;

@property (strong, nonatomic) MYGoogleAddress *mygoogleaddress;
@property (strong, nonatomic) NSString          *sendinguser;
@property (strong, nonatomic) NSString        *comment;
@property (readwrite, nonatomic) BOOL         isReceived;
@property (readwrite, nonatomic) BOOL         isAccepted;
@property (strong, nonatomic) NSString        *receivinguser;
@property (strong, nonatomic) NSArray         *usersConcerned;
@property (strong, nonatomic) NSString        *groupName;
@property (strong, nonatomic) NSArray         *usersAccepted;
@property (strong, nonatomic) NSArray         *usersDeclined;

@end
