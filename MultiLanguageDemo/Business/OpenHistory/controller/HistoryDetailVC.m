//
//  HistoryDetailVC.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HistoryDetailVC.h"
#import "ZSZTableView.h"
#import "HistoryListModel.h"
#import "OpenHistoryCell.h"
#define Space 6
#define CollectionCellWidth ((SCREEN_WIDTH - (9* Space)-70)/8)
@interface HistoryDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) ZSZTableView *myTableView;
@end

@implementation HistoryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpChildView];
    [self setDefaultLayout];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy load
- (ZSZTableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[ZSZTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
    }
    return _myTableView;
}


#pragma mark --- other
- (void)setUpChildView {
    self.view.backgroundColor = WhiteColorOne;
    self.navigationItem.title = self.currentModel.name;
    [self.view addSubview:self.myTableView];
}

- (void)setDefaultLayout {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)getData {
    NSString *path = @"http://route.showapi.com/44-2";
    NSDictionary *params = @{@"showapi_appid":@"59429",
                             @"showapi_sign":@"5a59b2416fbc4e0aa064013275330705",
                             @"showapi_timestamp":@"",
                             @"showapi_sign_method":@"md5",
                             @"showapi_res_gzip":@"0",
                             @"code":self.currentModel.code, //ssq fc3d dlt qlc pl3 pl5 qxc
                             @"count":@"20",
                             };
    [ZSZHttpsTools postWithPath:path params:params success:^(id responseObject) {
        NSLog(@"history Data:%@",responseObject);
        if ([responseObject[@"showapi_res_code"] intValue] == 0) {
            self.dataSource = [HistoryListModel modelArrayFromJsonArray:responseObject[@"showapi_res_body"][@"result"]];
            [self.myTableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"hisroty interface error:%@",error);
    }];
}

#pragma mark --- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(ZSZTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayView:tableView.placeHolderView ifShowForRowCount:self.dataSource.count];
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24+30+CollectionCellWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CellID";
    OpenHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[OpenHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    HistoryListModel *model = self.dataSource[indexPath.row];
    cell.titleLab.text = model.name;
    cell.timeLab.text = model.time;
    cell.collectDataSource = model.numberArray;
    cell.currentModel = model;
    [cell.numberCollectionView reloadData];
    cell.tailImgView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
