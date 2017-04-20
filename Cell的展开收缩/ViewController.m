//
//  ViewController.m
//  Cell的展开收缩
//
//  Created by 史练练 on 2017/4/14.
//  Copyright © 2017年 史练练. All rights reserved.
//

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{

}

@property (nonatomic, strong) UITableView *scaleTable;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *sectionArr;//分组的名字

/**
 记录每个section的打开状态
 */
@property (nonatomic, strong) NSMutableDictionary *isOpenFlagDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _isOpenFlagDic = [NSMutableDictionary dictionary];
    
    self.dataArr = @[@[@"1"],@[@"1",@"2"],@[@"1",@"2",@"3"],@[@"1",@"2",@"3",@"4"]];
    self.sectionArr = @[@"第一组",@"第二组",@"第三组",@"第四组"];
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        
        [self.isOpenFlagDic setObject:@"close" forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    
    [self creatTable];
}

- (void)creatTable {

    _scaleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)
                                               style:UITableViewStylePlain];
    _scaleTable.delegate = self;
    _scaleTable.dataSource = self;
    
    [self.view addSubview:self.scaleTable];
    [self.scaleTable reloadData];
}

#pragma  mark - 控制展开 伸缩逻辑
- (void)tapTaget:(UIGestureRecognizer *)sender{
    
    
    NSString *str = [NSString stringWithFormat:@"%ld",sender.view.tag - 100];
   
    if ([[self.isOpenFlagDic objectForKey:str] isEqualToString:@"close"] ) {
        
        [self.isOpenFlagDic setObject:@"open" forKey:str];
    }else{
        [self.isOpenFlagDic setObject:@"close" forKey:str];
    }
    
    [self.scaleTable reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]]
                   withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新

}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    sectionHead.backgroundColor = [UIColor cyanColor];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sectionHead.frame.size.width, sectionHead.frame.size.height)];
    titleLab.text = self.sectionArr[section];
    titleLab.textColor = [UIColor blackColor];
    titleLab.userInteractionEnabled = true;
    
    [sectionHead addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapTaget:)]];
    
    sectionHead.tag = section + 100;   // 确定点击的分组tag
    [sectionHead addSubview:titleLab];
    return sectionHead;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 利用每个分组的是否打开标志选择数据源
    NSString *str = [NSString stringWithFormat:@"%ld",section];
    if ([[self.isOpenFlagDic objectForKey:str] isEqualToString:@"close"] ) {
        return 0;
    }
    NSArray *array = [NSArray arrayWithArray:self.dataArr[section]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Identifer"];
    
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
