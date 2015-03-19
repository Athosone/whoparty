//
//  ListEventCell.h
//  whoparty
//
//  Created by Werck Ayrton on 15/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#define CONTAINERVIEWSIZEHEIGHT 260


@class ListEventCell;
@protocol ListEventCellDelegate <NSObject>

- (void) didClickOnDisplayEventButton:(ListEventCell*)cell;

@end

@interface ListEventCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerViewForCell;
@property (strong, nonatomic) IBOutlet UIButton *buttonSlideCell;
@property (weak, nonatomic)        UITableView *tableView;
@property (strong, nonatomic) PFObject *event;
@property (readwrite, nonatomic) BOOL           isSlided;
@property (weak, nonatomic) id<ListEventCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath       *indexPath;

- (void) initWithEvent:(PFObject*) event;

@end
