//
//  WPSelectFriendsViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYGoogleAddress.h"
#import "SendView.h"

@class SendView;
@interface WPSelectFriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SendViewProtocol>

@property (strong, nonatomic) MYGoogleAddress   *currentAddress;
@property (strong, nonatomic) NSString          *comment;

@end
