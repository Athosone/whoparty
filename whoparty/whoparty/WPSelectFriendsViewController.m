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

@interface WPSelectFriendsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray                       *friendsName;
@property (strong, nonatomic) PFUser                        *user;

@end

@implementation WPSelectFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsName = nil;
    self.user = [PFUser currentUser];
    self.friendsName = [self.user objectForKey:@"friendsId"];
    // [ManagedParseUser fetchFriendsListForUser:self.user target:self selector:@selector(setFriendsList:)];
    // Do any additional setup after loading the view.
}

- (void) setFriendsList:(NSArray*)friendsList
{
    self.friendsName = friendsList;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *message = cell.textLabel.text;
    [ManagedParseUser fetchFriendUserByUsername:message target:self selector:@selector(sendNotificationPush:)];
}

- (void) sendNotificationPush:(PFUser*) user
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"toto", @"name", nil];
    
    NSString *channel = [CHANNELUSERPREFIX stringByAppendingString:user.objectId];
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"channels" equalTo:channel]; // Set channel
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setMessage:@"Giants scored against the A's! It's now 2-2."];
    [push sendPushInBackground];
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
