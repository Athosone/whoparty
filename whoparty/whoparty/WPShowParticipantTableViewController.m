//
//  WPShowParticipantTableViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 03/04/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "WPShowParticipantTableViewController.h"
#import "ManagedParseUser.h"
#import "WPHelperConstant.h"

@interface WPShowParticipantTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *dismissBarButton;

@end

@implementation WPShowParticipantTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.tableView.backgroundColor = [UIColor clearColor];
   // UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    //[self.view addSubview:navBar];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //[blurEffectView setFrame:self.navigationController.navigationBar.frame];
    
    [WPHelperConstant setBlurForView:self.tableView.backgroundView];
    self.tableView.backgroundColor = [UIColor clearColor];
   // [WPHelperConstant setBlurForView:self.navigationController.navigationBar];
}

- (IBAction)dismissVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger lRet = 0;
    
    lRet = self.usersConcerned.count;
    // Return the number of rows in the section.
    return lRet;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    // Configure the cell...
    cell.textLabel.text = [self.usersConcerned objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"noav"];
    [WPHelperConstant setBlurForCell:cell];
    [ManagedParseUser userWithUserName:[self.usersConcerned objectAtIndex:indexPath.row] completionBlock:^(PFObject *user)
     {
         if (user && [user objectForKey:@"profilePictureFile"])
         {
             PFFile *picture = user[@"profilePictureFile"];
             [picture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                 if (data)
                     cell.imageView.image = [UIImage imageWithData:data];
                 else
                     NSLog(@"No data for profilePictureFile");
             }];
         }
         else
         {
         }
     }];
    if ([self.usersAccepted containsObject:[self.usersConcerned objectAtIndex:indexPath.row]])
    {
        cell.imageView.layer.borderColor = [UIColor greenColor].CGColor;
        cell.detailTextLabel.text = @"Accepted";
        cell.detailTextLabel.textColor = [UIColor greenColor];
        
    }
    else if ([self.usersDeclined containsObject:[self.usersConcerned objectAtIndex:indexPath.row]])
    {
        cell.imageView.layer.borderColor = [UIColor redColor].CGColor;
        cell.detailTextLabel.text = @"Declined";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;
        cell.detailTextLabel.text = @"Pending";
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    cell.imageView.frame = CGRectMake(0, 0, 20, 20);

   cell.imageView.layer.borderWidth = 3.0f;
   cell.imageView.layer.cornerRadius = 10;
   cell.imageView.clipsToBounds = YES;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
