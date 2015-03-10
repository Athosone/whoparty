//
//  MenuSubView.m
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "MenuSubView.h"
#import "Animations.h"

@interface MenuSubView ()

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelMenuSub;

@end

@implementation MenuSubView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _labelTitle =  [[UILabel alloc] initWithFrame:self.labelMenuSub.frame];
    
    //self.buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
}


- (void) setLabelTitle:(NSString*)labelTitle
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self layoutIfNeeded];
    
    [super setSelected:selected animated:animated];
        [Animations addRubberBandAnimation:self.labelMenuSub rightView:_labelTitle receivingView:self completed:^(BOOL completed) {
        }];
}

@end
