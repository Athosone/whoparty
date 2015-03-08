//
//  CheckBoxTableViewCell.m
//  whoparty
//
//  Created by Werck Ayrton on 08/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "CheckBoxTableViewCell.h"
#import "Animations.h"

@interface CheckBoxTableViewCell ()


@property (strong, nonatomic) IBOutlet UIButton *buttonSelect;

@end

@implementation CheckBoxTableViewCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        self.buttonSelect.imageView.image = [UIImage imageNamed:@"validFriend"];
        [Animations addFadeInTransitionToView:self.buttonSelect duration:1.0f];
    }
    else
    {
        self.buttonSelect.imageView.image = [UIImage imageNamed:@"plusFriend"];
        [Animations addFadeInTransitionToView:self.buttonSelect duration:1.0f];
    }
}

@end
