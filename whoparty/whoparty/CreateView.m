//
//  CreateView.m
//  whoparty
//
//  Created by Werck Ayrton on 16/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "CreateView.h"

@implementation UIView(Nib)

+ (UIView *)viewFromNib:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (!nibName || [nibName length] == 0) {
        return nil;
    }
    
    UIView *view = nil;
    
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    // I assume, that there is only one root view in interface file
    NSArray *loadedObjects = [bundle loadNibNamed:nibName owner:nil options:nil];
    view = [loadedObjects lastObject];
    
    return view;
}

@end
