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

@protocol ReceiveEventCellProtocol <NSObject>

- (void) didClickOnAcceptButton:(id)sender;
- (void) didClickOnDeclineButton:(id)sender;

@end

@interface ReceiveEventCell : UITableViewCell<CLLocationManagerDelegate>

@property (weak, nonatomic) id<ReceiveEventCellProtocol> delegate;

- (void) initReceiveEventCell:(MYGoogleAddress*)gA comment:(NSString*)comment;
- (void) setAcceptedStatus;
- (void) setDeclineStatus;
- (void) setSendingUserStyle;
- (void) showMap;
- (void) hideMap;

@end
