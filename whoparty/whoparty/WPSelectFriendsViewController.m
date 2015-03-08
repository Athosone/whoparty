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
#import "SendView.h"
#import "CheckBoxTableViewCell.h"


@interface WPSelectFriendsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray                       *friendsName;
@property (strong, nonatomic) PFUser                        *user;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonAddFriend;
@property (strong, nonatomic) SendView                      *sendView;
@end

@implementation WPSelectFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsName = nil;
    self.user = [PFUser currentUser];
    self.friendsName = [self.user objectForKey:@"friendsId"];
    self.barButtonAddFriend.tintColor = [UIColor whiteColor];
   self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckBoxCell" bundle:nil] forCellReuseIdentifier:@"checkBoxCell"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.friendsName = [self.user objectForKey:@"friensId"];
    [self.tableView reloadData];
    [self addSendView];
}

- (void) addSendView
{
    self.sendView = [[SendView alloc] init];
    self.sendView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50.0f);
    [self.sendView initView];
    self.tableView.tableFooterView = self.sendView;
    self.sendView.hidden = true;
    self.sendView.delegate = self;
    [self.view layoutIfNeeded];
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

#pragma mark ->TableView delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 0;
    NSArray *users = (NSArray*)[self.user objectForKey:@"friendsId"];
    lRet = users.count;
    return lRet;
}

- (UITableViewCell*) tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckBoxTableViewCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"checkBoxCell"];
    NSArray *users = (NSArray*)[self.user objectForKey:@"friendsId"];

    if (!cell)
    {
        [mtableView registerNib:[UINib nibWithNibName:@"CheckBoxCell" bundle:nil] forCellReuseIdentifier:@"checkBoxCell"];
        cell = [mtableView dequeueReusableCellWithIdentifier:@"checkBoxCell"];
    }
    if (users)
        cell.textLabel.text = [users objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView indexPathsForSelectedRows].count == 1)
        [self.sendView fadeIn];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView indexPathsForSelectedRows].count == 0)
        [self.sendView fadeOut];
}

#pragma mark ->Send NotifPush

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
                [data setObject:@"default" forKey:@"sound"];
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
                [data setObject:@"default" forKey:@"sound"];
                [data setObject:event.objectId forKey:@"eventId"];
                [ManagedParseUser sendNotificationPush:userDest
                                                  data:data];
            }
            else
                NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
        }];
    }
}

#pragma mark ->SendView Delegate

- (void) didClickOnSendViewButton:(id)sender
{
    NSArray *indexesPath = [self.tableView indexPathsForSelectedRows];

    [self.sendView startAi];
    for (NSIndexPath *i in indexesPath)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:i];
        NSString *userDest = cell.textLabel.text;
        [ManagedParseUser fetchFriendUserByUsername:userDest target:self selector:@selector(sendNotificationPush:)];
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
