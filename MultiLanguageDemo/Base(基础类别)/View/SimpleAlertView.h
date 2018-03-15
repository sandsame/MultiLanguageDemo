//
//  SimpleAlertView.h
//  yxx_ios
//
//  Created by wen on 16/9/28.
//  Copyright © 2016年 GDtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleAlertView : NSObject

+ (void)showAlert:(NSString *)messageString;
+ (void)showAlert:(NSString *)messageString withDuration:(NSTimeInterval)duration;

@end
