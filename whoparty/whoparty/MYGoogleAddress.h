//
//  MYGoogleAddress.h
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MYGoogleAddress : PFObject<PFSubclassing>

+ (NSString*)parseClassName;


@property (readwrite, nonatomic) double        longitude;
@property (readwrite, nonatomic) double        latitude;
@property (strong, nonatomic) NSString      *address;
@property (strong, nonatomic) NSString      *name;


@end
