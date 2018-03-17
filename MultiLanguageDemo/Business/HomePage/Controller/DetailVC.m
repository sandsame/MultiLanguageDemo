//
//  DetailVC.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()
@property (nonatomic, strong) UIWebView *myWebView;
@end

@implementation DetailVC

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

#pragma mark -- lazy load

- (UIWebView *)myWebView {
    if (_myWebView == nil) {
        _myWebView = [[UIWebView alloc] init];
    }
    return _myWebView;
}


#pragma mark --- other

- (void)setUpChildView {
    self.view.backgroundColor = WhiteColorOne;
    self.navigationItem.title = @"文章详情";
    [self.view addSubview:self.myWebView];
}

- (void)setDefaultLayout {
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)getData {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"detail"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:self.myModel.currentId block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
            NSLog(@"error:%@",error);
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *playerName = [object objectForKey:@"content"];
                [_myWebView loadHTMLString:playerName baseURL:nil];
            }
        }
    }];
}

@end
