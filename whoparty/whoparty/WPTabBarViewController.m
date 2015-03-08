//
//  WPTabBarViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPTabBarViewController.h"
#import "WPAddEventViewController.h"
#import "WPHelperConstant.h"

#define FETCHEVENT 0
#define ADDEVENT 1

@interface WPTabBarViewController ()

@end

@implementation WPTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Init NavController
     //navCamera.navigationBar.barTintColor = [WOTHelperConstants getRedColorApp];
    //navWine.navigationBar.barTintColor = [WOTHelperConstants getRedColorApp];
    
    [self.tabBar configureFlatTabBarWithColor:DEFAULTNAVBARBGCOLOR];
    //Init variables each viewcontroller that compose the tab bar with data needed
   // WPAddEventViewController *addEventVC = (WPAddEventViewController*)[[navAddEvent viewControllers] objectAtIndex:0];
//    WOTSearchWineViewController *searchWine = (WOTSearchWineViewController*)[[navWine viewControllers] objectAtIndex:0];
 //   searchWine.client = self.client;

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
