//
//  SimpleAlertView.m
//  yxx_ios
//
//  Created by wen on 16/9/28.
//  Copyright © 2016年 GDtech. All rights reserved.
//

#import "SimpleAlertView.h"


@implementation SimpleAlertView

+ (void)showAlert:(NSString *)messageString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:messageString delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [[[self alloc] init] performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
    
}

+ (void)showAlert:(NSString *)messageString withDuration:(NSTimeInterval)duration {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:messageString delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [[[self alloc] init] performSelector:@selector(dimissAlert:) withObject:alert afterDelay:duration];
    
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

@end
