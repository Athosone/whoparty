//
//  MenuViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MenuSubView.h"

@protocol MenuVCDelegate <NSObject>

- (void) didDismissMenuWithSubMenuType:(subTypeMenu)type;

@end

@interface MenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, FBFriendPickerDelegate>

@property (weak, nonatomic) id<MenuVCDelegate> delegate;

@end
