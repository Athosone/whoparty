//
//  GooglePlaceDataProvider.h
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MYGoogleAddress.h"

#define GOOGLEBASEURL @"https://maps.googleapis.com/maps/api/place/textsearch/json?"
#define GOOGLEBASELINK @"comgooglemaps://?daddr="
#define MAPSBASELINK @"http://maps.apple.com/?daddr="

@interface GooglePlaceDataProvider : NSObject


+ (void) fetchPlaceByName:(NSDictionary*)data success:(void (^)(NSMutableArray *result))connectionSuccess;
+ (void) getCityNameFromLocation:(CLLocation*)location success:(void (^)(NSString *cityName))success;
+ (void) fetchPlaceByName:(NSDictionary*)data success:(SEL)selector target:(id)target;
+ (void) setPointForView:(GMSMapView*)destView mygoogleAddress:(MYGoogleAddress*)destLoc;
+ (void) setCameraPositionForView:(GMSMapView*)destView mygoogleAddress:(MYGoogleAddress*)destLoc;
+ (void) getAutoComplete:(NSDictionary*)datas searchText:(NSString*)searchText completionBlock:(void(^)(NSArray*))completionBlock;

@end
