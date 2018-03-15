//
//  UIColor+colorToImage.m
//  sdxt
//
//  Created by 朱松泽 on 2017/11/13.
//  Copyright © 2017年 com.gdtech. All rights reserved.
//

#import "UIColor+colorToImage.h"

@implementation UIColor (colorToImage)
+ (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
