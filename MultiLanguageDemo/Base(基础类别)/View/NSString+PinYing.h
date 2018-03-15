//
//  NSString+PinYing.h
//  yxx_ios
//
//  Created by 朱松泽 on 2017/10/12.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYing)
- (NSString *)transformToPinyin;
- (BOOL)isAllEngNumAndSpecialSign;
@end
