//
//  SelectPlaceViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 16/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "WPHelperConstant.h"
#import "SelectPlaceViewController.h"
#import "WPSumUpViewController.h"

@interface SelectPlaceViewController ()

@property (strong, nonatomic) CLLocationManager                 *locationManager;
@property (strong, nonatomic) IBOutlet UISearchBar              *searchBar;
@property (strong, nonatomic) NSMutableDictionary               *datas;
@property (strong, nonatomic) NSMutableArray                    *foundPlaces;
@property (weak, nonatomic) IBOutlet UITableView              *tableViewAddress;
@property (strong, nonatomic) MBProgressHUD                     *hud;
@property (strong, nonatomic) MYGoogleAddress                   *currentAddr;
@property (weak, nonatomic) IBOutlet GMSMapView *gmView;
@property (strong, nonatomic) NSArray                           *autoCompleteAddresses;

- (void) initMap;
@end

@implementation SelectPlaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.datas = [[NSMutableDictionary alloc] init];
    
    [self initMap];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading";
    self.hud.hidden = TRUE;
    self.title = @"Select a place";
    //[WPHelperConstant setBlurForView:self.tableViewAddress];
    self.tableViewAddress.backgroundColor = [UIColor clearColor];
    [WPHelperConstant setBGWithImageForView:self.view image:@"lacBG"];
}

- (void) initMap
{
    self.tableViewAddress.delegate = self;
    self.tableViewAddress.dataSource = self;
    self.tableViewAddress.hidden = TRUE;
    
    self.gmView.mapType = kGMSTypeNormal;
    
    //Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
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
        if (!self.currentAddr)
        {
            self.currentAddr = [[MYGoogleAddress alloc] init];
            self.currentAddr.name = [PFUser currentUser].username;
        }
        self.currentAddr.latitude = location.coordinate.latitude;
        self.currentAddr.longitude = location.coordinate.longitude;
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        self.tableViewAddress.hidden = true;
        self.autoCompleteAddresses = nil;
    }
    else
        [GooglePlaceDataProvider getAutoComplete:self.datas searchText:searchText completionBlock:^(NSArray *foundedAutoCompletePlaces) {
            self.autoCompleteAddresses = foundedAutoCompletePlaces;
            [self.tableViewAddress reloadData];
            self.tableViewAddress.hidden = false;
        }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
    }
    
    
    MYGoogleAddress *gA = nil;
    
    if (self.foundPlaces.count > 0)
        gA = [self.foundPlaces objectAtIndex:0];
    else
        gA = self.currentAddr;
    CLLocation *dest = [[CLLocation alloc] initWithLatitude:gA.latitude longitude:gA.longitude];
    
    //En test a voir si ca marche bien
    [self.gmView clear];
    
    NSLog(@"Latitude: %f, longitude: %f", gA.latitude, gA.longitude);
    GMSMarker *destPoint = [GMSMarker markerWithPosition:dest.coordinate];
    destPoint.map = self.gmView;
    destPoint.title = gA.name;
    destPoint.snippet = gA.address;
    self.gmView.camera = [GMSCameraPosition cameraWithLatitude:dest.coordinate.latitude longitude:dest.coordinate.longitude zoom:15.0];
    self.tableViewAddress.hidden = true;
    self.foundPlaces = nil;
    self.currentAddr = gA;
    self.hud.hidden = TRUE;
}



#pragma mark ->UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger lRet = 0;
    
    if (self.autoCompleteAddresses)
        lRet = self.autoCompleteAddresses.count;
    return lRet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchBar.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
    }
    cell.textLabel.text = [self.autoCompleteAddresses objectAtIndex:indexPath.row];
    [WPHelperConstant setBlurForCell:cell];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)nextButtonOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"WPSumUpViewController" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"WPSumUpViewController"])
    {
        WPSumUpViewController *destVC = (WPSumUpViewController*)[segue destinationViewController];
        
        destVC.selectedPlace = self.currentAddr;
        destVC.selectedDate = self.selectedDate;
    }
}


@end
