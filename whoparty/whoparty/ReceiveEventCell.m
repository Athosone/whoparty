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
#import "Animations.h"
#import "MarkerView.h"


@interface ReceiveEventCell ()

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) MarkerView      *currentMarker;

@property (strong, nonatomic) IBOutlet FUIButton *buttonCancel;
@property (strong, nonatomic) IBOutlet FUIButton *buttonAccept;

//Map
@property (strong, nonatomic) CLLocationManager                 *locationManager;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) MYGoogleAddress                   *myPos;
@property (strong, nonatomic) MYGoogleAddress                   *destPos;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;
@property (strong, nonatomic) IBOutlet FUIButton *buttonFinalCall;
@property (strong, nonatomic) NSString *textFinalCall;
@property (strong, nonatomic) NSArray  *usersConcerned;
@property (strong, nonatomic) NSArray  *usersAccepted;
@property (strong, nonatomic) NSArray  *usersDeclined;
@property (strong, nonatomic) IBOutlet UITextField *textfieldAddress;

@end

@implementation ReceiveEventCell

- (void)awakeFromNib {
    [WPHelperConstant setButtonToFlat:self.buttonAccept];
    [WPHelperConstant setButtonToFlat:self.buttonCancel];
    
    self.buttonAccept.buttonColor = [UIColor nephritisColor];
    self.buttonAccept.shadowColor = [UIColor emerlandColor];
    self.buttonCancel.buttonColor = [UIColor pomegranateColor];
    self.buttonCancel.shadowColor = [UIColor alizarinColor];
    
    self.labelComment.font = [UIFont flatFontOfSize:16.0f];
    self.labelComment.textColor = DEFAULTBGCOLOR;
    self.labelComment.text = @"";
    [self configureFlatCellWithColor:DEFAULTBGCOLOR selectedColor:DEFAULTBGCOLOR];
    [WPHelperConstant setBGColorForView:self.containerView color:[UIColor cloudsColor]];
    self.containerView.layer.cornerRadius = 6.0f;
    self.mapView.hidden = true;
    self.mapView.layer.cornerRadius = 6.0f;
    
    self.mapView.mapType = kGMSTypeNormal;
    //Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.currentMarker = nil;
}


- (NSString *)reuseIdentifier
{
    return @"ReceiveEventCell";
}

- (void) initReceiveEventCell:(MYGoogleAddress*)gA comment:(NSString*)comment
{
      self.labelComment.text = comment;
    if (gA)
    {
        self.destPos = gA;
        NSString *address = self.destPos[@"address"];
        if (address.length > 0)
            self.textfieldAddress.text = address;
        else
            self.textfieldAddress.hidden = true;
        [self initMap];
        if (self.mapView.hidden == TRUE)
            [self showMap];
    }
}


- (void) initReceiveEventCellWithEvent:(PFObject*)event
{
    self.mapView.selectedMarker = nil;
    self.destPos = event[@"mygoogleaddress"];
    self.labelComment.text = event[@"comment"];
    self.usersConcerned = event[@"usersConcerned"];
    self.usersAccepted = event[@"usersAccepted"];
    self.usersDeclined = event[@"usersDeclined"];
    self.mapView.delegate = self;
    if (self.destPos)
    {
        NSString *address = self.destPos[@"address"];
        if (address.length > 0)
            self.textfieldAddress.text = address;
        else
            self.textfieldAddress.hidden = true;
        [self initMap];
        if (self.mapView.hidden == TRUE)
            [self showMap];
    }
}

- (void) initMap
{
    
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

- (void) setAcceptedStatus
{
    [WPHelperConstant setButtonToFlat:self.buttonFinalCall];
    self.buttonFinalCall.buttonColor = [UIColor nephritisColor];
    self.buttonFinalCall.shadowColor = [UIColor emerlandColor];
    self.buttonCancel.hidden = true;
    self.buttonAccept.hidden = true;
    self.buttonFinalCall.hidden = false;
    [self.buttonFinalCall setTitle:@"Accepted" forState:UIControlStateNormal];

}

- (void) setDeclineStatus
{
    [WPHelperConstant setButtonToFlat:self.buttonFinalCall];
    self.buttonFinalCall.buttonColor = [UIColor pomegranateColor];
    self.buttonFinalCall.shadowColor = [UIColor alizarinColor];
    self.buttonCancel.hidden = true;
    self.buttonAccept.hidden = true;
    self.buttonFinalCall.hidden = false;
    [self.buttonFinalCall setTitle:@"Declined" forState:UIControlStateNormal];
    
}

- (void) setSendingUserStyle
{
    [WPHelperConstant setButtonToFlat:self.buttonFinalCall];
    self.buttonFinalCall.buttonColor = [UIColor concreteColor];
    self.buttonFinalCall.shadowColor = [UIColor cloudsColor];
    self.buttonCancel.hidden = true;
    self.buttonAccept.hidden = true;
    self.buttonFinalCall.hidden = false;
    [self.buttonFinalCall setTitle:@"Pending" forState:UIControlStateNormal];

}

- (void) setMixedStatus
{
    [WPHelperConstant setButtonToFlat:self.buttonFinalCall];
    self.buttonFinalCall.buttonColor = [UIColor pumpkinColor];
    self.buttonFinalCall.shadowColor = [UIColor carrotColor];
    self.buttonCancel.hidden = true;
    self.buttonAccept.hidden = true;
    self.buttonFinalCall.hidden = false;
    [self.buttonFinalCall setTitle:@"Some people declined" forState:UIControlStateNormal];
    [self.buttonFinalCall sizeToFit];

}

- (IBAction)declineButtonOnClick:(id)sender
{
    [self.delegate didClickOnDeclineButton:self];    
}

- (IBAction)acceptButtonOnClick:(id)sender
{
    [self.delegate didClickOnAcceptButton:self];
}

- (void) hideMap
{
    self.mapView.hidden = true;
}

- (void) showMap
{
    self.mapView.hidden = false;
    [Animations addMaskExpandleRectAnimation:self.mapView duration:1];
}

#pragma mark ->GoogleMap delegate

- (UIView*) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    CLLocationCoordinate2D anchor = marker.position;

    MarkerView *view = [[MarkerView alloc] init];
    view.frame = CGRectMake(0, 0, 200, 100);
    
    view.usersDeclined = self.usersDeclined;
    view.usersAccepted = self.usersAccepted;
    view.usersConcerned = self.usersConcerned;
    [view initViewWithMarker:marker];
    view.center = [self.mapView.projection pointForCoordinate:anchor];
    
    return view;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    mapView.selectedMarker = marker;
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
