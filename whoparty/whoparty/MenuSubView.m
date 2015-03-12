//
//  MenuSubView.m
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "MenuSubView.h"
#import "Animations.h"
#import <FlatUIKit/FlatUIKit.h>
#import <NSString+Icons.h>
@interface MenuSubView ()

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelMenuSub;


@end

@implementation MenuSubView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    
    [_labelTitle setText:@"Logout"];
    _labelMenuSub.font = [UIFont iconFontWithSize:20.0f];
    _labelMenuSub.text = [NSString iconStringForEnum:FUIHeart];
    [self layoutIfNeeded];
    
    /*
     
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self layoutIfNeeded];
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        [Animations addRubberBandAnimation:self.labelMenuSub rightView:self.labelTitle receivingView:self.contentView completed:^(BOOL completed) {
            if (self.completionBlockAnim)
                self.completionBlockAnim();
            else
                NSLog(@"[Error]: MenuSubView no completionblockanim found");
        }];
    }
}

@end
