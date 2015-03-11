//
//  ReceiveEventCell.h
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <GoogleMaps/GoogleMaps.h>


typedef enum : NSUInteger {
    kEventGroup,
    kEventSolo,
} EventType;

@protocol ReceiveEventCellProtocol <NSObject>

- (void) didClickOnAcceptButton:(id)sender;
- (void) didClickOnDeclineButton:(id)sender;

@end

@interface ReceiveEventCell : UITableViewCell<CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) id<ReceiveEventCellProtocol> delegate;
@property (readwrite, nonatomic) EventType  *eventType;

- (void) initReceiveEventCellWithEvent:(Event*)event;
- (void) initReceiveEventCell:(MYGoogleAddress*)gA comment:(NSString*)comment;
- (void) setAcceptedStatus;
- (void) setDeclineStatus;
- (void) setSendingUserStyle;
- (void) showMap;
- (void) hideMap;
- (void) setMixedStatus;


@end
