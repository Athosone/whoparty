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

+ (void) setBGWithImageForView:(UIView*)view image:(NSString*)imageName
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

+ (void) setImageAsBGForTableView:(UITableView*)view image:(UIImage*) image
{
    UIImageView *imageBG = [[UIImageView alloc] initWithFrame:view.frame];
    
    imageBG.contentMode = UIViewContentModeScaleAspectFill;
    imageBG.image = image;
    view.backgroundView = imageBG;
}

+ (void) setBlurForCell:(UITableViewCell*)cell
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
   
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = blurEffectView;
    NSLog(@"cellframe: %f %f, backgroundview: %f %f, blureffectview: %f,%f", cell.frame.size.width, cell.frame.size.height, cell.backgroundView.frame.size.width, cell.backgroundView.frame.size.height, blurEffectView.frame.size.width, blurEffectView.frame.size.height);
}

+ (void) setBlurForView:(UIView*)view
{
    view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    
    [view addSubview:blurEffectView];
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

+ (NSString*) getDateStringFromDate:(NSDate*)date
{
    NSString *lRet = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMM"];
    NSLog(@"Date test: %@", [dateFormatter stringFromDate:date]);
    lRet = [dateFormatter stringFromDate:date];
    return lRet;
}

+ (NSDate*)formatDateFromString:(NSString*) dateString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    dateFormater.dateFormat = @"yyy-MM-dd";
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
