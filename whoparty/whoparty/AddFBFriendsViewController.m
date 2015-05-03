//
//  AddFBFriendsViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 25/04/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "AddFBFriendsViewController.h"

@interface AddFBFriendsViewController ()

@end

@implementation AddFBFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    
}

- (void) facebookViewControllerCancelWasPressed:(id)sender
{
    
}

- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    
}

- (void) friendPickerViewController:(FBFriendPickerViewController *)friendPicker handleError:(NSError *)error
{
    NSLog(@"[ERROR]: %@", error);
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
