//
//  AddEventCell.h
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ManagedParseUser.h"
#import "GooglePlaceDataProvider.h"
#import "MYGoogleAddress.h"

@class AddEventCell;
@protocol AddEventCellProtocol <NSObject>

- (void) didClickOnCellButton:(id)sender datas:(NSDictionary*)datas;

@end


@interface AddEventCell : UITableViewCell<UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic  ) UITableView                       *tableView;
@property (weak, nonatomic  ) id<AddEventCellProtocol>        delegate;
-(void) initAddEventCell;

@end
