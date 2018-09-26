

//
//  ZFViewController.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "ZFViewController.h"

@interface ZFViewController ()

@end

@implementation ZFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint p = [[touches anyObject] locationInView:self.view];
    self.point = p;
    
    [self back];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
