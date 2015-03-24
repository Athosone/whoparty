//
//  WPListEventViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLExpandableTableView/SLExpandableTableView.h>
#import "ListEventCell.h"
#import "MoreListEventTableViewCell.h"
#import "MenuViewController.h"

@interface WPListEventViewController : UIViewController<SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, MenuVCDelegate, MoreListEventTableViewCellDelegate>

@end
