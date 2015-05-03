//
//  CheckBoxTableViewCell.m
//  whoparty
//
//  Created by Werck Ayrton on 08/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "CheckBoxTableViewCell.h"
#import "Animations.h"

@interface WPCheckBoxTableViewCell ()


@property (strong, nonatomic) IBOutlet UIButton *buttonSelect;

@end

@implementation WPCheckBoxTableViewCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    //self.buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
}

- (NSString*) reuseIdentifier
{
    return @"checkBoxCell";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected)
    {
        UIImage *image = [UIImage imageNamed:@"validEvent"];
        [self.buttonSelect setImage:image forState:UIControlStateNormal];
        // self.buttonSelect.imageView.image = [UIImage imageNamed:@"validEvent"];
        [Animations addFadeInTransitionToView:self.buttonSelect duration:1.0f];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"plusEvent"];
        [self.buttonSelect setImage:image forState:UIControlStateNormal];
        [Animations addFadeInTransitionToView:self.buttonSelect duration:1.0f];
    }
}

@end
