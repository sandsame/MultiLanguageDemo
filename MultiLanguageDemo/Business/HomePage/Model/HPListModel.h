//
//  HPListModel.h
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/16.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPListModel : NSObject
@property (nonatomic, strong) NSString *currentId;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
- (instancetype)initWithDictionary:(BmobObject *)object;
+ (NSArray *)modelArrayFromJsonArray:(NSArray *)jsonArray;
@end
