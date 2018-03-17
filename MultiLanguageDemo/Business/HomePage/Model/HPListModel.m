//
//  HPListModel.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/16.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HPListModel.h"

@implementation HPListModel
- (instancetype)initWithDictionary:(BmobObject *)object {
    if (self = [super init]) {
        self.currentId = [object objectForKey:@"newId"];
        self.title = [object objectForKey:@"title"];
        self.image = [object objectForKey:@"image"];
        self.subTitle = [object objectForKey:@"subTitle"];
    }
    return self;
}
+ (NSArray *)modelArrayFromJsonArray:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    
    for (BmobObject *obj in jsonArray) {
        HPListModel *model = [[HPListModel alloc] initWithDictionary:obj];
        [array addObject:model];
    }
    
    return [NSArray arrayWithArray:array];
}
@end
