//
//  WPShowParticipantTableViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 03/04/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WPShowParticipantTableViewController : UITableViewController

@property (strong, nonatomic) PFObject *event;
@property (strong, nonatomic) NSArray   *usersConcerned;
@property (strong, nonatomic) NSArray   *usersDeclined;
@property (strong, nonatomic) NSArray   *usersAccepted;


@end
