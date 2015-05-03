//
//  MenuViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "MenuViewController.h"
#import "WPHelperConstant.h"
#import "ManagedParseUser.h"

@interface MenuViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (readwrite, nonatomic) subTypeMenu typeSelected;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameUser;
@property (strong, nonatomic) UIViewController *currentVC;


@end

@implementation MenuViewController

- (id) init
{
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentVC = nil;
    // self.view.backgroundColor = [UIColor clearColor];
    //[WPHelperConstant setBGColorForView:self.tableView color:DEFAULTBGCOLOR];
    // [self.tableView registerNib:[UINib nibWithNibName:@"MenuSubView" bundle:nil] forCellReuseIdentifier:@"MenuSubView"];
    
    PFUser *user = [PFUser currentUser];
    
    self.labelNameUser.text = user.username;
    self.imageProfile.image = [UIImage imageNamed:@"noav"];
    self.imageProfile.layer.masksToBounds = YES;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    if ([user objectForKey:@"profilePictureFile"])
    {
        PFFile *image = [user objectForKey:@"profilePictureFile"];
        
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            self.imageProfile.image = [UIImage imageWithData:data];
        }];
    }
    else
    {
        [ManagedParseUser userWithUserName:user.username completionBlock:^(PFObject *object) {
            if (object && [object objectForKey:@"profilePictureFile"])
            {
                PFFile *image = [object objectForKey:@"profilePictureFile"];
                
                [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    self.imageProfile.image = [UIImage imageWithData:data];
                }];
            }
        }];
    }
    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (IBAction)dismissBarButtonOnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PFUser logOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        });
    }
    else if (indexPath.row == 2)
    {
        
        
        /*FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
        friendPickerController.title = @"Pick Friends";
        friendPickerController.delegate = self;
        [friendPickerController loadData];
        self.currentVC = friendPickerController;
        [self.navigationController presentViewController:friendPickerController animated:YES completion:nil];*/
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 5;
    
    return lRet;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString  *reuseIdentifier = nil;
    
    switch (row) {
        case 0:
            reuseIdentifier = @"AccountInformation";
            break;
        case 1:
            reuseIdentifier = @"FriendsList";
            break;
        case 2:
            reuseIdentifier = @"AddFriends";
            break;
        case 3:
            reuseIdentifier = @"AboutUs";
            break;
        case 4:
            reuseIdentifier = @"Logout";
            break;
        default:
            break;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

#pragma mark -> FBFriendPickerDelegate

- (void) facebookViewControllerCancelWasPressed:(id)sender
{
    [self.currentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) facebookViewControllerDoneWasPressed:(id)sender
{
    
}

- (void) friendPickerViewController:(FBFriendPickerViewController *)friendPicker handleError:(NSError *)error
{
    
}

- (void) friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    
}

- (void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    
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
