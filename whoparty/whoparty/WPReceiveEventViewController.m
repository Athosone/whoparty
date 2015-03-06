//
//  WPReceiveEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPReceiveEventViewController.h"
#import "ReceiveEventCell.h"

@interface WPReceiveEventViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
//TODO
//Accept decline send pushnotif to the other user in order to confirm or decline
//IF accept proposer de démarer la navigation avec yes please or no iknow the way if no laisser les options lors de l'affichage de l'event
//create vue with received notif like snapchat
//end friend view
//publish on test flight
@implementation WPReceiveEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveEventCell" bundle:nil] forCellReuseIdentifier:@"ReceiveEventCell"];
    // Do any additional setup after loading the view.
}


#pragma mark ->TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 1;
    
    return lRet;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveEventCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"ReceiveEventCell"];
    
    if (!cell)
    {
        [mtableView registerNib:[UINib nibWithNibName:@"ReceiveEventCell" bundle:nil] forCellReuseIdentifier:@"ReceiveEventCell"];
        cell = [mtableView dequeueReusableCellWithIdentifier:@"ReceiveEventCell"];
    }
    [cell initReceiveEventCell];
    return cell;
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
