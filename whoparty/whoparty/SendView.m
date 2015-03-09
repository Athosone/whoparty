//
//  SendView.m
//  whoparty
//
//  Created by Werck Ayrton on 08/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPHelperConstant.h"
#import "SendView.h"
#import "Animations.h"

@interface SendView ()

@property (strong, nonatomic) IBOutlet FUIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation SendView

- (id) init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SendView" owner:nil options:nil] objectAtIndex:0];
    return self;
}

- (void) initView
{
    [WPHelperConstant setBGColorForView:self color:[UIColor clearColor]];
    [WPHelperConstant setButtonToFlat:self.buttonSend];
    self.buttonSend.buttonColor = [UIColor orangeColor];
    self.buttonSend.shadowColor = [UIColor sunflowerColor];
    self.layer.cornerRadius = 6.0f;
    [self bringSubviewToFront:self.activityIndicator];
   // self.hidden = true;
}

- (void) fadeIn
{
    self.hidden = false;
    [Animations addFadeInTransitionToView:self duration:0.8f];
}

- (void) fadeOut
{
    [Animations addFadeOutTransitionToView:self duration:0.8f];
    //self.hidden = true;
}

- (void) startAi
{
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
}

- (void) stopAi
{
    self.activityIndicator.hidden = true;
    [self.activityIndicator stopAnimating];
}

- (IBAction)sendButtonOnClick:(id)sender
{
    [self.delegate didClickOnSendViewButton:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
