//
//  AnimatedTransitioning.h
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import <Foundation/Foundation.h>

@interface AnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property(assign ,nonatomic) BOOL isPush;
@property(assign ,nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@end

