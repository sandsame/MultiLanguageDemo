//
//  UIGestureRecognizer+YZHState.m
//  yxx_ios
//
//  Created by yuan on 2017/4/8.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UIGestureRecognizer+YZHState.h"
#import <objc/runtime.h>

static void *ptr_UIGestureRecognizer_YZHState_key;

@implementation UIGestureRecognizer (YZHState)

-(void)setYZHState:(YZHUIGestureRecognizerState)YZHState
{
    objc_setAssociatedObject(self, ptr_UIGestureRecognizer_YZHState_key, @(YZHState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(YZHUIGestureRecognizerState)YZHState
{
    return [objc_getAssociatedObject(self, ptr_UIGestureRecognizer_YZHState_key) integerValue];
}

@end
