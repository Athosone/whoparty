//
//  CircleAnimation.m
//  Wineot
//
//  Created by Werck Ayrton on 18/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "CircleAnimation.h"

@interface CircleAnimation()

@property (weak) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CircleAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
       
    
}

@end
