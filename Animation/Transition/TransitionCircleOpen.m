//
//  TransitionCircleOpen.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "TransitionCircleOpen.h"

@interface TransitionCircleOpen ()

@end

@implementation TransitionCircleOpen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.point =  [[touches anyObject] locationInView:self.view];
    [super touchesEnded:touches withEvent:event];
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
