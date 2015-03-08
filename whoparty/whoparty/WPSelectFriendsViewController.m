//
//  WPSelectFriendsViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import "WPSelectFriendsViewController.h"
#import "ManagedParseUser.h"
#import "WPHelperConstant.h"
#import "Event.h"

@interface WPSelectFriendsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray                       *friendsName;
@property (strong, nonatomic) PFUser                        *user;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonAddFriend;

@end

@implementation WPSelectFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsName = nil;
    self.user = [PFUser currentUser];
    self.friendsName = [self.user objectForKey:@"friendsId"];
    self.barButtonAddFriend.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.friendsName = [self.user objectForKey:@"friensId"];
    [self.tableView reloadData];
}

- (void) setFriendsList:(NSArray*)friendsList
{
    self.friendsName = friendsList;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addFriends:(id)sender
{
    [self performSegueWithIdentifier:@"WPAddFriendsViewController" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 0;
    NSArray *users = (NSArray*)[self.user objectForKey:@"friendsId"];
    lRet = users.count;
    return lRet;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    NSArray *users = (NSArray*)[self.user objectForKey:@"friendsId"];

    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendCell"];
    if (users)
        cell.textLabel.text = [users objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *userDest = cell.textLabel.text;
    [ManagedParseUser fetchFriendUserByUsername:userDest target:self selector:@selector(sendNotificationPush:)];
}

- (void) sendNotificationPush:(PFUser*) user
{
    NSString *userDest = user.username;
    Event   *event = [[Event alloc] initWithClassName:@"Event"];
    if (self.currentAddress)
        [self.currentAddress saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            if (self.currentAddress)
                event.mygoogleaddress = self.currentAddress;
            event.comment = self.comment;
            event.receivinguser = userDest;
            event.sendinguser = [PFUser currentUser].username;
            event.isReceived = NO;
            event.isAccepted = NO;
            [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    [event pinInBackground];
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                NSString *alert = [NSString stringWithFormat:@"%@ just sent you an event !",[PFUser currentUser].username];
                
                [data setObject:alert forKey:@"alert"];
                [data setObject:@"createEvent" forKey:@"eventType"];
                [data setObject:@"default" forKey:@"sounds"];
                [data setObject:event.objectId forKey:@"eventId"];
                [ManagedParseUser sendNotificationPush:userDest
                                                  data:data];
                }
                else
                    NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
 
            }];
        }
        else
            NSLog(@"Error saving address in SelectFriends-sendNotificationPush, error: %@", error);
    }];
    else
    {
        event.comment = self.comment;
        event.receivinguser = userDest;
        event.sendinguser = [PFUser currentUser].username;
        event.isReceived = NO;
        event.isAccepted = NO;
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                [event pinInBackground];
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                NSString *alert = [NSString stringWithFormat:@"%@ just sent you an event !",[PFUser currentUser].username];
                
                [data setObject:alert forKey:@"alert"];
                [data setObject:@"createEvent" forKey:@"eventType"];
                [data setObject:@"default" forKey:@"sounds"];
                [data setObject:event.objectId forKey:@"eventId"];
                [ManagedParseUser sendNotificationPush:userDest
                                                  data:data];
            }
            else
                NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
        }];
    }
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
