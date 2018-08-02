//
//  ViewController.m
//  cell的循环利用
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource>

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableView = [[UITableView alloc] init];  //用init方法创建的UITableView控件默认是plain样式
    tableView.frame = self.view.bounds;
    tableView.rowHeight = 70;  //设置cell的高度
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark ————— UITableViewDataSource —————
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

/**
 这个方法会被频繁地调用，因为每当有一个cell进入到用户的视野范围内系统就会调用这个方法；
 UITableViewCell循环利用的原理：程序运行以后，一开始会新建出现在用户视野范围内的那几个cell，然后用户滚动UITableView控件，滚出用户视野范围的cell会存放在缓存池中，新滚进用户视野范围的cell系统会优先根据标识符去往缓存池中寻找具有相同标识符的cell，如果找到了则会从缓存池中拿出来，更改相应的数据后重复利用，如果没有找到则会新创建cell。
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     1、设置重用标识：
     被static关键字修饰的局部变量只会初始化一次，在整个程序运行过程中，只有一份内存。
     */
    static NSString *ID = @"a";
    
    /**
     2、根据标识符去缓存池中寻找具有相同标识符的cell：
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    /**
     3、如果在缓存池中没有找到可重复利用的cell则新创建cell：
     */
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    /**
     4、重新设置数据：
     重新设置数据的代码必须要写在上面的3步骤的外面，因为上面的3步骤只会用到有限的几次，其他的都是重复利用缓存池里面的cell；
     int用%d，NSInteger用%zd。
     */
    cell.textLabel.text = [NSString stringWithFormat:@"test - %zd", indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
