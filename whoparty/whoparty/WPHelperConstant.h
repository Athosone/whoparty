//
//  WPHelperConstant.h
//  whoparty
//
//  Created by Werck Ayrton on 02/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>

#define HASRECEIVEDPUSHNOTIFICATION @"hasReceivedPushNotification"
#define HASRECEIVEDISACCEPTEDNOTFICATION @"hasReceivedAcceptedPushNotification"


#define GOOGLEIOSAPIKEY @"AIzaSyCNIJkpFx2qDZ1tjVaFx9o43e6BiMBmRso"
#define GOOGLESERVERAPIKEY @"AIzaSyCj7kLbvwLb1gj56mxrIiBjPRcwEkd-aLI"
#define CHANNELUSERPREFIX  @"whoParty_"
#define UIColorFromRGB(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define DEFAULTBGCOLOR UIColorFromRGB(0x34495E, 1)

#define DEFAULTBUTTONCOLOR UIColorFromRGB(0xC0392B, 1)
#define DEFAULTSHADOWBUTTONCOLOR UIColorFromRGB(0xE74C3C, 1)

#define DEFAULTNAVBARBGCOLOR UIColorFromRGB(0xC0392B, 1)
#define DEFAULTNAVBARITEMBGCOLOR UIColorFromRGB(0x2C3E50, 1)

#define DEFAULTACCEPTCOLOR UIColorFromRGB(0x2ECC71,1)
#define DEFAULTDECLINECOLOR UIColorFromRGB(0xE74C3C,1)

#define DEFAULTPROGRESSHUDCOLOR UIColorFromRGB(0x2C3E50, 1)

@interface WPHelperConstant : NSObject

+ (void) setBGColorForView:(UIView*)view color:(UIColor*)color;
+ (void) setButtonToFlat:(FUIButton*)button;
+ (void) saveUserCredentialsToKeyChain:(NSString*)login password:(NSString*)password;
+ (NSDate*)formatDateFromString:(NSString*) dateString;
+ (NSString*)dateToString:(NSDate*)date;
@end
