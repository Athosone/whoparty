//
//  WPReceiveEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPReceiveEventViewController.h"
#import "ManagedParseUser.h"
#import "WPHelperConstant.h"

@interface WPReceiveEventViewController ()

@property (readwrite, nonatomic) BOOL isReady;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

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
        [ManagedParseUser fetchGoogleAddress:self.event[@"mygoogleaddress"] target:self selector:@selector(updateMyGoogleAddress:)];
    }
    // Do any additional setup after loading the view.
}

- (void) updateMyGoogleAddress:(PFObject*)googleAddress
{
    if (googleAddress)
    {
        [self.event setObject:googleAddress forKey:@"mygoogleaddress"];
        self.isReady = YES;
        [self.tableView reloadData];
    }
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
       [cell initReceiveEventCell:[self.event objectForKey:@"mygoogleaddress"] comment:[self.event objectForKey:@"comment"]];
    if (self.event[@"isReceived"] == [NSNumber numberWithBool:YES])
    {
        if (self.event[@"isAccepted"] == [NSNumber numberWithBool:YES])
            [cell setAcceptedStatus];
        else
            [cell setDeclineStatus];
    }
    else if ([self.event[@"sendinguser"] isEqualToString:[PFUser currentUser].username])
        [cell setSendingUserStyle];
    cell.delegate = self;
    return cell;
}


- (void) didClickOnAcceptButton:(id)sender
{
    self.event[@"isAccepted"] = [NSNumber numberWithBool:YES];
    self.event[@"isReceived"] = [NSNumber numberWithBool:YES];

       [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
                if (succeeded)
                {
                    [self.event pinInBackground];
                    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                    NSString *alert = [NSString stringWithFormat:@"%@ just accepted your event !",[PFUser currentUser].username];
                    
                    [data setObject:alert forKey:@"alert"];
                    [data setObject:@"eventIsAccepted" forKey:@"eventType"];
                    [data setObject:@"default" forKey:@"sounds"];
                    [data setObject:self.event.objectId forKey:@"eventId"];
                    //[ManagedParseUser sendNotificationPush:self.event[@"sendinguser"] data:data];
                    [ManagedParseUser sendNotificationPush:self.event[@"sendinguser"] data:data];
                    [self.tableView reloadData];

                }
                else
                    NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
    }];
}

- (void) didClickOnDeclineButton:(id)sender
{
    self.event[@"isAccepted"] = [NSNumber numberWithBool:NO];
    self.event[@"isReceived"] = [NSNumber numberWithBool:YES];
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             [self.event pinInBackground];
             NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
             NSString *alert = [NSString stringWithFormat:@"%@ just accepted your event !",[PFUser currentUser].username];
             
             [data setObject:alert forKey:@"alert"];
             [data setObject:@"eventIsAccepted" forKey:@"eventType"];
             [data setObject:@"default" forKey:@"sounds"];
             [data setObject:self.event.objectId forKey:@"eventId"];
             //[ManagedParseUser sendNotificationPush:self.event[@"sendinguser"] data:data];
             [ManagedParseUser sendNotificationPush:self.event[@"sendinguser"] data:data];
             [self.tableView reloadData];
         }
         else
             NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
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
