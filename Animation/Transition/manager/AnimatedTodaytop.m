//
//  AnimatedTodaytop.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "AnimatedTodaytop.h"

@implementation AnimatedTodaytop

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    if (self.isPush) {
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        toView.layer.transform = CATransform3DMakeTranslation(kScreenWidth,0,0);
    }else{
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        toView.layer.transform = CATransform3DMakeScale(0.95,0.95,1);
    }
    
    [UIView animateWithDuration:.5 animations:^{
        
        if (self.isPush) {
            fromView.layer.transform = CATransform3DMakeScale(0.95,0.95,1);
        }else{
            fromView.layer.transform = CATransform3DMakeTranslation(kScreenWidth,0,0);
        }
        toView.layer.transform = CATransform3DIdentity;

    } completion:^(BOOL finished){
        
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
        }
        fromView.layer.transform = CATransform3DIdentity;
    }];
}


@end
