//
//  NSString+PinYing.m
//  yxx_ios
//
//  Created by 朱松泽 on 2017/10/12.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "NSString+PinYing.h"

@implementation NSString (PinYing)
- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    BOOL isNeedTransform = ![self isAllEngNumAndSpecialSign];
    if (isNeedTransform) {
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        //kCFStringTransformStripCombiningMarks 可以变换来去除变音符和重音
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, false);
    }
    return mutableString;
}

- (BOOL)isAllEngNumAndSpecialSign {
    NSString *regularString = @"^[A-Za-z0-9\\p{Z}\\p{P}]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularString];
    return [predicate evaluateWithObject:self];
}

@end
