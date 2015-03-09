//
//  AlertView.h
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FlatUIKit/FlatUIKit.h>
#import "Animations.h"

@interface AlertView : NSObject

+ (FUIAlertView*) getDefaultAlertVIew:(NSString*) title message:(NSString*)message;

@end
