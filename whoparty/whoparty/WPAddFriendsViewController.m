//
//  WPAddFriendsViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPAddFriendsViewController.h"
#import "ManagedParseUser.h"
#import "WPHelperConstant.h"

#define ADDFRIENDCELL 0

//PUT A DELEGATE FOR THE MAIN VIEWCONTROLLER and ADD FRIEND IN THE CALLING VIEWCONTROLLER

@interface WPAddFriendsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *buttonFriend;
@property (weak, nonatomic) UITableView *delegate;

@property (readwrite, nonatomic) BOOL           isFriend;
- (void) startAI;
- (void) stopAI;

@end

@implementation WPAddFriendsCell

- (void) initAddFriendsCell:(BOOL)isExist isFriend:(BOOL)isFriend
{
    self.isFriend = isFriend;
    if (!isExist)
        self.buttonFriend.hidden = true;
    else
    {
        self.buttonFriend.imageView.image = nil;
        
        if (!isFriend)
           [self setimageForButton:[UIImage imageNamed:@"plusEvent"]];
        else
           [self setimageForButton:[UIImage imageNamed:@"validEvent"]];
        self.buttonFriend.hidden = false;
    }
}

- (void) setimageForButton:(UIImage*) imageToDisplay
{
    UIImage *image = imageToDisplay;
    [self.buttonFriend setImage:image forState:UIControlStateNormal];
    //[self.buttonFriend setImage:image forState:UIControlStateNormal];
}

- (void) startAI
{
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
}

- (void) stopAI
{
    self.activityIndicator.hidden = true;
    [self.activityIndicator stopAnimating];
}

- (IBAction)buttonFriendOnClick:(id)sender
{
    PFUser *user = [PFUser currentUser];
    NSMutableArray *friendsList = [NSMutableArray arrayWithArray:[user objectForKey:@"friendsId"]];
    
    [self startAI];
    self.buttonFriend.hidden = TRUE;
    if (self.isFriend)
        [friendsList removeObject:self.textLabel.text];
    else
        [friendsList addObject:self.textLabel.text];
    [user setObject:friendsList forKey:@"friendsId"];
    [user pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded)
            {
                if (self.isFriend)
                    [self setimageForButton:[UIImage imageNamed:@"plusEvent"]];
                else
                    [self setimageForButton:[UIImage imageNamed:@"validEvent"]];
                self.buttonFriend.hidden = FALSE;
                [user saveEventually];
            }
        });
    }];
    [self stopAI];
   /* if (self.isFriend)
        self.buttonFriend.imageView.image = [UIImage imageNamed:@"plusEvent"];
    else
        self.buttonFriend.imageView.image = [UIImage imageNamed:@"validFriend"];
    self.buttonFriend.hidden = FALSE;
   */// [self.delegate reloadData];
}

@end


@interface WPAddFriendsViewController ()


@property (strong, nonatomic) IBOutlet UISearchBar *searchFriends;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString             *cellText;
@property (readwrite, nonatomic) BOOL                 isExist;
@property (readwrite, nonatomic) BOOL                 isFriend;
@property (readwrite, nonatomic) BOOL                 isSeeking;

- (void) isUserExist:(PFUser*)userFound;

@end

@implementation WPAddFriendsViewController

- (id) init
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     WPAddFriendsViewController* vc = (WPAddFriendsViewController *)[sb instantiateViewControllerWithIdentifier:@"WPAddFriendsViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationController.navigationBar.backItem
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.isSeeking = FALSE;
    self.isFriend = NO;
    self.isExist = NO;
    [WPHelperConstant setBGWithImageForView:self.view image:@"lacBG"];
    self.tableView.backgroundColor = [UIColor clearColor];
    [WPHelperConstant setBlurForView:self.tableView.backgroundView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ->SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.cellText = searchText;
    self.isSeeking = TRUE;
    [self.tableView reloadData];
    [ManagedParseUser fetchFriendUserByUsername:searchText target:self selector:@selector(isUserExist:)];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchFriends resignFirstResponder];
    [ManagedParseUser fetchFriendUserByUsername:searchBar.text target:self selector:@selector(isUserExist:)];

}

- (void) isUserExist:(PFUser*)userFound
{
    self.isSeeking = false;
    if (userFound)
    {
        self.isExist = YES;
        NSMutableArray *friendsId = [[PFUser currentUser] objectForKey:@"friendsId"];

        if ([friendsId containsObject:userFound.username])
            self.isFriend = YES;
        else
           self.isFriend = NO;
    }
    else
        self.isExist = NO;
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
    cell.delegate = self.tableView;
    cell.textLabel.text = self.cellText;
    cell.textLabel.textColor = [UIColor whiteColor];
    if (self.isSeeking)
        [cell startAI];
    else
    {
        [cell stopAI];
        [cell initAddFriendsCell:self.isExist isFriend:self.isFriend];
    }
    cell.backgroundColor = [UIColor clearColor];
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
