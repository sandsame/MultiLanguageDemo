//
//  UITableViewCell+WeakReferenceTask.m
//  yxx_ios
//
//  Created by victor siu on 17/3/23.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UITableViewCell+WeakReferenceTask.h"
#import <objc/runtime.h>

static char deallocTaskKey;
static char WeakReferenceTaskKey;

@implementation UITableViewCell (WeakReferenceTask)


-(void)setWeakReferenceTask:(taskBlock)weakReferenceTask
{
    objc_setAssociatedObject(self, &WeakReferenceTaskKey, weakReferenceTask, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(taskBlock)weakReferenceTask
{
    return objc_getAssociatedObject(self, &WeakReferenceTaskKey);
}

-(void)setDeallocTask:(taskBlock)deallocTask
{
    objc_setAssociatedObject(self, &deallocTask, deallocTask, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(taskBlock)deallocTask
{
    return objc_getAssociatedObject(self, &deallocTaskKey);
}


-(void)dealloc
{
    if (self.weakReferenceTask) {
        self.weakReferenceTask();
    }
    if (self.deallocTask) {
        self.deallocTask();
    }
}

@end
