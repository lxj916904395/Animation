//
//  UIViewController+transition.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "UIViewController+transition.h"

// 定义关联的key

static const char *key = "point";

@implementation UIViewController (transition)

- (CGPoint )point{
    
    // 根据关联的key，获取关联的值
    NSValue * value = objc_getAssociatedObject(self, key);
    
    return [value CGPointValue];
}

- (void)setPoint:(CGPoint)point{
    
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    
    objc_setAssociatedObject(self, key, [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




@end
