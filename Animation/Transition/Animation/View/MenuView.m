//
//  MenuView.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/7.
//

#import "MenuView.h"
@interface MenuView()
{
    CGFloat _diff;
    CADisplayLink *_playLink;
    NSMutableArray<UIButton*> * _btns;
}
@property(strong ,nonatomic) UIView *helpView1;
@property(strong ,nonatomic) UIView *helpView2;
@property(assign ,nonatomic)  CGFloat screenWidth;
@property(assign ,nonatomic)  CGFloat screenHeight;

@end
@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiden)]];
        
        
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        _helpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _helpView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _screenHeight/2, 40, 40)];

        [self addSubview:_helpView1];
        [self addSubview:_helpView2];
        
        _btns = [NSMutableArray new];
        
        CGFloat height = 40;
        CGFloat offset = 20;
        CGFloat y = _screenHeight- 5*height-4*offset;
        
        for (int i = 0; i< 5 ; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:[NSString stringWithFormat:@"第%d个",i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            
            btn.frame = CGRectMake(50, y/2+i*height+i*offset, 100, height);
            btn.transform = CGAffineTransformMakeTranslation(-200, 0);
            [_btns addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}

#pragma mark ***************** Action;
- (void)hiden{
    [self removeFromSuperview];
    
    _helpView1.frame = CGRectMake(0, 0, 100, 40);
    _helpView2.frame = CGRectMake(0, _screenHeight/2, 40, 40);
    
    [_btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CGAffineTransformMakeTranslation(-200, 0);
    }];
}

- (void)showInView:(UIView*)view{
    if (!self.superview) {
        [view addSubview:self];
    }
    
    [self startLink];
    
    CGFloat duration = .7;
    
    //通过两个辅助view，获取它们在弹性动画期间的x轴间距
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.helpView1.frame;
        rect.origin.x = self.screenWidth/2;
        self.helpView1.frame = rect;
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.6 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.helpView2.frame;
        rect.origin.x = self.screenWidth/2;
        self.helpView2.frame = rect;
    } completion:^(BOOL finished) {
        [self stopLink];
    }];
    
    
    [_btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //按钮弹性动画
        [UIView animateWithDuration:duration delay:duration/self->_btns.count *idx usingSpringWithDamping:.6 initialSpringVelocity:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            obj.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)getDiff{
    //获取辅助view的间距
     _diff = _helpView1.layer.presentationLayer.position.x - _helpView2.layer.presentationLayer.position.x;
    [self setNeedsDisplay];
}

- (void)startLink{
    if (!_playLink) {
        _playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getDiff)];
        [_playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopLink{
    if (_playLink) {
        [_playLink invalidate];
    }
    _playLink =nil;
}

- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(_screenWidth/2, 0)];
    //添加控制点，
    [path addQuadCurveToPoint:CGPointMake(_screenWidth/2, _screenHeight) controlPoint:CGPointMake(_diff+_screenWidth/2, _screenHeight/2)];
    
    [path addLineToPoint:CGPointMake(0, _screenHeight)];
    [[UIColor blueColor] setFill];
    [[UIColor blueColor] setStroke];
    [path closePath];
    [path fill];
    
    //渲染路径
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextAddPath(context, path.CGPath);
    //渲染上下文(layer)
    CGContextStrokePath(context);
}


@end
