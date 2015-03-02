//
//  NSString+FormValidation.h
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(FormValidation)

- (BOOL) isValidEmail;
- (BOOL) isValidPassword;
- (BOOL) isValidName;

@end
