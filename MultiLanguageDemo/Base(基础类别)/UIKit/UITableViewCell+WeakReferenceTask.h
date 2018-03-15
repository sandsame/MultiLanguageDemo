//
//  UITableViewCell+WeakReferenceTask.h
//  yxx_ios
//
//  Created by victor siu on 17/3/23.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^taskBlock)();

@interface UITableViewCell (WeakReferenceTask)

//这里的blockTask对外部变量应用的时候一定要Weak
-(void)setWeakReferenceTask:(taskBlock)weakReferenceTask;

-(void)setDeallocTask:(taskBlock)deallocTask;

@end
