//
//  TransitionSystemVC2.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "TransitionSystemVC2.h"
#import "MenuView.h"

@interface TransitionSystemVC2 ()
@property (strong, nonatomic)  UIButton *jumpBtn;
@property(strong ,nonatomic) MenuView *menuView;

@end

@implementation TransitionSystemVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.jumpBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)jump:(id)sender {
    if (!_menuView){
        _menuView = [[MenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    if (!_menuView.superview) {
        [_menuView showInView:self.view];
    }
}

- (UIButton *)jumpBtn{
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _jumpBtn.frame = CGRectMake(150, 300, 50, 30);
        [_jumpBtn setTitle:@"菜单" forState:(UIControlStateNormal)];
        
        [_jumpBtn addTarget:self action:@selector(jump:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _jumpBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!_menuView.superview) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
