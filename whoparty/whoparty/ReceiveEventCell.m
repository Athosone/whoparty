//
//  ReceiveEventCell.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ReceiveEventCell.h"
#import "WPHelperConstant.h"
#import "GooglePlaceDataProvider.h"

@interface ReceiveEventCell ()

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet FUIButton *buttonCancel;
@property (strong, nonatomic) IBOutlet FUIButton *buttonAccept;

//Map
@property (strong, nonatomic) CLLocationManager                 *locationManager;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) MYGoogleAddress                   *myPos;
@property (strong, nonatomic) MYGoogleAddress                   *destPos;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;

- (void) placeDestOnMap:(MYGoogleAddress*)gA;

@end

@implementation ReceiveEventCell

- (void)awakeFromNib {
    // Initialization code
}

- (NSString *)reuseIdentifier
{
    return @"ReceiveEventCell";
}

- (void) initReceiveEventCell:(MYGoogleAddress*)gA comment:(NSString*)comment
{
    [WPHelperConstant setButtonToFlat:self.buttonAccept];
    [WPHelperConstant setButtonToFlat:self.buttonCancel];
    
    self.buttonAccept.buttonColor = [UIColor nephritisColor];
    self.buttonAccept.shadowColor = [UIColor emerlandColor];
    self.buttonCancel.buttonColor = [UIColor pomegranateColor];
    self.buttonCancel.shadowColor = [UIColor alizarinColor];
    
    self.labelComment.font = [UIFont flatFontOfSize:16.0f];
    self.labelComment.textColor = DEFAULTBGCOLOR;
    self.labelComment.text = comment;
    [self configureFlatCellWithColor:DEFAULTBGCOLOR selectedColor:DEFAULTBGCOLOR];
    [WPHelperConstant setBGColorForView:self.containerView color:[UIColor cloudsColor]];
    self.containerView.layer.cornerRadius = 6.0f;
    if (gA)
    {
        self.destPos = gA;
        [self initMap];
    }
}

- (void) initMap
{
    self.mapView.mapType = kGMSTypeNormal;
    //Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [GooglePlaceDataProvider setPointForView:self.mapView mygoogleAddress:self.destPos];
    [GooglePlaceDataProvider setCameraPositionForView:self.mapView mygoogleAddress:self.destPos];
}

#pragma mark ->CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations objectAtIndex:0])
    {
        CLLocation *location = (CLLocation*)[locations objectAtIndex:0];
        
        if (!self.myPos)
            self.myPos = [[MYGoogleAddress alloc] init];
        self.myPos.latitude = location.coordinate.latitude;
        self.myPos.longitude = location.coordinate.longitude;
        //Call if no longer intrested in user location updates
        [self.locationManager stopUpdatingLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager startUpdatingLocation];
        self.mapView.myLocationEnabled = TRUE;
        [self.mapView settings].myLocationButton = TRUE;
    }
}

- (IBAction)declineButtonOnClick:(id)sender
{
    
}

- (IBAction)acceptButtonOnClick:(id)sender
{
    
}


#pragma mark ->Map


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
