//
//  WPAddEventViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ManagedParseUser.h"
#import "WPAddEventViewController.h"
#import "GooglePlaceDataProvider.h"
#import "MYGoogleAddress.h"
#import "WPSelectFriendsViewController.h"

@interface WPAddEventCell : UITableViewCell<UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>



@property (strong, nonatomic) IBOutlet GMSMapView             *gmView;
@property (strong, nonatomic) IBOutlet UIImageView            *mapCenterPinImage;
@property (strong, nonatomic) CLLocationManager      *locationManager;
@property (strong, nonatomic) IBOutlet UISearchBar            *searchBar;
@property (strong, nonatomic) NSMutableDictionary    *datas;
@property (strong, nonatomic) NSMutableArray         *foundPlaces;
@property (strong, nonatomic) IBOutlet UITableView            *tableViewAddress;
@property (strong, nonatomic) MBProgressHUD          *hud;
@property (strong, nonatomic) MYGoogleAddress        *currentAddr;
@property (weak, nonatomic  ) UITableView            *tableView;
@property (weak, nonatomic  ) id                <WPAddEventCellProtocol> delegate;
@property (strong, nonatomic) UIView                 *activeField;
@property (strong, nonatomic) IBOutlet UITextView             *textViewComment;

- (void) initMap;
-(void)addDoneToolBarToKeyboard:(UITextView *)textView;

@end

@implementation WPAddEventCell

@synthesize tableView;
@synthesize delegate;

- (void) initAddEventCell
{
    self.searchBar.delegate = self;
    self.datas = [[NSMutableDictionary alloc] init];
    [self initMap];
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.hud.labelText = @"Loading";
    self.hud.hidden = TRUE;
    self.activeField = self.textViewComment;
    [self addDoneToolBarToKeyboard:self.textViewComment];
}

- (void) initMap
{
    self.tableViewAddress.delegate = self;
    self.tableViewAddress.dataSource = self;
    self.tableViewAddress.hidden = TRUE;
    self.mapCenterPinImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.mapCenterPinImage.image = [UIImage imageNamed:@"startPin"];
    self.gmView.mapType = kGMSTypeNormal;
    //Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

- (void) doneButtonClickedDismissKeyboard
{
    if ([self.textViewComment isFirstResponder])
        [self.textViewComment resignFirstResponder];
}

- (IBAction)validateEvent:(id)sender
{
    NSDictionary *dataToPass =  [NSDictionary dictionaryWithObjectsAndKeys:self.currentAddr, @"currentAddress", self.textViewComment.text, @"comment", nil];
        
    [self.delegate didClickOnCellButton:self datas:dataToPass];
}

#pragma mark ->CLLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations objectAtIndex:0])
    {
        void (^successGeoReverse)(NSString *cityName) = ^(NSString *cityName)
        {
            [self.datas setObject:cityName forKey:@"city"];
            NSLog(@"CITYNAME : %@", cityName);
        };
        
        CLLocation *location = (CLLocation*)[locations objectAtIndex:0];
        
        [self.datas setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
        [self.datas setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
        
        //Attention indiquer au user que l'on a pas encore toute les infos
        [GooglePlaceDataProvider getCityNameFromLocation:location success:successGeoReverse];

        self.gmView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:15 bearing:0 viewingAngle:0];
        //Call if no longer intrested in user location updates
        [self.locationManager stopUpdatingLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager startUpdatingLocation];
        self.gmView.myLocationEnabled = TRUE;
        [self.gmView settings].myLocationButton = TRUE;
    }
}

#pragma mark ->SearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.activeField = nil;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length < 3)
        return;
    NSString *placeName = searchBar.text;
    [self.datas setObject:placeName forKey:@"name"];
    
    self.hud.hidden = FALSE;
    [GooglePlaceDataProvider fetchPlaceByName:self.datas success:@selector(displayFoundedAddresses:) target:self];
    [self.searchBar resignFirstResponder];
}

-  (void) displayFoundedAddresses:(NSMutableArray*)places
{
    if (places.count > 0)
    {
        self.foundPlaces = places;
        self.tableViewAddress.hidden = FALSE;
        [self.tableViewAddress reloadData];
    }
    self.hud.hidden = TRUE;
}



#pragma mark ->UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger lRet = 0;
    
    lRet = self.foundPlaces.count;
    return lRet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYGoogleAddress *gA = [self.foundPlaces objectAtIndex:indexPath.row];
    
    CLLocation *dest = [[CLLocation alloc] initWithLatitude:gA.latitude longitude:gA.longitude];
    
    GMSMarker *destPoint = [GMSMarker markerWithPosition:dest.coordinate];
    destPoint.map = self.gmView;
    destPoint.title = gA.name;
    self.gmView.camera = [GMSCameraPosition cameraWithLatitude:dest.coordinate.latitude longitude:dest.coordinate.longitude zoom:15.0];
    self.tableViewAddress.hidden = true;
    self.foundPlaces = nil;
    self.currentAddr = gA;
    self.activeField = self.textViewComment;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    
    MYGoogleAddress *add = [self.foundPlaces objectAtIndex:indexPath.row];
    
    NSString *name = add.name;
    NSString *addString = add.address;
    
    NSString *cellText = [NSString stringWithFormat:@"%@, %@", name, addString];
    cell.textLabel.text = cellText;
    return cell;
}

@end


#pragma mark ->ViewController

@interface WPAddEventViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary           *comment_mapDatas;


@end

@implementation WPAddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ->TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int lRet = 1;
    
    return lRet;
}


- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPAddEventCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"WPAddEventCell"];
    
    if (!cell)
        cell = [[WPAddEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPAddEventCell"];
    [cell initAddEventCell];
    cell.tableView = self.tableView;
    cell.delegate = self;
    return cell;
}

#pragma mark ->WPAddEventProtocol

- (void) didClickOnCellButton:(id)sender datas:(NSDictionary *)datas
{
    self.comment_mapDatas = datas;
    [self performSegueWithIdentifier:@"selectFriends" sender:self];
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
}


@end
