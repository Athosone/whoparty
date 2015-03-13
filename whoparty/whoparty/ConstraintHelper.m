//
//  ConstraintHelper.m
//  whoparty
//
//  Created by Werck Ayrton on 14/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ConstraintHelper.h"


@implementation ConstraintHelper

+ (NSLayoutConstraint*) getAlignementXForView:(UIView *)view viewToCenter:(UIView *)viewToCenter
{
    NSLayoutConstraint *lRet = [NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:viewToCenter attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    return lRet;
}

@end
