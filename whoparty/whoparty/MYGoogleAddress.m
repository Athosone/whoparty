//
//  MYGoogleAddress.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "MYGoogleAddress.h"

@implementation MYGoogleAddress

@dynamic  longitude;
@dynamic  latitude;
@dynamic  name;
@dynamic address;


+ (NSString *)parseClassName
{
    return @"MYGoogleAddress";
}

@end
