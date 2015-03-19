//
//  WPListEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPListEventViewController.h"
#import "WPHelperConstant.h"
#import "ManagedParseUser.h"
#import "Event.h"
#import "WPReceiveEventViewController.h"
#import "Animations.h"

@interface WPListEventViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray    *eventListReceived;
@property (strong, nonatomic) NSArray    *eventListSent;
@property (strong, nonatomic) Event      *currentEvent;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barbuttonitemMenu;
@property (strong,nonatomic) NSIndexPath    *currentIndexpath;

- (void) receivedPushNotfication:(NSDictionary*) userInfo;
- (void) updateEventList:(NSArray*)events;

@end

//TODO pour accepter ou decliner mettre en mode button avec le blanc a gauche
//TODO cacher le button ajouter des amis si receveur ou bien proposer option a l'envoyeur d'autoriser ou pas les receveurs à inviter des gens
@implementation WPListEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPushNotfication:) name:HASRECEIVEDPUSHNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedisAcceptedPushNotfication:) name:HASRECEIVEDISACCEPTEDNOTFICATION object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ListEventCell" bundle:nil] forCellReuseIdentifier:@"ListEventCell"];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [WPHelperConstant setImageAsBGForTableView:self.tableView image:[UIImage imageNamed:@"lacBG"]];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.navigationController.navigationBar.frame];
    [self.view addSubview:blurEffectView];
    [ManagedParseUser fetchAllEvents:self selector:@selector(updateEventList:)];
}

#pragma mark ->Segmented Control value changed

- (IBAction)segmentedControlValueChange:(id)sender
{
    [Animations addFadeOutFadeInTransitionToView:self.tableView duration:1.0f];
    [self.tableView reloadData];
}


#pragma mark ->Set Event list-Received push Notifcation

- (void) receivedPushNotfication:(NSNotification*)notification
{
    NSLog(@"Login-ViewController-userinfo receive push notification: %@", [notification userInfo]);
    [ManagedParseUser fetchAllEvents:self selector:@selector(updateEventList:)];
}

- (void) receivedisAcceptedPushNotfication:(NSNotification*)notification
{
    NSLog(@"Login-ViewController-userinfo receive push notification isAccepted: %@", [notification userInfo]);
    
    [ManagedParseUser fetchAllEvents:self selector:@selector(updateEventList:)];
}

- (void) updateEventList:(NSArray*)events
{
    if (events.count == 0)
        return;
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray  *receiveEvent = [[NSMutableArray alloc] init];
    NSMutableArray  *sentEvent = [[NSMutableArray alloc] init];
    
    for (Event *e in events)
    {
        if ([e isDataAvailable])
        {
            NSString *username = e[@"sendinguser"];
            if (username)
            {
                if ([username isEqualToString:currentUser.username])
                    [sentEvent addObject:e];
                else
                    [receiveEvent addObject:e];
            }
        }
    }
    self.eventListSent = [NSArray arrayWithArray:sentEvent];
    self.eventListReceived = [NSArray arrayWithArray:receiveEvent];
    [self.tableView reloadData];
}


#pragma mark ->TableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.currentIndexpath)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }
    else
        return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
        self.currentEvent = [self.eventListReceived objectAtIndex:indexPath.row];
    else
        self.currentEvent = [self.eventListSent objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showEvent" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 0;
    
    if (self.segmentedControl.selectedSegmentIndex == 0 && self.eventListReceived)
        lRet = self.eventListReceived.count;
    else if (self.eventListSent)
        lRet = self.eventListSent.count;
    return lRet;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListEventCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"ListEventCell"];
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        [cell initWithEvent:[self.eventListReceived objectAtIndex:indexPath.row]];
    else
        [cell initWithEvent:[self.eventListSent objectAtIndex:indexPath.row]];
    cell.tableView = self.tableView;
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void) setColorForCell:(UITableViewCell*) cell event:(PFObject*)event
{
    if (event[@"usersConcerned"])
        {
            NSArray *usersConcerned = event[@"usersConcerned"];
            NSArray *usersAccepted = event[@"usersAccepted"];
            NSArray *usersDeclined = event[@"usersDeclined"];
            if ((usersAccepted.count + usersDeclined.count - 2) == usersConcerned.count)
            {
                if (usersDeclined.count > 1 && usersAccepted.count > 1)
                    cell.imageView.image = [UIImage imageWithColor:[UIColor orangeColor] cornerRadius:6.0f];
                else if ((usersAccepted.count - 1) == usersConcerned.count)
                    cell.imageView.image = [UIImage imageWithColor:DEFAULTACCEPTCOLOR cornerRadius:6.0f];
                else
                    cell.imageView.image = [UIImage imageWithColor:DEFAULTDECLINECOLOR cornerRadius:6.0f];
            }
            else
                cell.imageView.image = [UIImage imageWithColor:[UIColor cloudsColor] cornerRadius:6.0f];
        }
    else
    {
        if ([event objectForKey:@"isReceived"] == [NSNumber numberWithBool:FALSE])
            cell.imageView.image = [UIImage imageWithColor:[UIColor cloudsColor] cornerRadius:6.0f];
        else
        {
            if ([event objectForKey:@"isAccepted"] == [NSNumber numberWithBool:TRUE])
                cell.imageView.image = [UIImage imageWithColor:DEFAULTACCEPTCOLOR cornerRadius:6.0f];
            else
                cell.imageView.image = [UIImage imageWithColor:DEFAULTDECLINECOLOR cornerRadius:6.0f];
        }
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuShow:(id)sender
{
   MenuViewController  *menu = [[MenuViewController alloc] init];

    menu.delegate = self;
    menu.view.frame = self.view.frame;
    menu.definesPresentationContext = YES;
    menu.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark ->Menu delegate

- (void) didDismissMenuWithSubMenuType:(subTypeMenu)type
{
    switch (type) {
        case kMenuLogout:
        {
            [PFUser logOut];
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }   break;
        default:
            break;
    }
}


#pragma mark ->ListEventCellDelegate

- (void) didClickOnDisplayEventButton:(ListEventCell *)cell
{
    self.currentIndexpath = cell.indexPath;
    if (cell.isSlided == TRUE)
    {
        [UIView animateWithDuration:0.8f animations:^{
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height - CONTAINERVIEWSIZEHEIGHT);
            cell.containerViewForCell.hidden = true;
            cell.buttonSlideCell.transform = CGAffineTransformRotate( cell.buttonSlideCell.transform, M_PI);
            cell.isSlided = false;
            cell.buttonSlideCell.enabled = true;
           // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
         completion:^(BOOL finished) {
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationBottom];
         }];
    }
    else
    {
        [UIView animateWithDuration:0.8f animations:^{
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + CONTAINERVIEWSIZEHEIGHT);
            cell.containerViewForCell.frame = CGRectMake(cell.containerViewForCell.frame.origin.x, cell.containerViewForCell.frame.origin.y,
                                                         cell.frame.size.width, CONTAINERVIEWSIZEHEIGHT);
            cell.containerViewForCell.hidden = false;
            cell.buttonSlideCell.transform = CGAffineTransformRotate(cell.buttonSlideCell.transform, M_PI);
            cell.isSlided = true;
            cell.buttonSlideCell.enabled = true;
        }
         completion:^(BOOL finished) {
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
         }];
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showEvent"])
    {
        UINavigationController *navVC = [segue destinationViewController];
        
        WPReceiveEventViewController *destVC = [[navVC viewControllers] objectAtIndex:0];
        destVC.event = self.currentEvent;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
