//
//  NSString+FormValidation.m
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "NSString+FormValidation.h"

#define PASSWORDLENGTH  5
#define NAMELENGTH      5

@implementation NSString(FormValidation)

- (BOOL) isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailPredicate evaluateWithObject:self];
}

- (BOOL)isValidName
{
    return self.length >= NAMELENGTH;
}

- (BOOL)isValidPassword
{
    return self.length >= PASSWORDLENGTH;
}

@end
