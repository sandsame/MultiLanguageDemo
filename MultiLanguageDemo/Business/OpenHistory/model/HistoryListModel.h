//
//  HistoryListModel.h
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryListModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *expect;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *openCode;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSMutableArray *numberArray;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)modelArrayFromJsonArray:(NSArray *)jsonArray;
@end
