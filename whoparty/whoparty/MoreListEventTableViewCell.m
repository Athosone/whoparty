//
//  MoreListEventTableViewCell.m
//  whoparty
//
//  Created by Werck Ayrton on 24/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import "MoreListEventTableViewCell.h"
#import "WPHelperConstant.h"

@interface MoreListEventTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *buttonUsersAccepted;
@property (weak, nonatomic) IBOutlet UIButton *buttonUsersDeclined;
@property (weak, nonatomic) IBOutlet UILabel *labelDateFull;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddToCalendar;
@property (weak, nonatomic) IBOutlet UIButton *buttonMAP;
@property (weak, nonatomic) IBOutlet UIButton *cancelEvent;
@property (strong, nonatomic) IBOutlet UILabel *labelNbUsersYes;
@property (strong, nonatomic) IBOutlet UILabel *labelNbUsersConcerned;
@property (strong, nonatomic) IBOutlet UILabel *labelNBUsersDeclined;
@property (strong, nonatomic) PFObject          *event;

@end

@implementation MoreListEventTableViewCell

- (void)awakeFromNib {
    self.buttonUsersAccepted.layer.borderColor = [UIColor greenColor].CGColor;
    self.buttonUsersAccepted.layer.borderWidth = 2;
    self.buttonUsersDeclined.layer.borderColor = [UIColor redColor].CGColor;
    self.buttonUsersDeclined.layer.borderWidth = 2;
    [WPHelperConstant setBlurForCell:self];
}

- (void) initWithEvent:(PFObject*) event
{
    self.event = event;
    PFObject *address = self.event[@"mygoogleaddress"];
    
    NSLog(@"address: %@", address);
    self.labelNbUsersConcerned.text = [NSString stringWithFormat:@"%lu",(unsigned long)((NSArray*)self.event[@"usersConcerned"]).count];
    
    self.labelNBUsersDeclined.text = [NSString stringWithFormat:@"%lu",(unsigned long)((NSArray*)self.event[@"usersDeclined"]).count];
    self.labelNbUsersYes.text = [NSString stringWithFormat:@"%lu",(unsigned long)((NSArray*)self.event[@"usersAccepted"]).count];
    self.labelDateFull.text = [WPHelperConstant getDateStringFromDate:self.event[@"eventdate"]];
    self.labelAddress.text = address[@"name"];
    NSLog(@"namme: %@", [PFUser currentUser].username);
    if ([self.event[@"sendinguser"] isEqualToString:[PFUser currentUser].username])
    {
        self.buttonUsersAccepted.enabled = false;
        self.buttonUsersDeclined.enabled = false;
        self.cancelEvent.enabled = true;
        self.cancelEvent.hidden = false;
    }
    else
    {
        self.cancelEvent.hidden = true;
        self.cancelEvent.enabled = false;
    }
    
    
}

- (IBAction)buttonUsersDeclinedOnClick:(id)sender
{
    [self.delegate didClickOnDeclinedButton:self];
}

- (IBAction)buttonUsersAcceptedOnClick:(id)sender
{
    [self.delegate didClickOnAcceptedButton:self];
}

- (IBAction)buttonMapOnClick:(id)sender
{
    [self.delegate didClickOnMapButton:self];
}

- (IBAction)buttonAddToCalendarOnClick:(id)sender
{
    [self.delegate didClickOnAddToCalendarButton:self];
}

- (IBAction)cancelEvent:(id)sender
{
    [self.delegate didClickOnCancelEvent:self];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
