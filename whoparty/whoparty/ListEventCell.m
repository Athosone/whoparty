//
//  ListEventCell.m
//  whoparty
//
//  Created by Werck Ayrton on 15/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <math.h>
#import "ListEventCell.h"
#import "WPHelperConstant.h"


@interface ListEventCell ()

@property (strong, nonatomic) IBOutlet UILabel *usernameSender;
@property (strong, nonatomic) IBOutlet UILabel *labelDateOfEvent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSenderPicture;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;
@property (strong, nonatomic) IBOutlet UILabel *labelNbUsersYes;
@property (strong, nonatomic) IBOutlet UILabel *labelNbUsersConcerned;
@property (strong, nonatomic) IBOutlet UILabel *labelNBUsersDeclined;


@end

//IDEA
//Pour la container view autant mettre la frame a zero et l'augmenté au fur et a
//mesure que la cell augmente ca taille && use mask layer

@implementation ListEventCell


- (NSString*) reuseIdentifier
{
    return @"ListEventCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    //self.containerViewForCell.hidden = true;
    //self.containerViewForCell.frame = CGRectMake(self.containerViewForCell.frame.origin.x, self.containerViewForCell.frame.origin.y,                                                 0,0);
    self.isSlided = false;
   // self.layer.mask = self.containerViewForCell.layer;
//     self.containerViewForCell.layer.mask = self.layer;
}

- (void) initWithEvent:(PFObject*) event
{
    self.event = event;
    self.usernameSender.text = (NSString*)self.event[@"sendinguser"];
    self.labelDateOfEvent.text = [WPHelperConstant dateToString:self.event[@"eventdate"]];
    self.labelComment.text = self.event[@"comment"];
    self.labelNbUsersConcerned.text = [NSString stringWithFormat:@"%d",((NSArray*)self.event[@"usersConcerned"]).count];
    self.labelNBUsersDeclined.text = [NSString stringWithFormat:@"%d",((NSArray*)self.event[@"usersDeclined"]).count];
    self.labelNbUsersYes.text = [NSString stringWithFormat:@"%d",((NSArray*)self.event[@"usersAccepted"]).count];
    [WPHelperConstant setBlurForCell:self];

}

- (IBAction)displayEventButonOnClick:(id)sender
{
    self.buttonSlideCell.enabled = false;
    [self.delegate didClickOnDisplayEventButton:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
