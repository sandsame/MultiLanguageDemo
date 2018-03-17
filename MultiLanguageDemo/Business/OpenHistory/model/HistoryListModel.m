//
//  HistoryListModel.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HistoryListModel.h"

@implementation HistoryListModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        self.expect = [NSString stringWithFormat:@"%@",dict[@"expect"]];
        self.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.openCode = [NSString stringWithFormat:@"%@",dict[@"openCode"]];
        self.time = [NSString stringWithFormat:@"%@",dict[@"time"]];
        self.timestamp = [NSString stringWithFormat:@"%@",dict[@"timestamp"]];
        
        // 根据code分类得到数字数组
        if ([self.code isEqualToString:@"ssq"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@"+"];
            [self.numberArray addObject:firstArr.lastObject];
            if (firstArr.count == 2) {
                NSString *tempStr = firstArr.firstObject;
                NSArray *secondArr = [tempStr componentsSeparatedByString:@","];
                for (NSString *obj in secondArr) {
                    [self.numberArray addObject:obj];
                }
            }
            
        }else if ([self.code isEqualToString:@"fc3d"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@","];
            for (NSString *obj in firstArr) {
                [self.numberArray addObject:obj];
            }
            
        }else if ([self.code isEqualToString:@"dlt"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@"+"];
            if (firstArr.count == 2) {
                NSString *tempStr1 = firstArr.firstObject;
                NSString *tempStr2 = firstArr.lastObject;
                NSArray *tempArr1 = [tempStr1 componentsSeparatedByString:@","];
                NSArray *tempArr2 = [tempStr2 componentsSeparatedByString:@","];
                for (NSString *obj in tempArr1) {
                    [self.numberArray addObject:obj];
                }
                for (NSString *obj in tempArr2) {
                    [self.numberArray addObject:obj];
                }
            }
            
        }else if ([self.code isEqualToString:@"qlc"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@"+"];
            [self.numberArray addObject:firstArr.lastObject];
            if (firstArr.count == 2) {
                NSString *tempStr = firstArr.firstObject;
                NSArray *secondArr = [tempStr componentsSeparatedByString:@","];
                for (NSString *obj in secondArr) {
                    [self.numberArray addObject:obj];
                }
            }
            
        }else if ([self.code isEqualToString:@"pl3"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@","];
            for (NSString *obj in firstArr) {
                [self.numberArray addObject:obj];
            }
            
        }else if ([self.code isEqualToString:@"pl5"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@","];
            for (NSString *obj in firstArr) {
                [self.numberArray addObject:obj];
            }
            
        }else if ([self.code isEqualToString:@"qxc"]) {
            
            NSArray *firstArr = [self.openCode componentsSeparatedByString:@","];
            for (NSString *obj in firstArr) {
                [self.numberArray addObject:obj];
            }
            
        }
    }
    return self;
}
+ (NSArray *)modelArrayFromJsonArray:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    for (NSDictionary *dict in jsonArray) {
        HistoryListModel *model = [[HistoryListModel alloc] initWithDictionary:dict];
        [array addObject:model];
    }
    return [NSArray arrayWithArray:array];
}

- (NSMutableArray *)numberArray {
    if (_numberArray == nil) {
        _numberArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _numberArray;
}

@end
