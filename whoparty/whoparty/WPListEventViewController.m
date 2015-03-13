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

- (void) receivedPushNotfication:(NSDictionary*) userInfo;
- (void) updateEventList:(NSArray*)events;
- (void) updateDone:(PFObject*)object;

@end

@implementation WPListEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:DEFAULTNAVBARBGCOLOR];
    [WPHelperConstant setBGColorForView:self.tableView color:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPushNotfication:) name:HASRECEIVEDPUSHNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedisAcceptedPushNotfication:) name:HASRECEIVEDISACCEPTEDNOTFICATION object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    UITableViewCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray         *eventList = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        eventList = self.eventListReceived;
    else
       eventList = self.eventListSent;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if ([eventList objectAtIndex:indexPath.row])
    {
        PFObject *event = [eventList objectAtIndex:indexPath.row];
        
        cell.imageView.layer.cornerRadius = 6.0f;
        
         [self setColorForCell:cell event:event];
        
        NSString *sendingusername = [event objectForKey:@"sendinguser"];
        NSArray *users = event[@"usersConcerned"];
        NSString *cellText = @"";
        if (users.count > 1)
            cell.textLabel.text = event[@"groupName"];
        else
        {
            if (self.segmentedControl.selectedSegmentIndex == 0)
                cell.textLabel.text = [cellText stringByAppendingString:sendingusername];
            else
                cell.textLabel.text = event[@"receivinguser"];
        }
        NSString *dateString = [WPHelperConstant dateToString:event.createdAt];
        cell.detailTextLabel.text = dateString;
    }
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
