//
//  WPListEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "WPListEventViewController.h"
#import "WPHelperConstant.h"
#import "ManagedParseUser.h"
#import "Event.h"
#import "WPReceiveEventViewController.h"
#import "Animations.h"
#import "GooglePlaceDataProvider.h"
#import "MoreListEventTableViewCell.h"

#define SECTIONHEIGHT 125
#define ROWHEIGHT 270

@interface WPListEventViewController ()

@property (strong, nonatomic) IBOutlet SLExpandableTableView *tableView;
@property (strong, nonatomic) NSArray    *eventListReceived;
@property (strong, nonatomic) NSArray    *eventListSent;
@property (strong, nonatomic) Event      *currentEvent;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barbuttonitemMenu;

- (void) receivedPushNotfication:(NSDictionary*) userInfo;
- (void) updateEventList:(NSArray*)events;

@end

//TODO pour accepter ou decliner mettre en mode button avec le blanc a gauche
//TODO cacher le button ajouter des amis si receveur ou bien proposer option a l'envoyeur d'autoriser ou pas les receveurs à inviter des gens

@implementation WPListEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPushNotfication:) name:HASRECEIVEDPUSHNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedisAcceptedPushNotfication:) name:HASRECEIVEDISACCEPTEDNOTFICATION object:nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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

#pragma mark ->SLExpandableTableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 0;
    
    if (self.segmentedControl.selectedSegmentIndex == 0 && self.eventListReceived)
        lRet = self.eventListReceived.count;
    else if (self.eventListSent)
        lRet = self.eventListSent.count;
    return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger lRet = 0;
    
    if (self.segmentedControl.selectedSegmentIndex == 0 && self.eventListReceived)
        lRet = self.eventListReceived.count;
    else if (self.eventListSent)
        lRet = self.eventListSent.count;
    return lRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreListEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreListEventTableViewCell"];
    NSArray *eventList = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        eventList = self.eventListReceived;
    else
        eventList = self.eventListSent;

    if (!cell)
    {
        cell = [[MoreListEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreListEventTableViewCell"];
    }
    cell.delegate = self;
    cell.indexpath = indexPath;
    [cell initWithEvent:[eventList objectAtIndex:indexPath.section]];
    return cell;
}


- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    PFObject *event = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0 && self.eventListReceived)
        event = [self.eventListReceived objectAtIndex:section];
    else if (self.eventListSent)
        event = [self.eventListSent objectAtIndex:section];
    
    PFObject *addressToUpdate = event[@"mygoogleaddress"];
    
   if ([addressToUpdate isDataAvailable])
       return NO;
    else
        return YES;//, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
    //return NO;
}

- (UITableViewCell<UIExpandingTableViewCell>*)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
   ListEventCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ListEventCell"];
    NSArray *eventList = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        eventList = self.eventListReceived;
    else
        eventList = self.eventListSent;
    
    if (!cell)
    {
        cell = [[ListEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListEventCell"];
    }
    [cell initWithEvent:[eventList objectAtIndex:section]];
    return cell;
}

#pragma mark ->SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    PFObject *event = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0 && self.eventListReceived)
        event = [self.eventListReceived objectAtIndex:section];
    else if (self.eventListSent)
        event = [self.eventListSent objectAtIndex:section];
    
    PFObject *addressToUpdate = event[@"mygoogleaddress"];
    
    [addressToUpdate fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       if (!error)
       {
           [object pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               [tableView expandSection:section animated:YES];
           }];
       }
        else
        {
            NSLog(@"Error fetching address in: tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section, error:%@" ,error);
           [tableView cancelDownloadInSection:section];
        }
    }];
    
    // download your data here
     //[tableView expandSection:section animated:YES]; //if download was successful
    // call [tableView cancelDownloadInSection:section]; if your download was NOT successful
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated
{
    //...
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    //...
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
        self.currentEvent = [self.eventListReceived objectAtIndex:indexPath.section];
    else
        self.currentEvent = [self.eventListSent objectAtIndex:indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return SECTIONHEIGHT;
    return ROWHEIGHT;
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

#pragma mark ->Menu

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


#pragma mark ->MoreListEventTableViewCellDelegate

- (void) didClickOnDisplayEventButton:(ListEventCell *)cell
{
       [self.tableView reloadData];
}

- (void) didClickOnAcceptedButton:(MoreListEventTableViewCell *)cell
{
    PFObject    *event = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        event = [self.eventListReceived objectAtIndex:cell.indexpath.section];
    else
        event = [self.eventListSent objectAtIndex:cell.indexpath.section];
    
    NSMutableArray *friends = event[@"usersAccepted"];
    if (friends == nil)
        friends = [[NSMutableArray alloc] init];
    if ([friends containsObject:[PFUser currentUser].username])
    {
        [friends removeObject:[PFUser currentUser].username];
        //save event
        return;
    }
    else
        [friends addObject:[PFUser currentUser].username];
    [event setObject:friends forKey:@"usersAccepted"];
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             [event pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                 NSString *alert = [NSString stringWithFormat:@"%@ just accepted your event !",[PFUser currentUser].username];
                 
                 [data setObject:alert forKey:@"alert"];
                 [data setObject:@"eventIsAccepted" forKey:@"eventType"];
                 [data setObject:@"default" forKey:@"sound"];
                 [data setObject:event.objectId forKey:@"eventId"];
                 [ManagedParseUser sendNotificationPush:event[@"sendinguser"] data:data completionBlock:^{
                     NSLog(@"Event Accepted");
                 }];
                 [self.tableView reloadData];
             }];
         }
         else
         {
             NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
             [event saveEventually];
         }
     }];
}

- (void) didClickOnDeclinedButton:(MoreListEventTableViewCell *)cell
{
    PFObject    *event = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        event = [self.eventListReceived objectAtIndex:cell.indexpath.section];
    else
        event = [self.eventListSent objectAtIndex:cell.indexpath.section];
    
    
    NSMutableArray *friends = event[@"usersDeclined"];
    if (friends == nil)
        friends = [[NSMutableArray alloc] init];
    if ([friends containsObject:[PFUser currentUser].username])
    {
        [friends removeObject:[PFUser currentUser].username];
        //save event
        return;
    }
    else
        [friends addObject:[PFUser currentUser].username];
    
    [event setObject:friends forKey:@"usersDeclined"];
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             [event pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                 NSString *alert = [NSString stringWithFormat:@"%@ just declined your event !",[PFUser currentUser].username];
                 
                 [data setObject:alert forKey:@"alert"];
                 [data setObject:@"eventIsAccepted" forKey:@"eventType"];
                 [data setObject:@"default" forKey:@"sound"];
                 [data setObject:event.objectId forKey:@"eventId"];
                 [ManagedParseUser sendNotificationPush:event[@"sendinguser"] data:data completionBlock:^{
                     NSLog(@"Event Declined");
                 }];
                 [self.tableView reloadData];
             }];
         }
         else
         {
             NSLog(@"Error saving event in SelectFriends-sendNotificationPush, error: %@", error);
             [event saveEventually];
         }
     }];
}

- (void) didClickOnCancelEvent:(MoreListEventTableViewCell *)cell
{
    
}

- (void) didClickOnMapButton:(MoreListEventTableViewCell *)cell
{
    PFObject    *destPos = nil;
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
        destPos = [[self.eventListReceived objectAtIndex:cell.indexpath.section] objectForKey:@"mygoogleaddress"];
    else
        destPos = [[self.eventListSent objectAtIndex:cell.indexpath.section] objectForKey:@"mygoogleaddress"];
    
    NSString *linkGoogle = [NSString stringWithFormat:@"%@%@,%@&zoom=14", GOOGLEBASELINK,
                            destPos[@"latitude"],
                            destPos[@"longitude"]];
    
    
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkGoogle]])
    {
        NSString *linkMAPS = [NSString stringWithFormat:@"%@%@,%@&zoom=14", MAPSBASELINK,
                              destPos[@"latitude"],
                              destPos[@"longitude"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkMAPS]];
    }

}

- (void) didClickOnAddToCalendarButton:(MoreListEventTableViewCell *)cell
{
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"Event Title";
        event.startDate = [NSDate date]; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        //self.savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
    }];
}

#pragma mark - Navigation

- (IBAction)addEventOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"WPChooseDateViewController" sender:self];
}

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
