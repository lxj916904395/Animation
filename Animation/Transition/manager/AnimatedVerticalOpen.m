//
//  AnimatedHorizontalOpen.m
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import "AnimatedVerticalOpen.h"

static UIImageView*imgView0;
static UIImageView*imgView1;

@implementation AnimatedVerticalOpen

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    
    CGFloat screenHeight = CGRectGetHeight(fromVC.view.frame);
    CGFloat screenWidth = CGRectGetWidth(fromVC.view.frame);
    
    // 把view 截取两部分，对截取的两部分做位移动画
    
    //上部分view
    if(!imgView0) {
        CGRect  rect0 = CGRectMake(0 , 0 , screenWidth, screenHeight/2);
        
        UIImage *image0 = [self imageFromView:fromVC.view atFrame:rect0];
        imgView0 = [[UIImageView alloc] initWithImage:image0];
    }
    
    //下部分view
    if (!imgView1) {
        CGRect  rect1 = CGRectMake(0 , screenHeight/2 , screenWidth, screenHeight/2);
        UIImage *image1 = [self imageFromView:fromVC.view atFrame:rect1];
        imgView1 = [[UIImageView alloc] initWithImage:image1];
    }
    
    [containView addSubview:fromVC.view];
    if(self.isPush)[containView addSubview:toVC.view];
    
    [containView addSubview:imgView0];
    [containView addSubview:imgView1];
    
    [UIView animateWithDuration:.5 animations:^{
        if (self.isPush) {
            //从中间往上移动
            imgView0.layer.transform = CATransform3DMakeTranslation(0, -screenHeight/2, 0);
            //从中间往下移动
            imgView1.layer.transform = CATransform3DMakeTranslation(0, screenHeight, 0);
        }else{
            //清除位移，恢复原状
            imgView0.layer.transform = CATransform3DIdentity;
            imgView1.layer.transform = CATransform3DIdentity;
        }
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
        }
        
        if (!toVC.view.superview) {
            [containView addSubview:toVC.view];
        }
        
        //动画完成移除
        [imgView0 removeFromSuperview];
        [imgView1 removeFromSuperview];
    }];
}

//根据范围截取view
- (UIImage *)imageFromView: (UIView *)view atFrame:(CGRect)rect{
    
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
}

@end
