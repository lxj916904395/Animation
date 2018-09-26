//
//  TransitionManager.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "TransitionManager.h"

#import "AnimatedVerticalOpen.h"
#import "AnimatedCircleOpen.h"
#import "AnimatedTodaytop.h"

@interface TransitionManager()<UINavigationControllerDelegate>

@end

@implementation TransitionManager

+ (instancetype)shared{
    static TransitionManager *manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TransitionManager new];
    });
    return manager;
}


+ (void)transitionWithStyle:(TransitionStyle)style navi:(UINavigationController*)navi toVC:(NSString*)toVC{

    if (style == TransitionStyleSystem) {
        [self transitionWithSystem:navi toVC:toVC];
    }else{
        navi.delegate = [self shared];
        [self transitionWithVerticalOpentoVC:toVC];
    }
}

//系统转场
+ (void)transitionWithSystem:(UINavigationController*)navi toVC:(NSString*)toVC{
    CATransition *anim = [CATransition animation];
    anim.type = kCATransitionReveal;
    anim.subtype = kCATransitionFromBottom;
    anim.duration = .5;
    [navi.view.layer  addAnimation:anim forKey:nil];
    
    RouterOptions *options = [RouterOptions options];
    options.animated = NO;
    [JKRouter open:toVC options:options];
}


+ (void)transitionWithVerticalOpentoVC:(NSString*)toVC{
    [JKRouter open:toVC];
}


#pragma mark ***************** UINavigationControllerDelegate;
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if ( operation == UINavigationControllerOperationPush) {
        if ([toVC isKindOfClass:NSClassFromString(@"TransitionVerticalOpenVC")] ) {
            AnimatedVerticalOpen *custom = [AnimatedVerticalOpen new];
            custom.isPush = YES;
            return custom;
        } else if ([toVC isKindOfClass:NSClassFromString(@"TransitionCircleOpen")] ) {
            AnimatedCircleOpen *custom = [AnimatedCircleOpen new];
            custom.isPush = YES;
            return custom;
        }else if ([toVC isKindOfClass:NSClassFromString(@"TransitionodayTopVC")] ) {
            AnimatedTodaytop *custom = [AnimatedTodaytop new];
            custom.isPush = YES;
            return custom;
        }
    }
    else if (operation == UINavigationControllerOperationPop) {
       
        if ([fromVC isKindOfClass:NSClassFromString(@"TransitionVerticalOpenVC")] ) {
            AnimatedVerticalOpen *custom = [AnimatedVerticalOpen new];
            custom.isPush = NO;
            return custom;
        }else if ([fromVC isKindOfClass:NSClassFromString(@"TransitionCircleOpen")] ) {
            AnimatedCircleOpen *custom = [AnimatedCircleOpen new];
            custom.isPush = NO;
            return custom;
        }else if ([fromVC isKindOfClass:NSClassFromString(@"TransitionodayTopVC")] ) {
            AnimatedTodaytop *custom = [AnimatedTodaytop new];
            custom.isPush = NO;
            return custom;
        }
    }
    return nil;
}

@end
