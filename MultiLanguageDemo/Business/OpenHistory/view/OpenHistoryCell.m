//
//  OpenHistoryCell.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "OpenHistoryCell.h"
#import "HisNumberCell.h"
#define Space 6
#define CollectionCellWidth ((SCREEN_WIDTH - (9* Space)-70)/8)
#define SymbolCellID @"SymbolCellID"
@interface OpenHistoryCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@end

@implementation OpenHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(8);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(8);
        make.centerY.equalTo(self.titleLab.mas_centerY).offset(0);
    }];
    
    [self.tailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(20);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
    }];
    
    [self.numberCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        make.right.equalTo(self.tailImgView.mas_left).offset(-8);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark --- lazy load
- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = WhiteColorSix;
        _titleLab.font = FONT(18);
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}
- (UILabel *)timeLab {
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = WhiteColorFour;
        _timeLab.font = FONT(16);
        _timeLab.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLab;
}

- (UICollectionView *)numberCollectionView {
    if (_numberCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 8;
        layout.minimumLineSpacing = 5;
        layout.itemSize = CGSizeMake(CollectionCellWidth, CollectionCellWidth);
        _numberCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _numberCollectionView.backgroundColor = WhiteColorOne;
        _numberCollectionView.delegate = self;
        _numberCollectionView.dataSource = self;
        _numberCollectionView.showsVerticalScrollIndicator = NO;
        _numberCollectionView.showsHorizontalScrollIndicator = NO;
        [_numberCollectionView registerClass:[HisNumberCell class] forCellWithReuseIdentifier:SymbolCellID];
        _numberCollectionView.userInteractionEnabled = NO;
    }
    return _numberCollectionView;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = WhiteColorThree;
    }
    return _line;
}

- (UIImageView *)tailImgView {
    if (_tailImgView == nil) {
        _tailImgView = [[UIImageView alloc] init];
        _tailImgView.contentMode = UIViewContentModeScaleAspectFit;
        _tailImgView.image = [UIImage imageNamed:@"更多"];
    }
    return _tailImgView;
}

#pragma mark --- action


#pragma mark --- other
- (void)setUpChildView {
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.numberCollectionView];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.tailImgView];
    
}
#pragma mark --- UICollectionViewDelegate dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.collectDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HisNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SymbolCellID forIndexPath:indexPath];
    
    cell.numberLab.text = self.collectDataSource[indexPath.row];
    
    if ([self.currentModel.code isEqualToString:@"ssq"]) {
        if (indexPath.row == 6) {
            cell.numberLab.backgroundColor = BlueSpecialColor;
        }
    }else if ([self.currentModel.code isEqualToString:@"dlt"]) {
        if (indexPath.row == 4 || indexPath.row == 5) {
            cell.numberLab.backgroundColor = BlueSpecialColor;
        }
    }else if ([self.currentModel.code isEqualToString:@"qlc"]) {
        if (indexPath.row == 7) {
            cell.numberLab.backgroundColor = BlueSpecialColor;
        }
    }else{
        cell.numberLab.backgroundColor = RedSpecialColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}


@end
