//
//  ViewController.m
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/5.
//  Copyright © 2018年 dasui. All rights reserved.
//
// MARK: - touches begin
/*
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
 {
 UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
 [btn setTitle:@"" forState:UIControlStateNormal];
 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 btn.backgroundColor = [UIColor whiteColor];
 //    [btn sizeToFit];
 [self.view addSubview:btn];
 _btn = btn;
 [btn mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(self.view).offset(100.f);
 make.leading.mas_equalTo(self.view).offset(100.f);
 }];
 [self.btn setTitle:@"dfjsa;jf" forState:UIControlStateNormal]; 
 [self.btn sizeToFit];
 }
 */

#import "ViewController.h"
#import "MarlTagFlowLayout.h"
#import "MarlTstingTagCell.h"

#import "MarlTableTagCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MarlTableTagCellDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** table data */
@property (nonatomic, strong) NSMutableArray *tableData;
/** 高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation ViewController

- (NSMutableArray *)tableData
{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
    }
    return _tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupRightNaviBarButton];
    
    [self createTableView];
}

- (void)setupRightNaviBarButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"数据++" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(actionIncreaseDataSource:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

// MARK: - 事件处理
- (void)actionIncreaseDataSource:(UIButton *)button
{
    NSArray *dataArray = [NSArray arrayWithObjects:@"Typhoon",@"Nabi",@"was",@"a",@"powerful",@"typhoon",@"that",@"struck",@"southwestern",@"Japan",@"in ",@"September",@"2005",@".",@"The",@"14th",@"named",@"storm",@"of",@"the",@"2005",@"Pacific",@"typhoon",@"season",@"Nabi",@"formed",@"on",@"August",@"29",@"to",@"the",@"east", @"Typhoon",@"Nabi", nil];
    
    [self.tableData addObject:dataArray];
    [self.tableView reloadData];
}

- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[MarlTableTagCell class] forCellReuseIdentifier:@"MarlTableTagCellID"];
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
}
// MARK: - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarlTableTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarlTableTagCellID"];
    cell.datasource = self.tableData[indexPath.row];
    cell.delegate = self;

    return cell;
}
- (void)cell:(MarlTableTagCell *)cell heightDidChanged:(CGFloat)height
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    NSLog(@"indexPath->row == %ld, indexPath == %@", indexPath.row, indexPath);
    self.cellHeight = height;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeight) {
        return self.cellHeight;
    }
    return UITableViewAutomaticDimension;
}

@end
