//
//  HomePageVC.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/15.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HomePageVC.h"
#import "ZSZTableView.h"
#import "HPListModel.h"
#import "HPListCell.h"
#import "UIImageView+WebCache.h"
#import "DetailVC.h"
@interface HomePageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ZSZTableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpChildView];
    [self setDefaultLayout];
//    [self getData];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.myTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy laod
- (ZSZTableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[ZSZTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.placeHolderView.myImageView.image = [UIImage imageNamed:@"网络刷新失败"];
        NSString *net_failure =  NSLocalizedString(@"net_failure", nil);
        _myTableView.placeHolderView.myLabel.text = net_failure;
    }
    return _myTableView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:2];
    }
    return _dataSource;
}

#pragma mark --- action


#pragma mark --- other
- (void)setUpChildView {
    self.view.backgroundColor = GreenSpecialColor;
    [self.view addSubview:self.myTableView];
    self.navigationItem.title = @"精彩文章";
}

- (void)setDefaultLayout {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)getData {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"first_list"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
        if (error) {
            NSLog(@"first_list.error : %@",error);
        }else{
            self.dataSource = [NSMutableArray arrayWithArray:[HPListModel modelArrayFromJsonArray:array]];
            [self.myTableView reloadData];
        }
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
    return (SCREEN_WIDTH/3/16*9+20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CellID";
    HPListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[HPListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    HPListModel *model = self.dataSource[indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    cell.topLab.text = model.title;
    cell.bottomLab.text = model.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HPListModel *model = self.dataSource[indexPath.row];
    DetailVC *detailVC = [[DetailVC alloc] init];
    detailVC.myModel = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


@end
