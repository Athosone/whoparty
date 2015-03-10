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
+ (void) addFadeInTransitionToView:(UIView*)destView duration:(float)duration;
+ (void) addFadeOutTransitionToView:(UIView*) destView duration:(float)duration;
+ (void) addFadeOutFadeInTransitionToView:(UIView*) destView duration:(float)duration;
+ (void) addVerticalShaking:(UIView*) destView;
+ (void) addRubberBandAnimation:(UIView*)leftView rightView:(UIView*)rightView receivingView:(UIView*)mainView completed:(void(^)(BOOL completed))completed;
+ (CABasicAnimation*) slideAnimationOnX:(CGPoint)start end:(CGPoint)end;

@end
