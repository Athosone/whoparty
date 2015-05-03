//
//  MoreListEventTableViewCell.h
//  whoparty
//
//  Created by Werck Ayrton on 24/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MoreListEventTableViewCell;
@protocol MoreListEventTableViewCellDelegate <NSObject>

- (void) didClickOnDisplayEventButton:(MoreListEventTableViewCell*)cell;
- (void) didClickOnDeclinedButton:(MoreListEventTableViewCell*)cell;
- (void) didClickOnAcceptedButton:(MoreListEventTableViewCell*)cell;
- (void) didClickOnMapButton:(MoreListEventTableViewCell*)cell;
- (void) didClickOnAddToCalendarButton:(MoreListEventTableViewCell*)cell;
- (void) didClickOnCancelEvent:(MoreListEventTableViewCell*)cell;
- (void) didClickOnUsersConcernedButton:(MoreListEventTableViewCell*)cell;

@end


@interface MoreListEventTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MoreListEventTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath       *indexpath;

- (void) initWithEvent:(PFObject*) event;


@end
