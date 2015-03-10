//
//  Event.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "Event.h"

@implementation Event

@dynamic mygoogleaddress;
@dynamic sendinguser;
@dynamic comment;
@dynamic isAccepted;
@dynamic isReceived;
@dynamic receivinguser;
@dynamic usersConcerned;
@dynamic groupName;

+ (NSString*)parseClassName
{
    return @"Event";
}


@end
