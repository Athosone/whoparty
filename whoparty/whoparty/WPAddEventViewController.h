//
//  WPAddEventViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPAddEventCell;
@protocol WPAddEventCellProtocol <NSObject>

- (void) didClickOnCellButton:(id)sender datas:(NSDictionary*)datas;

@end

@interface WPAddEventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WPAddEventCellProtocol>

@end
