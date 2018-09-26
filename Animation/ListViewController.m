//
//  ViewController.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "ListViewController.h"


/**
 动画创建三步骤
 1.创建动画对象
 2.设置动画属性
 3.给layer添加动画
 */

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong ,nonatomic) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.array addObject:@"系统转场"];
    [self.array addObject:@"自定义转场1"];
    [self.array addObject:@"自定义转场2"];
    [self.array addObject:@"仿今日头条"];
}


#pragma mark ***************** Delegate;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [TransitionManager transitionWithStyle:(TransitionStyleSystem) navi:self.navigationController toVC:@"TransitionSystemVC"];
            break;
       
        case 1:
            [TransitionManager transitionWithStyle:(TransitionStyleVerticalOpen) navi:self.navigationController toVC:@"TransitionVerticalOpenVC"];

            break;
        case 2:{
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            CGPoint point = CGRectGetCenter(rect);
            self.point = point;            
            [TransitionManager transitionWithStyle:(TransitionStyleVerticalOpen) navi:self.navigationController toVC:@"TransitionCircleOpen"];

        }
            break;
            
        case 3:
            [TransitionManager transitionWithStyle:(TransitionStyleTodaytopOpen) navi:self.navigationController toVC:@"TransitionodayTopVC"];

            break;
            
        default:
            break;
    }
    
}



#pragma mark ***************** settet getter;

- (NSMutableArray*)array{
    if (!_array) {
        _array = [NSMutableArray new];
    }
    return _array;
}

@end
