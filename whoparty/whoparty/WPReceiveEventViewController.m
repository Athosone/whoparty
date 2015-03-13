//
//  WPReceiveEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "WPReceiveEventViewController.h"
#import "ManagedParseUser.h"
#import "WPHelperConstant.h"
#import "Animations.h"

@interface WPReceiveEventViewController ()

@property (readwrite, nonatomic) BOOL isReady;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD        *hud;

@end
//TODO
//Accept decline send pushnotif to the other user in order to confirm or decline
//IF accept proposer de démarer la navigation avec yes please or no iknow the way if no laisser les options lors de l'affichage de l'event
//create vue with received notif like snapchat
//end friend view
//publish on test flight
@implementation WPReceiveEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReady = NO;
    [WPHelperConstant setBGColorForView:self.tableView color:DEFAULTBGCOLOR];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveEventCell" bundle:nil] forCellReuseIdentifier:@"ReceiveEventCell"];
    if (self.event && self.event.objectId)
    {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        self.hud.labelText = @"Loading map";
        self.hud.backgroundColor = DEFAULTPROGRESSHUDCOLOR;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.event && self.event.objectId)
    {
        self.hud.hidden = false;
        if (self.event)
        [ManagedParseUser fetchGoogleAddress:self.event[@"mygoogleaddress"] target:self selector:@selector(updateMyGoogleAddress:)];
        NSArray *usersAccetped = self.event[@"usersAccepted"];
        NSArray *usersDeclined = self.event[@"usersDeclined"];
        NSArray *usersConcerned = self.event[@"usersConcerned"];
        if ((usersAccetped.count + usersDeclined.count - 2) != usersConcerned.count)
        {
            [ManagedParseUser fetchEvent:self.event completionBlock:^(PFObject *obj) {
                self.event = obj;
                [self.tableView reloadData];
            }];
        }
    }
}

- (void) updateMyGoogleAddress:(PFObject*)googleAddress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (googleAddress)
        {
            [self.event setObject:googleAddress forKey:@"mygoogleaddress"];
            [self.event pinInBackground];
            self.isReady = YES;
        }
        self.hud.hidden = true;
        [self.tableView reloadData];
    });
}

#pragma mark ->TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 1;
    
    return lRet;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveEventCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"ReceiveEventCell"];
    
    if (!cell)
    {
        [mtableView registerNib:[UINib nibWithNibName:@"ReceiveEventCell" bundle:nil] forCellReuseIdentifier:@"ReceiveEventCell"];
        cell = [mtableView dequeueReusableCellWithIdentifier:@"ReceiveEventCell"];
    }
    if (self.event && self.isReady)
    {
       // [cell initReceiveEventCell:[self.event objectForKey:@"mygoogleaddress"] comment:[self.event objectForKey:@"comment"]];
        [cell initReceiveEventCellWithEvent:self.event];
        if ([self.event[@"sendinguser"] isEqualToString:[PFUser currentUser].username] && self.event[@"groupName"])
        {
            [cell initReceiveEventCellWithEvent:self.event];
            [self setCellStyleForSendingUser:cell];
        }
        else if (self.event[@"usersConcerned"] && ![self.event[@"sendinguser"] isEqualToString:[PFUser currentUser].username])
        {
            cell.eventType = kEventGroup;
            NSArray *usersAccetped = self.event[@"usersAccepted"];
            NSArray *usersDeclined = self.event[@"usersDeclined"];
            
            if ([usersAccetped containsObject:[PFUser currentUser].username])
                [cell setAcceptedStatus];
            else if ([usersDeclined containsObject:[PFUser currentUser].username])
                [cell setDeclineStatus];
        }
        else
        {
            if (self.event[@"isReceived"] == [NSNumber numberWithBool:YES])
            {
                if (self.event[@"isAccepted"] == [NSNumber numberWithBool:YES])
                    [cell setAcceptedStatus];
                else
                    [cell setDeclineStatus];
            }
            else if ([self.event[@"sendinguser"] isEqualToString:[PFUser currentUser].username])
               [cell setSendingUserStyle];
       }
        [Animations addFadeInTransitionToView:cell duration:0.8f];
    }
    cell.delegate = self;
    return cell;
}

- (void) setCellStyleForSendingUser:(ReceiveEventCell*)cell
{
    NSArray *usersAccetped = self.event[@"usersAccepted"];
    NSArray *usersDeclined = self.event[@"usersDeclined"];
    NSArray *usersConcerned = self.event[@"usersConcerned"];
    
    if ((usersAccetped.count - 1) == usersConcerned.count)
    {
        [cell setAcceptedStatus];
    }
    else if ((usersDeclined.count - 1) == usersConcerned.count)
    {
        [cell setDeclineStatus];
    }
    else if ((usersAccetped.count + usersDeclined.count - 2) == usersConcerned.count)
    {
        [cell setMixedStatus];
    }
    else
    {
        [cell setSendingUserStyle];
    }
}

- (void) didClickOnAcceptButton:(id)sender
{
    if (self.event[@"groupName"])
    {
        [self.event[@"usersAccepted"] addObject:[PFUser currentUser].username];
        NSArray *usersDeclined = self.event[@"usersDeclined"];
        NSArray *usersAccepted = self.event[@"usersAccepted"];
        NSArray *usersConcerned = self.event[@"usersConcerned"];
        if ((usersDeclined.count + usersAccepted.count) == usersConcerned.count)
            self.event[@"isReceived"] = [NSNumber numberWithBool:YES];
    }
    else
    {
        self.event[@"isAccepted"] = [NSNumber numberWithBool:YES];
        self.event[@"isReceived"] = [NSNumber numberWithBool:YES];
    }
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             [self.event pin];
             NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
             NSString *alert = [NSString stringWithFormat:@"%@ just accepted your event !",[PFUser currentUser].username];
             
             [data setObject:alert forKey:@"alert"];
             [data setObject:@"eventIsAccepted" forKey:@"eventType"];
             [data setObject:@"default" forKey:@"sound"];
             [data setObject:self.event.objectId forKey:@"eventId"];
             [ManagedParseUser sendNotificationPush:self.event[@"sendinguser"] data:data completionBlock:^{
                 NSLog(@"Event Accepted");
             }];
             [self.tableView reloadData];
         }
         else
         {
             NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
             [self.event saveEventually];
         }
     }];
}

- (void) didClickOnDeclineButton:(id)sender
{
    if (self.event[@"groupName"])
    {
        [self.event addUniqueObject:[PFUser currentUser].username forKey:@"usersDeclined"];
        NSArray *usersDeclined = self.event[@"usersDeclined"];
        NSArray *usersAccepted = self.event[@"usersAccepted"];
        NSArray *usersConcerned = self.event[@"usersConcerned"];
        if ((usersDeclined.count + usersAccepted.count) == usersConcerned.count)
            self.event[@"isReceived"] = [NSNumber numberWithBool:YES];
    }
    else
    {
        self.event[@"isAccepted"] = [NSNumber numberWithBool:NO];
        self.event[@"isReceived"] = [NSNumber numberWithBool:YES];
    }
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             [self.event pin];
             NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
             NSString *alert = [NSString stringWithFormat:@"%@ just declined your event !",[PFUser currentUser].username];
             
             [data setObject:alert forKey:@"alert"];
             [data setObject:@"eventIsAccepted" forKey:@"eventType"];
             [data setObject:@"default" forKey:@"sound"];
             [data setObject:self.event.objectId forKey:@"eventId"];
             [ManagedParseUser sendNotificationPush:self.event[@"sendinguser"] data:data completionBlock:^{
                 NSLog(@"Event declined");
             }];
             [self.tableView reloadData];
         }
         else
         {
             NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
             [self.event saveEventually];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
