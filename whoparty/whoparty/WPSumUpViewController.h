//
//  WPSumUpViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 17/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYGoogleAddress.h"

@interface WPSumUpViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MYGoogleAddress *selectedPlace;
@property (strong, nonatomic) NSDate          *selectedDate;

@end
