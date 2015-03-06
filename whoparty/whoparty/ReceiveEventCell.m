//
//  ReceiveEventCell.m
//  whoparty
//
//  Created by Werck Ayrton on 06/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ReceiveEventCell.h"
#import "WPHelperConstant.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ReceiveEventCell ()

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet FUIButton *buttonCancel;
@property (strong, nonatomic) IBOutlet FUIButton *buttonAccept;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation ReceiveEventCell

- (void)awakeFromNib {
    // Initialization code
}

- (NSString *)reuseIdentifier
{
    return @"ReceiveEventCell";
}

- (void) initReceiveEventCell
{
    [WPHelperConstant setButtonToFlat:self.buttonAccept];
    [WPHelperConstant setButtonToFlat:self.buttonCancel];
    
    self.buttonAccept.buttonColor = [UIColor nephritisColor];
    self.buttonAccept.shadowColor = [UIColor emerlandColor];
    self.buttonCancel.buttonColor = [UIColor pomegranateColor];
    self.buttonCancel.shadowColor = [UIColor alizarinColor];
    
    [self configureFlatCellWithColor:DEFAULTBGCOLOR selectedColor:DEFAULTBGCOLOR];
    [WPHelperConstant setBGColorForView:self.containerView color:[UIColor cloudsColor]];
    self.containerView.layer.cornerRadius = 6.0f;
}

- (IBAction)declineButtonOnClick:(id)sender
{
    
}

- (IBAction)acceptButtonOnClick:(id)sender
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
