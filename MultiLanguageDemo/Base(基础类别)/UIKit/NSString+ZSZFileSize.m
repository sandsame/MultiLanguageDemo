//
//  NSString+ZSZFileSize.m
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/4.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import "NSString+ZSZFileSize.h"

@implementation NSString (ZSZFileSize)
- (unsigned long long)fileSize
{
    // 总大小
    unsigned long long size = 0;
    NSString *sizeText = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:self isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [self stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
            
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:self error:nil].fileSize;
    }
    return size;
}
@end
