//
//  GooglePlaceDataProvider.h
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GooglePlaceDataProvider : NSObject


+ (void) fetchPlaceByName:(NSDictionary*)data success:(void (^)(NSMutableArray *result))connectionSuccess;
+ (void) getCityNameFromLocation:(CLLocation*)location success:(void (^)(NSString *cityName))success;
+ (void) fetchPlaceByName:(NSDictionary*)data success:(SEL)selector target:(id)target;

@end
