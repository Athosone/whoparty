//
//  ListEventCell.h
//  whoparty
//
//  Created by Werck Ayrton on 15/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SLExpandableTableView/SLExpandableTableView.h>

#define CONTAINERVIEWSIZEHEIGHT 215


@class ListEventCell;
@protocol ListEventCellDelegate <NSObject>

- (void) didClickOnDisplayEventButton:(ListEventCell*)cell;
- (void) didClickOnDeclinedButton:(ListEventCell*)cell;
- (void) didClickOnAcceptedButton:(ListEventCell*)cell;
- (void) didClickOnMapButton:(ListEventCell*)cell;
- (void) didClickOnAddToCalendarButton:(ListEventCell*)cell;
- (void) didClickOnCancelEvent:(ListEventCell*)cell;

@end

@interface ListEventCell : UITableViewCell<UIExpandingTableViewCell>

@property (strong, nonatomic) IBOutlet UIView *containerViewForCell;
@property (strong, nonatomic) IBOutlet UIButton *buttonSlideCell;
@property (weak, nonatomic)        UITableView *tableView;
@property (strong, nonatomic) PFObject *event;
@property (readwrite, nonatomic) BOOL           isSlided;
@property (weak, nonatomic) id<ListEventCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath       *indexPath;
@property (strong, nonatomic) IBOutlet UIView *coverView;


@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
- (void)setExpansionStyle:(UIExpansionStyle)style animated:(BOOL)animated;
- (void) initWithEvent:(PFObject*) event;

@end
