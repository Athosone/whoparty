//
//  Animations.m
//  Wineot
//
//  Created by Werck Ayrton on 21/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "Animations.h"

@implementation Animations


+ (void) addMaskExpandleRectAnimationFromTop:(UIView*)destView duration:(float)duration
{
    CAShapeLayer *rect = [CAShapeLayer layer];
    CGRect frame = CGRectMake(0, 0,destView.frame.size.width, 1);
    
    CGRect newFrame = CGRectMake(0, 0,destView.frame.size.width, destView.frame.size.height);
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:newFrame];
    
    rect.frame = frame;
    rect.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    rect.position = destView.center;
    rect.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    rect.strokeColor = [UIColor redColor].CGColor;
    //0 for top
    rect.anchorPoint = CGPointMake(0.5, 0);
    
    CABasicAnimation *resizeLayer = [CABasicAnimation animationWithKeyPath:@"path"];
    [resizeLayer setFromValue:(id)rect.path];
    [resizeLayer setToValue:(id)newPath.CGPath];
    rect.path = newPath.CGPath;
    
    //1 for bottom
    CGPoint destPos = CGPointMake(destView.center.x, 1);
    CABasicAnimation    *adjustPos = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [adjustPos setFromValue:[NSValue valueWithCGPoint:rect.position]];
    [adjustPos setToValue:[NSValue valueWithCGPoint:destPos]];
    
    rect.position = destPos;
    
    CAAnimationGroup    *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.animations = [NSArray arrayWithObjects:resizeLayer, adjustPos, nil];
    animationGroup.duration = duration;
    animationGroup.fillMode =  kCAFillModeForwards;
    [rect addAnimation:animationGroup forKey:@"addMaskExpandleRectAnimation"];
    destView.layer.mask = rect;
}


+ (void) addMaskExpandleRectAnimation:(UIView*)destView duration:(float)duration
{
    CAShapeLayer *rect = [CAShapeLayer layer];
    CGRect frame = CGRectMake(0, 0,destView.frame.size.width, 1);
    
    CGRect newFrame = CGRectMake(0, 0,destView.frame.size.width, destView.frame.size.height);
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:newFrame];
    
    rect.frame = frame;
    rect.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    rect.position = destView.center;
    rect.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    rect.strokeColor = [UIColor redColor].CGColor;
    rect.anchorPoint = CGPointMake(0.5, 0.5);
    
    CABasicAnimation *resizeLayer = [CABasicAnimation animationWithKeyPath:@"path"];
    [resizeLayer setFromValue:(id)rect.path];
    [resizeLayer setToValue:(id)newPath.CGPath];
    rect.path = newPath.CGPath;
    
    
    CGPoint destPos = CGPointMake(destView.center.x, 0);
    CABasicAnimation    *adjustPos = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [adjustPos setFromValue:[NSValue valueWithCGPoint:rect.position]];
    [adjustPos setToValue:[NSValue valueWithCGPoint:destPos]];
    
    rect.position = destPos;
    
    CAAnimationGroup    *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.animations = [NSArray arrayWithObjects:resizeLayer, adjustPos, nil];
    animationGroup.duration = duration;
    animationGroup.fillMode =  kCAFillModeForwards;
    [rect addAnimation:animationGroup forKey:@"addMaskExpandleRectAnimation"];
    destView.layer.mask = rect;
}


+ (void) addShakingAnimation:(UIView*)destView
{
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    shake.springBounciness = 20;
    shake.velocity = @(2500);
    [destView.layer  pop_addAnimation:shake forKey:@"shakeView"];
}

+ (void) addVerticalShaking:(UIView*) destView
{
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    
    shake.springBounciness = 20;
    shake.velocity = @(1500);
    [destView.layer  pop_addAnimation:shake forKey:@"shakeViewVertically"];
}

+ (void) addFadeInTransitionToView:(UIView*)destView duration:(float)duration
{
    destView.layer.opacity = 0.0f;
    CABasicAnimation *fadein = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadein setFromValue:[NSNumber numberWithFloat:0.0f]];
    [fadein setToValue:[NSNumber numberWithFloat:1.0f]];
    fadein.duration = duration;
    fadein.fillMode = kCAFillModeForwards;
    [destView.layer addAnimation:fadein forKey:@"fadein"];
    destView.layer.opacity = 1.0f;
}

+ (void) addFadeOutTransitionToView:(UIView*) destView duration:(float)duration
{
    destView.layer.opacity = 1.0f;
    CABasicAnimation *fadeout = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeout setFromValue:[NSNumber numberWithFloat:1.0f]];
    [fadeout setToValue:[NSNumber numberWithFloat:0.0f]];
    fadeout.duration = duration;
    fadeout.fillMode = kCAFillModeForwards;
    [destView.layer addAnimation:fadeout forKey:@"fadeout"];
    destView.layer.opacity = 0.0f;
}

+ (void) addFadeOutFadeInTransitionToView:(UIView*) destView duration:(float)duration
{
    destView.layer.opacity = 1.0f;
    CABasicAnimation *fadeout = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeout setFromValue:[NSNumber numberWithFloat:1.0f]];
    [fadeout setToValue:[NSNumber numberWithFloat:0.0f]];
    destView.layer.opacity = 0.0f;
    
    CABasicAnimation *fadein = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadein setFromValue:[NSNumber numberWithFloat:0.0f]];
    [fadein setToValue:[NSNumber numberWithFloat:1.0f]];
    destView.layer.opacity = 1.0f;
    
    CAAnimationGroup    *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.animations = [NSArray arrayWithObjects:fadeout, fadein, nil];
    animationGroup.duration = duration;
    animationGroup.fillMode =  kCAFillModeForwards;
    [destView.layer addAnimation:animationGroup forKey:@"fadeinout"];
    
    
}

#pragma mark ->RubberbandAnimation

+ (CABasicAnimation*) getFadeAnimation:(float)start end:(float)end
{
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setFromValue:[NSNumber numberWithFloat:start]];
    [fade setToValue:[NSNumber numberWithFloat:end]];
    return fade;
}


+ (CABasicAnimation*) getSlideAnimationOnX:(CGPoint)start end:(CGPoint)end
{
    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    [slideAnimation setFromValue:[NSNumber numberWithFloat:start.x]];
    [slideAnimation setToValue:[NSNumber numberWithFloat:end.x]];
    return slideAnimation;
}

+ (CABasicAnimation*) getSlideAnimationOnY:(CGPoint)start end:(CGPoint)end
{
    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    
    [slideAnimation setFromValue:[NSNumber numberWithFloat:start.y]];
    [slideAnimation setToValue:[NSNumber numberWithFloat:end.y]];
    return slideAnimation;
}



+ (void) addRubberBandAnimation:(UIView*)leftView rightView:(UIView*)rightView receivingView:(UIView*)mainView completed:(void(^)(BOOL completed))completedBlock
{
    CGPoint leftViewCenter = leftView.layer.position;
    CGPoint rightViewCenter = rightView.layer.position;

    CGPoint slideRightViewPos = rightViewCenter;
    CGPoint slideLeftViewPos = leftViewCenter;
    
    slideRightViewPos.x += mainView.frame.size.height;
    slideLeftViewPos.x -= mainView.frame.size.height;
    
    [CATransaction begin];
    CABasicAnimation *slideLeftAnim = [Animations getSlideAnimationOnX:leftViewCenter end:slideLeftViewPos];
    CABasicAnimation *slideLeftAnimRightView = [Animations getSlideAnimationOnX:rightViewCenter end:slideRightViewPos];

    slideLeftAnim.duration = 0.5f;
    slideLeftAnim.fillMode = kCAFillModeForwards;
    slideLeftAnimRightView.duration = 0.5f;
    slideLeftAnimRightView.fillMode = kCAFillModeForwards;
    
    [CATransaction setCompletionBlock:^{
    [CATransaction begin];
        
        CABasicAnimation *slideReverseAnim = [Animations getSlideAnimationOnX:slideLeftViewPos end:leftViewCenter];
        CABasicAnimation *slideReverseAnimRightView = [Animations getSlideAnimationOnX:slideRightViewPos end:rightViewCenter];
        
        slideReverseAnim.duration = 0.5f;
        slideReverseAnim.fillMode = kCAFillModeForwards;
        slideReverseAnimRightView.duration = 0.5f;
        slideReverseAnimRightView.fillMode = kCAFillModeForwards;
        [CATransaction setCompletionBlock:^{
            completedBlock(YES);
        }];
        [leftView.layer addAnimation:slideReverseAnim forKey:@"slideleftanimereverse"];
        [rightView.layer addAnimation:slideReverseAnimRightView forKey:@"sliderightanimreverse"];
        leftView.layer.position = leftViewCenter;
        rightView.layer.position = rightViewCenter;
        [CATransaction commit];
    }];
    [leftView.layer addAnimation:slideLeftAnim forKey:@"slideleftanime"];
    [rightView.layer addAnimation:slideLeftAnimRightView forKey:@"sliderightanim"];
    leftView.layer.position = slideLeftViewPos;
    rightView.layer.position = slideRightViewPos;
    [CATransaction commit];
    
    /*  POPBasicAnimation *popAnimLeft = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
     
     popAnimLeft.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     popAnimLeft.fromValue = [NSNumber numberWithFloat:leftView.center.x];
     popAnimLeft.toValue = [NSNumber numberWithFloat:slideLeftView.x];
     [leftView pop_addAnimation:popAnimLeft forKey:@"test"];
     
     POPBasicAnimation *popAnimRight = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
     
     popAnimRight.fromValue = [NSNumber numberWithFloat:rightView.center.x];
     popAnimRight.toValue = [NSNumber numberWithFloat:rightView.center.x + 100];
     popAnimRight.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     [rightView pop_addAnimation:popAnimRight forKey:@"test2"];
     
     
     [popAnimRight setCompletionBlock:^(POPAnimation *popAnim, BOOL completed) {
     completedBlock(YES);
     }];
     */
    
    
}

#pragma mark Test Animations
- (void) test:(UIView*)destView
{
    /* CAKeyframeAnimation *keyAnimToRight = [CAKeyframeAnimation animation];
     
     keyAnimToRight.values = @[[NSNumber numberWithFloat:rightViewCenter.x], [NSNumber numberWithFloat:slideRightView.x], [NSNumber numberWithFloat:rightViewCenter.x]];
     keyAnimToRight.keyPath = @"position.x";
     keyAnimToRight.duration = 2.0f;
     
     //  [rightView.layer addAnimation:keyAnimToRight forKey:@"test"];
     
     
     CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
     
     keyAnim.values = @[[NSNumber numberWithFloat:leftViewCenter.x], [NSNumber numberWithFloat:slideLeftView.x], [NSNumber numberWithFloat:leftViewCenter.x]];
     keyAnim.keyPath = @"position.x";
     keyAnim.duration = 2.0f;
     //[leftView.layer addAnimation:keyAnim forKey:@"test"];
     //To the right
     */
    int radius = 100;
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGRect roundedRect = CGRectMake(0, 0, 2.0*radius, 2.0*radius);
    
    circle.path = [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:radius].CGPath;
    
    circle.position = CGPointMake(CGRectGetMidX(destView.frame) - radius, CGRectGetMidY(destView.frame) - radius);
    circle.fillColor = [UIColor blackColor].CGColor;
    circle.strokeColor = [UIColor redColor].CGColor;
    circle.lineWidth = 5;
    
    CABasicAnimation *drawCircle = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    drawCircle.duration = 5.0f;
    drawCircle.repeatCount = 1;
    drawCircle.fromValue = [NSNumber numberWithFloat:100.0f];
    drawCircle.toValue   = [NSNumber numberWithFloat:500.0f];
    
    drawCircle.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 3;
    
    [circle addAnimation:drawCircle forKey:@"testAnimation"];
    [circle addAnimation:animation forKey:@"grow"];
    
    
    
    CAShapeLayer *rect = [CAShapeLayer layer];
    CGRect frame = CGRectMake(0, 0,destView.frame.size.width, 1);
    
    CGRect newFrame = CGRectMake(0, 0,destView.frame.size.width, destView.frame.size.height);
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:newFrame];
    
    rect.frame = frame;
    rect.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    rect.position = destView.center;
    rect.backgroundColor = (__bridge CGColorRef)([UIColor colorWithWhite:0.0 alpha:0.5]);
    rect.strokeColor = [UIColor redColor].CGColor;
    rect.anchorPoint = CGPointMake(0.5, 0.5);
    
    CABasicAnimation *resizeLayer = [CABasicAnimation animationWithKeyPath:@"path"];
    [resizeLayer setFromValue:(id)rect.path];
    [resizeLayer setToValue:(id)newPath.CGPath];
    rect.path = newPath.CGPath;
    
    
    CGPoint destPos = CGPointMake(destView.center.x, 0);
    CABasicAnimation    *adjustPos = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [adjustPos setFromValue:[NSValue valueWithCGPoint:rect.position]];
    [adjustPos setToValue:[NSValue valueWithCGPoint:destPos]];
    
    rect.position = destPos;
    
    CAAnimationGroup    *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.animations = [NSArray arrayWithObjects:resizeLayer, adjustPos, nil];
    animationGroup.duration = 2.0f;
    animationGroup.fillMode =  kCAFillModeForwards;
    [rect addAnimation:resizeLayer forKey:@"resize"];
    //[rect addAnimation:animationGroup forKey:@"DrawRect"];
    destView.layer.mask = rect;
    //[destView.layer addSublayer:rect];
}


@end
