//
//  ViewController.m
//  cell的循环利用
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 系统先在缓存池中寻找带有特殊标识符的cell，如果没有找到的话可以通过以下的三种方式来创建新的cell：
 1、用代码的方式创建cell：
（1）创建原生的cell(UITableViewCell)：可以在cellForRowAtIndexPath方法中撰写创建新的原生cell的代码"cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];"，然后系统会根据特殊标识符来创建新的原生cell。如果不在此方法中撰写上述的代码的话则可以在视图控制器类中的viewDidLoad方法中撰写相关的注册代码"[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"a"];"，然后系统会根据注册的类和特殊标识符来创建新的原生cell，如此Demo所示；
 (2)创建自定义的cell(ZPTableViewCell)：和上述（1）中的相似，可以在自定义cell类中的cellWithTableView方法中撰写创建新的自定义cell的代码"cell = [[ZPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deal"];"，然后系统会根据特殊标识符来创建新的自定义cell。如果不在此方法中撰写上述的代码的话则可以在视图控制器类中的viewDidLoad方法中撰写相关的注册代码"[tableView registerClass:[ZPTableViewCell class] forCellReuseIdentifier:@"deal"];"，然后系统会根据注册的类和特殊标识符来创建新的自定义cell，如“用代码自定义等高的cell”Demo中所示。
 2、用xib文件的方式创建自定义cell：
 在相应的自定义cell类里面的cellWithTableView方法里面撰写加载自定义cell的xib文件的代码"cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPTableViewCell class]) owner:nil options:nil] lastObject];"，并且在自定义cell的xib文件中设置cell的特殊标识符(identifier)，然后系统会根据xib文件和特殊标识符来创建新的自定义cell。如果不在此方法中撰写加载自定义cell的xib文件的代码的话就要在视图控制器类中的viewDidLoad方法中撰写相关的注册代码"[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"deal"];"，并且也要在自定义cell的xib文件中设置cell的特殊标识符(identifier)，然后系统会根据注册的类和特殊标识符来创建新的自定义cell。如"ZPEqualHeightCustomizedCell_UITableViewController_xib"Demo所示。
 3、用storyboard文件的方式创建自定义cell：
 一般在storyboard文件中会有一个UITableViewController的子类视图控制器，要给这个视图控制器的tableView控件上的自定义cell设置特殊标识符(identifier)，然后在此视图控制器类中的cellForRowAtIndexPath方法中撰写相关的代码，如果系统在缓存池中找不到带有特殊标识符的自定义cell的话，就会到storyboard文件中去找，如果找到这个带有特殊标识符的自定义cell，就会根据这个cell而创建新的自定义cell。如"ZPEqualHeightCustomizedCell_UITableViewController_storyboard"Demo所示。
 */
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
    
    /**
     如果不在cellForRowAtIndexPath方法中撰写创建新的原生cell的代码的话，则应该在此方法中注册cell的类型并且绑定特殊标识符，从而系统会根据注册的类型和绑定的特殊标识符而创建新的原生cell；
     这种做法的缺点是只能创建默认样式的原生cell。
     */
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"a"];
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
     3、如果系统在缓存池中没有找到可重复利用的cell的话则可以在此方法中通过撰写下面的代码来创建新的原生cell或者不写下面的代码而在视图控制器类中的viewDidLoad方法中撰写相关注册的代码也可以成功创建新的原生cell。
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
