//
//  ReceiveEventCell.h
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYGoogleAddress.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ReceiveEventCell : UITableViewCell<CLLocationManagerDelegate>

- (void) initReceiveEventCell:(MYGoogleAddress*)gA comment:(NSString*)comment;

@end
