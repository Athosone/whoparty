//
//  GooglePlaceDataProvider.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "GooglePlaceDataProvider.h"
#import "WPHelperConstant.h"

#define GOOGLEBASEURL @"https://maps.googleapis.com/maps/api/place/textsearch/json?"
#define RADIUS        50000

@implementation GooglePlaceDataProvider

+ (void) fetchPlaceByName:(NSDictionary*)data success:(void (^)(NSMutableArray *result))connectionSuccess
{
    NSString    *name = [(NSString*)[data objectForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *queryPar = [NSString stringWithFormat:@"%@+%@", name, (NSString*)[data objectForKey:@"city"]];
    
    NSString *dataString = [NSString stringWithFormat:@"query=%@&location=%f,%f&radius=%@&key=%@",
                            queryPar,
                            [[data objectForKey:@"latitude"] doubleValue],
                            [[data objectForKey:@"longitude"] doubleValue],
                            [NSString stringWithFormat:@"%i", RADIUS],
                            GOOGLESERVERAPIKEY];
    NSString *requestString = [GOOGLEBASEURL stringByAppendingString:dataString];
    NSLog(@"request string: %@", requestString);
    
    NSURL *requestUrl = [NSURL URLWithString:requestString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error;
        NSData* dataResp = [NSData dataWithContentsOfURL:requestUrl];
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:dataResp  options:kNilOptions error:&error];
        NSDictionary *places = [responseData objectForKey:@"results"];
        NSMutableArray *addresses = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in places)
        {
            MYGoogleAddress *address = [[MYGoogleAddress alloc] init];
            NSDictionary *geometry = [dict objectForKey:@"geometry"];
            NSDictionary *coordinate = [geometry objectForKey:@"location"];
            address.address = [dict objectForKey:@"formatted_address"];
            address.latitude = [[coordinate objectForKey:@"lat"] doubleValue];
            address.longitude = [[coordinate objectForKey:@"lng"] doubleValue];
            address.name = [dict objectForKey:@"name"];
            [addresses addObject:address];
        }
        NSLog(@"DICT: %@", addresses);
        connectionSuccess(addresses);
    });
}

+ (void) fetchPlaceByName:(NSDictionary*)data success:(SEL)selector target:(id)target
{
    NSString    *name = [(NSString*)[data objectForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *queryPar = [NSString stringWithFormat:@"%@+%@", name, (NSString*)[data objectForKey:@"city"]];
    
    NSString *dataString = [NSString stringWithFormat:@"query=%@&location=%f,%f&radius=%@&key=%@",
                            queryPar,
                            [[data objectForKey:@"latitude"] doubleValue],
                            [[data objectForKey:@"longitude"] doubleValue],
                            [NSString stringWithFormat:@"%i", RADIUS],
                            GOOGLESERVERAPIKEY];
    NSString *requestString = [GOOGLEBASEURL stringByAppendingString:dataString];
    NSLog(@"request string: %@", requestString);
    
    NSURL *requestUrl = [NSURL URLWithString:requestString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error;
        NSData* dataResp = [NSData dataWithContentsOfURL:requestUrl];
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:dataResp  options:kNilOptions error:&error];
        NSDictionary *places = [responseData objectForKey:@"results"];
        NSMutableArray *addresses = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in places)
        {
            MYGoogleAddress *address = [[MYGoogleAddress alloc] init];
            NSDictionary *geometry = [dict objectForKey:@"geometry"];
            NSDictionary *coordinate = [geometry objectForKey:@"location"];
            address.address = [dict objectForKey:@"formatted_address"];
            address.latitude = [[coordinate objectForKey:@"lat"] doubleValue];
            address.longitude = [[coordinate objectForKey:@"lng"] doubleValue];
            address.name = [dict objectForKey:@"name"];
            [addresses addObject:address];
        }
        NSLog(@"DICT: %@", addresses);
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:addresses waitUntilDone:YES];
    });
}

+ (void) getCityNameFromLocation:(CLLocation*)location success:(void (^)(NSString *cityName))success
{
    GMSGeocoder *geoCoder = [[GMSGeocoder alloc] init];
    [geoCoder reverseGeocodeCoordinate:location.coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error)
    {
        if (!error && [response firstResult])
        {
            GMSAddress *address = [response firstResult];
            success(address.locality);
        }
    }];
}

+ (void) setCameraPositionForView:(GMSMapView*)destView mygoogleAddress:(MYGoogleAddress*)destLoc
{
    CLLocationCoordinate2D dest2D = CLLocationCoordinate2DMake([destLoc[@"latitude"] doubleValue], [destLoc[@"longitude"] doubleValue]);
    destView.camera = [GMSCameraPosition cameraWithTarget:dest2D zoom:15.0f];
}

+ (void) setPointForView:(GMSMapView*)destView mygoogleAddress:(MYGoogleAddress*)destLoc
{
    CLLocationCoordinate2D dest2D = CLLocationCoordinate2DMake([destLoc[@"latitude"] doubleValue], [destLoc[@"longitude"] doubleValue]);

    
    GMSMarker *destPoint = [GMSMarker markerWithPosition:dest2D];
    destPoint.map = destView;
    if (destLoc[@"name"])
        destPoint.title = destLoc[@"name"];
    else
        destPoint.title = destLoc[@"address"];
   
}

@end
