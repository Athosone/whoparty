//
//  MenuViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSubView.h"

@protocol MenuVCDelegate <NSObject>

- (void) didDismissMenuWithSubMenuType:(subTypeMenu)type;

@end

@interface MenuViewController : UIViewController<UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) id<MenuVCDelegate> delegate;

@end
