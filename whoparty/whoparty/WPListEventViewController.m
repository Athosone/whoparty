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

@interface WPListEventViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray    *eventList;
@property (strong, nonatomic) NSArray    *eventListReceived;
@property (strong, nonatomic) NSArray    *eventListSent;
@property (strong, nonatomic) Event      *currentEvent;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (void) receivedPushNotfication:(NSDictionary*) userInfo;
- (void) updateEventList:(NSArray*)events;

@end

@implementation WPListEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:DEFAULTNAVBARBGCOLOR];
    [WPHelperConstant setBGColorForView:self.tableView color:nil];
    [ManagedParseUser fetchLocalEvents:self selector:@selector(updateEventList:)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPushNotfication:) name:HASRECEIVEDPUSHNOTIFICATION object:nil];
}

#pragma mark ->Segmented COntrol

- (IBAction)segmentedControlOnClick:(id)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
        self.eventList = self.eventListReceived;
    else
        self.eventList = self.eventListSent;
    [self.tableView reloadData];
}

#pragma mark ->Set Event list-Received push Notifcation

- (void) receivedPushNotfication:(NSDictionary*) userInfo
{
    NSLog(@"Login-ViewController-userinfo receive push notification: %@", userInfo);
    [ManagedParseUser fetchLocalEvents:self selector:@selector(updateEventList:)];
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
        PFUser *u = e[@"sendinguser"];
        
        if ([u[@"username"] isEqualToString:currentUser.username])
            [sentEvent addObject:e];
        else
            [receiveEvent addObject:e];
    }
    self.eventList  = [NSArray arrayWithArray:receiveEvent];
    self.eventListSent = [NSArray arrayWithArray:sentEvent];
    self.eventListReceived = [NSArray arrayWithArray:receiveEvent];
    [self.tableView reloadData];
}


#pragma mark ->TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentEvent = [self.eventList objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"showEvent" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 1;
    if (self.eventList)
        lRet = self.eventList.count;
    return lRet;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if ([self.eventList objectAtIndex:indexPath.row])
    {
        Event *event = [self.eventList objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"ic_qu_direction_mylocation@3x"];
        cell.imageView.layer.cornerRadius = 6.0f;

       if ([event objectForKey:@"isAccepted"])
           cell.imageView.image = [UIImage imageWithColor:DEFAULTACCEPTCOLOR cornerRadius:6.0f];
        else
            cell.imageView.image = [UIImage imageWithColor:DEFAULTDECLINECOLOR cornerRadius:6.0f];
        PFUser *sendinguser = [event objectForKey:@"sendinguser"];
        if (self.segmentedControl.selectedSegmentIndex == 0)
            cell.textLabel.text = sendinguser.username;
        else
            cell.textLabel.text = event[@"userReceived"];
    }
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
