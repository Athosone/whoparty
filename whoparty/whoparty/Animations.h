//
//  Animations.h
//  Wineot
//
//  Created by Werck Ayrton on 21/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/POP.h>
#import <UIKit/UIKit.h>

@interface Animations : NSObject

+ (void) addMaskExpandleRectAnimation:(UIView*)destView duration:(float)duration;
+ (void) addShakingAnimation:(UIView*)destView;

@end
