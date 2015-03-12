//
//  WPReceiveEventViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ReceiveEventCell.h"


@class ReceiveEventCell;
@interface WPReceiveEventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ReceiveEventCellProtocol>

@property (strong, nonatomic) PFObject         *event;

- (void) didClickOnAcceptButton:(id)sender;
- (void) didClickOnDeclineButton:(id)sender;

@end
