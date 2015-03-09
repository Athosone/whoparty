//
//  AlertView.m
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+ (FUIAlertView*) getDefaultAlertVIew:(NSString*) title message:(NSString*)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil, nil];
    
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [UIColor clearColor];// colorWithAlphaComponent:0.0];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [Animations addVerticalShaking:alertView];
    return alertView;
}

@end
