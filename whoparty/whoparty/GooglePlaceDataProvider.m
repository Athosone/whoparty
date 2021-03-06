//
//  GooglePlaceDataProvider.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocomplete.h>
#import "GooglePlaceDataProvider.h"
#import "WPHelperConstant.h"

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

+ (void) getAutoComplete:(NSDictionary*)datas searchText:(NSString*)searchText completionBlock:(void(^)(NSArray*))completionBlock
{
    float latitude = [[datas objectForKey:@"latitude"] floatValue];
    float longitude = [[datas objectForKey:@"longitude"] floatValue];
    
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:GOOGLESERVERAPIKEY];
    query.input = searchText; // search key word
    query.location = CLLocationCoordinate2DMake(latitude, longitude);  // user's current location
    query.radius = 500;   // search addresses close to user
    query.language = @"en"; // optional
    //query.types = SPPlaceTypeGeocode;
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        NSMutableArray *foundedPlaces = [[NSMutableArray alloc] init];
        for (SPGooglePlacesAutocompletePlace *p in places)
        {
            [foundedPlaces addObject:p.name];
        }
        completionBlock(foundedPlaces);
    }];
}

+ (void) fetchPlaceByName:(NSDictionary*)data success:(SEL)selector target:(id)target
{
    NSString    *name = [(NSString*)[data objectForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
   //NSString *queryPar = [NSString stringWithFormat:@"%@+%@", name, (NSString*)[data objectForKey:@"city"]];
    NSString *queryPar = [NSString stringWithFormat:@"%@", name];
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
    if (destLoc[@"address"])
        destPoint.snippet = destLoc[@"address"];   
}

@end
