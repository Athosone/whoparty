//
//  SelectPlace.h
//  whoparty
//
//  Created by Werck Ayrton on 16/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ManagedParseUser.h"
#import "GooglePlaceDataProvider.h"
#import "MYGoogleAddress.h"

@interface SelectPlace : UIView<UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic  ) UITableView                       *tableView;
-(void) initAddEventCell;

@end
