//
//  OpenHistoryCell.h
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryListModel.h"
@interface OpenHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UICollectionView *numberCollectionView;
@property (nonatomic, strong) NSArray *collectDataSource;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *tailImgView;
@property (nonatomic, strong) HistoryListModel *currentModel;
@end
