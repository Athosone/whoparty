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
@property (strong, nonatomic) PFUser          *sendinguser;
@property (strong, nonatomic) PFUser          *receivinguser;
@property (strong, nonatomic) NSString        *comment;

@end
