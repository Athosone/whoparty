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
#import "ManagedParseUser.h"

@interface ListEventCell ()

@property (strong, nonatomic) IBOutlet UILabel *usernameSender;
@property (strong, nonatomic) IBOutlet UILabel *labelDateOfEvent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSenderPicture;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UILabel *labelNameEvent;

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
    self.imageViewSenderPicture.layer.cornerRadius = self.imageViewSenderPicture.frame.size.width / 2;
    self.imageViewSenderPicture.layer.masksToBounds = YES;
    self.labelNameEvent.layer.cornerRadius = 6.0f;
}

- (void) initWithEvent:(PFObject*) event
{
    self.event = event;
    self.imageViewSenderPicture.image = [UIImage imageNamed:@"noav.png"];
    //PFObject *address =  event[@"mygoogleaddress"];
    NSDate          *date = event[@"eventdate"];
    
    if ([self.event objectForKey:@"name"])
    {
        self.labelNameEvent.text = self.event[@"name"];
    }
    
    self.usernameSender.text = (NSString*)self.event[@"sendinguser"];
    self.labelDateOfEvent.text = [WPHelperConstant dateToString:date];
    self.labelComment.text = self.event[@"comment"];
    [ManagedParseUser userWithUserName:event[@"sendinguser"] completionBlock:^(PFObject *user)
     {
        if (user && [user objectForKey:@"profilePictureFile"])
        {
            PFFile *picture = user[@"profilePictureFile"];
            [picture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data)
                    self.imageViewSenderPicture.image = [UIImage imageWithData:data];
                else
                    NSLog(@"No data for profilePictureFile");
            }];
        }
    }];
}

- (IBAction)displayEventButonOnClick:(id)sender
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
