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
#import "MYGoogleAddress.h"
#import "Animations.h"

@interface ListEventCell ()

@property (strong, nonatomic) IBOutlet UILabel *usernameSender;
@property (strong, nonatomic) IBOutlet UILabel *labelDateOfEvent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSenderPicture;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;

@end

//IDEA
//Pour la container view autant mettre la frame a zero et l'augmenté au fur et a
//mesure que la cell augmente ca taille && use mask layer

@implementation ListEventCell

- (void)setLoading:(BOOL)loading
{
    if (loading != _loading) {
        _loading = loading;
    }
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated
{
    if (expansionStyle != _expansionStyle) {
        _expansionStyle = expansionStyle;
    }
}




- (NSString*) reuseIdentifier
{
    return @"ListEventCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void) initWithEvent:(PFObject*) event
{
    self.event = event;
    
    //PFObject *address =  event[@"mygoogleaddress"];
    NSDate          *date = event[@"eventdate"];
    
    self.usernameSender.text = (NSString*)self.event[@"sendinguser"];
    self.labelDateOfEvent.text = [WPHelperConstant dateToString:date];
    self.labelComment.text = self.event[@"comment"];
    [WPHelperConstant setBlurForCell:self];
}

- (IBAction)displayEventButonOnClick:(id)sender
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
