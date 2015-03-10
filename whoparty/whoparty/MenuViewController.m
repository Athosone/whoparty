//
//  MenuViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import "MenuViewController.h"
#import "WPHelperConstant.h"

@interface MenuViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;


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
    self.view.backgroundColor = [UIColor clearColor];
    [WPHelperConstant setBGColorForView:self.tableView color:DEFAULTBGCOLOR];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuSubView" bundle:nil] forCellReuseIdentifier:@"MenuSubView"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 1;
    
    return lRet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuSubView *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuSubView"];
    
    if (cell.type == kMenuLogout)
    {
        
        //[PFUser logOut];
        //[self popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuSubView *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuSubView"];
    
    cell.type = kMenuLogout;
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
