//
//  SelectPlace.m
//  whoparty
//
//  Created by Werck Ayrton on 16/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "SelectPlace.h"

@interface SelectPlace ()

@property (strong, nonatomic) CLLocationManager                 *locationManager;
@property (strong, nonatomic) IBOutlet UIImageView              *mapCenterPinImage;
@property (strong, nonatomic) IBOutlet UISearchBar              *searchBar;
@property (strong, nonatomic) NSMutableDictionary               *datas;
@property (strong, nonatomic) NSMutableArray                    *foundPlaces;
@property (strong, nonatomic) IBOutlet UITableView              *tableViewAddress;
@property (strong, nonatomic) MBProgressHUD                     *hud;
@property (strong, nonatomic) MYGoogleAddress                   *currentAddr;
@property (weak, nonatomic) IBOutlet GMSMapView *gmView;

- (void) initMap;

@end

@implementation SelectPlace

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NSString * nibName = @"MyCustomView";
        [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
    }
    return self;
}

-(void) initAddEventCell
{
    self.searchBar.delegate = self;
    self.datas = [[NSMutableDictionary alloc] init];
    
    [self initMap];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.hud.labelText = @"Loading";
    self.hud.hidden = TRUE;
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
    MYGoogleAddress *gA = nil;
    
    if (self.foundPlaces.count > 0)
        gA = [self.foundPlaces objectAtIndex:indexPath.row];
    else
        gA = self.currentAddr;
    
    CLLocation *dest = [[CLLocation alloc] initWithLatitude:gA.latitude longitude:gA.longitude];
    
    NSLog(@"Latitude: %f, longitude: %f", gA.latitude, gA.longitude);
    GMSMarker *destPoint = [GMSMarker markerWithPosition:dest.coordinate];
    destPoint.map = self.gmView;
    destPoint.title = gA.name;
    destPoint.snippet = gA.address;
    self.gmView.camera = [GMSCameraPosition cameraWithLatitude:dest.coordinate.latitude longitude:dest.coordinate.longitude zoom:15.0];
    self.tableViewAddress.hidden = true;
    self.foundPlaces = nil;
    self.currentAddr = gA;
}

- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [mtableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
    }
    MYGoogleAddress *add = [self.foundPlaces objectAtIndex:indexPath.row];
    
    NSString *name = add.name;
    NSString *addString = add.address;
    
    NSString *cellText = [NSString stringWithFormat:@"%@, %@", name, addString];
    cell.textLabel.text = cellText;
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
