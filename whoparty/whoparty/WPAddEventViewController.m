//
//  WPAddEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPSelectFriendsViewController.h"
#import "WPAddEventViewController.h"
#import "WPHelperConstant.h"
#import "AlertView.h"

#pragma mark ->ViewController

@interface WPAddEventViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary           *comment_mapDatas;


@end

@implementation WPAddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:DEFAULTNAVBARBGCOLOR];
    [self.tableView registerNib:[UINib nibWithNibName:@"MapForm" bundle:nil] forCellReuseIdentifier:@"AddEventCell"];
    
    [WPHelperConstant setBGColorForView:self.tableView color:nil];
    // Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![PFUser currentUser])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ->TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 1;
    
    return lRet;
}


- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEventCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"AddEventCell"];
    
    if (!cell)
    {
        [mtableView registerNib:[UINib nibWithNibName:@"MapForm" bundle:nil] forCellReuseIdentifier:@"AddEventCell"];
        cell = [mtableView dequeueReusableCellWithIdentifier:@"AddEventCell"];  
    }
    [cell initAddEventCell];
    cell.tableView = self.tableView;
    cell.delegate = self;
    return cell;
}

#pragma mark ->WPAddEventProtocol

- (void) didClickOnCellButton:(id)sender datas:(NSDictionary *)datas
{
    if ([datas objectForKey:@"error"])
    {
        FUIAlertView *alertView = [AlertView getDefaultAlertVIew:@"Oops !" message:[datas objectForKey:@"error"]];
        
        [alertView show];
    }
    else
    {
        self.comment_mapDatas = datas;
        
        WPSelectFriendsViewController *s = nil;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        s = [story instantiateViewControllerWithIdentifier:@"selectFriend"];
        s.currentAddress = [self.comment_mapDatas objectForKey:@"currentAddress"];
        s.comment = [self.comment_mapDatas objectForKey:@"comment"];

        [self.navigationController showViewController:s sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectFriends"])
    {
        UINavigationController *navC = [segue destinationViewController];
        WPSelectFriendsViewController   *destVC = [[navC viewControllers] objectAtIndex:0];
        
        destVC.currentAddress = [self.comment_mapDatas objectForKey:@"currentAddress"];
        destVC.comment = [self.comment_mapDatas objectForKey:@"comment"];
    }
    else if ([[segue identifier] isEqualToString:@"selectFriendsModally"])
    {
        WPSelectFriendsViewController   *destVC = [segue destinationViewController];
        
        destVC.currentAddress = [self.comment_mapDatas objectForKey:@"currentAddress"];
        destVC.comment = [self.comment_mapDatas objectForKey:@"comment"];

    }
}


@end
