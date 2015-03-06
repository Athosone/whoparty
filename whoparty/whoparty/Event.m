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
@dynamic receivinguser;
@dynamic comment;

+ (NSString*)parseClassName
{
    return @"Event";
}


@end
