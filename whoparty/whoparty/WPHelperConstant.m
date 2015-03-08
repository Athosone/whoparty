//
//  WPHelperConstant.m
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//


#import "WPHelperConstant.h"

#import <FlatUIKit/FlatUIKit.h>

@implementation WPHelperConstant

+ (void) setBGColorForView:(UIView*)view color:(UIColor*)color
{
    if (color)
        view.backgroundColor = color;
    else
        view.backgroundColor = DEFAULTBGCOLOR;
}

+ (void) setButtonToFlat:(FUIButton*)destButton
{
    FUIButton *button = destButton;
    
    button.buttonColor = DEFAULTBUTTONCOLOR;
    button.shadowColor = DEFAULTSHADOWBUTTONCOLOR;
    
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    destButton = button;
}

+ (void) configureCellImageView:(UITableViewCell*)cell
{
    cell.imageView.layer.cornerRadius = 6.0f;
}

+ (void) saveUserCredentialsToKeyChain:(NSString*)login password:(NSString*)password
{
    //KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];

}

+ (NSDate*)formatDateFromString:(NSString*) dateString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    dateFormater.dateFormat = @"yyy-mm-dd";
    NSString *subString = [[dateString componentsSeparatedByString:@"T"] firstObject];
    
    NSDate *lRet = [dateFormater dateFromString:subString];
    return lRet;
}

+ (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    dateFormater.dateFormat = @"dd/MM";
    NSString *lRet = [dateFormater stringFromDate:date];
    return lRet;
}


@end
