//
//  WPAddFriendsViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPAddFriendsViewController.h"
#import "ManagedParseUser.h"

@interface WPAddFriendsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *buttonFriend;

@end

@implementation WPAddFriendsCell

- (void) initAddFriendsCell
{
    self.buttonFriend.imageView.image = [UIImage imageNamed:@"plusFriend"];
    self.activityIndicator.hidden = true;
}

- (IBAction)buttonFriendOnClick:(id)sender
{
    PFUser *user = [PFUser currentUser];
    NSMutableArray *friendsList = [NSMutableArray arrayWithArray:[user objectForKey:@"friendsId"]];
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = FALSE;
    self.buttonFriend.hidden = TRUE;
    
    [friendsList addObject:self.textLabel.text];
    [user setObject:friendsList forKey:@"friendsId"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            self.buttonFriend.imageView.image = [UIImage imageNamed:@"validFriend"];
        }
        self.activityIndicator.hidden = TRUE;
        [self.activityIndicator stopAnimating];
        self.buttonFriend.hidden = FALSE;
    }];
}

@end


@interface WPAddFriendsViewController ()


@property (strong, nonatomic) IBOutlet UISearchBar *searchFriends;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString             *cellText;

@end

@implementation WPAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ->SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.cellText = searchText;
    [self.tableView reloadData];
}

#pragma mark ->TableView Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 0;

    if (self.cellText.length > 0)
        lRet = 1;
    return lRet;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPAddFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friends"];
    
    if (!cell)
        cell = [[WPAddFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friends"];
    
    cell.textLabel.text = self.cellText;
    [cell initAddFriendsCell];
    return cell;
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
