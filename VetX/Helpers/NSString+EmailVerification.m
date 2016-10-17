//
//  NSString+EmailVerification.m
//  VetX
//
//  Created by YulianMobile on 12/12/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "NSString+EmailVerification.h"

@implementation NSString (EmailVerification)

- (BOOL)validateEmail {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
