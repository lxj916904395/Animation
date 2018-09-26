//
//  ViewController1.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/6.
//

#import "TransitionSystemVC.h"
#import "TransitionSystemVC2.h"

/**
 复杂动画一般由多种动画组成，所以需要对其进行拆分
 
 例如点赞效果
 1.点击按钮图片改变，并放大或缩小
 2.选中状态存在粒子发射
 */

@interface TransitionSystemVC (){
    UIView *view1;
    UIView *view2;
    
    CGRect oldView1Frame;
    CGPoint oldViewCenter;
    CGFloat oldR1;
    CGFloat r1;
    
    CAShapeLayer *shapeLayer;
}

@property (strong, nonatomic)  UIButton *likeBtn;
@property (strong, nonatomic)  UIButton *jumpBtn;

@property(strong ,nonatomic) CAEmitterLayer *emitterLayer;//粒子发射层

@end

@implementation TransitionSystemVC
#pragma mark ***************** 页面名称
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.likeBtn];
    [self.view addSubview:self.jumpBtn];
    
    [self _initEmitterLayer];
    [self addCircle];

}

- (void)addCircle{
    view1 = [[UIView alloc] initWithFrame:CGRectMake(30, 600, 40, 40)];
    view1.backgroundColor = [UIColor redColor];
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 20;
    [self.view addSubview:view1];
    
    view2 = [[UIView alloc] initWithFrame:view1.frame];
    view2.backgroundColor = [UIColor redColor];
    view2.layer.masksToBounds = YES;
    view2.layer.cornerRadius = 20;
    [self.view addSubview:view2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view2.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"99";
    [view2 addSubview:label];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [view2 addGestureRecognizer:pan];
    
    oldView1Frame = view1.frame;
    oldViewCenter = view1.center;
    oldR1 = CGRectGetWidth(oldView1Frame)/2;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor redColor].CGColor;
}

#pragma mark ***************** 拖拽手势;
- (void)tap:(UITapGestureRecognizer*)ges{
    if (ges.state == UIGestureRecognizerStateChanged) {
        //view2的中心点随手势移动
        view2.center = [ges locationInView:self.view];
        
        if (r1<10) {
            view1.hidden = YES;
            [shapeLayer removeFromSuperlayer];
        }else{
            [self keyPath];
        }
        
    }else if (ges.state == UIGestureRecognizerStateCancelled ||
              ges.state == UIGestureRecognizerStateFailed ||
              ges.state == UIGestureRecognizerStateEnded){
        //手势结束、取消
        [shapeLayer removeFromSuperlayer];
        view1.hidden = YES;
        
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->view2.center = self->oldViewCenter;
        } completion:^(BOOL finished) {
            //恢复坐标
            view1.hidden = NO;
            r1 = oldView1Frame.size.width/2;
            view1.frame = oldView1Frame;
            view1.layer.cornerRadius = r1;
        }];
    }
}

- (void)keyPath{
    
    //求出两个view的中心点
    CGPoint centerP1 = view1.center;
    CGPoint centerP2 = view2.center;
    
    
    //计算中心点距离
    CGFloat dis = sqrtf((centerP1.x-centerP2.x)*(centerP1.x-centerP2.x)+(centerP1.y-centerP2.y)*(centerP1.y-centerP2.y));
    
    //半径
    CGFloat r2 = CGRectGetWidth(view2.frame)/2;
    r1 = CGRectGetWidth(oldView1Frame)/2 - dis/30;
    
    //计算正弦余弦
    CGFloat sin = (centerP2.x - centerP1.x) / dis;
    CGFloat cos = (centerP1.y - centerP2.y) / dis;
    
    //获取6个关键点坐标
    
    //A点坐标
    CGPoint pA = CGPointMake(centerP1.x-r1*cos, centerP1.y-r1*sin);
    
    //B点坐标
    CGPoint pB = CGPointMake(centerP1.x+r1*cos, centerP1.y+r1*sin);
    
    //C点坐标
    CGPoint pC = CGPointMake(centerP2.x+r2*cos, centerP2.y+r2*sin);
    
    //D点坐标
    CGPoint pD = CGPointMake(centerP2.x-r2*cos, centerP2.y-r2*sin);
    
    //O点坐标
    CGPoint pO = CGPointMake(pA.x+dis/2*sin+dis/20, pA.y-dis/2*cos);
    
    //P点坐标
    CGPoint pP = CGPointMake(pB.x+dis/2*sin-dis/20, pB.y-dis/2*cos);
    
    
    //根据点画贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pA];
    [path addQuadCurveToPoint:pD controlPoint:pO];
    [path addLineToPoint:pC];
    [path addQuadCurveToPoint:pB controlPoint:pP];
    [path closePath];
    
    //添加路径
    shapeLayer.path = path.CGPath;
    [self.view.layer insertSublayer:shapeLayer below:view2.layer];
    
    //重新设置坐标
    view1.center = oldViewCenter;
    view1.bounds = CGRectMake(0, 0, r1*2, r1*2);
    view1.layer.cornerRadius = r1;
}


#pragma mark ***************** 添加爆炸效果;
- (void)explosion{
    _emitterLayer = [CAEmitterLayer layer];
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.name = @"explosionCell";
    cell.lifetime = .7;
    cell.birthRate = 4000;
    cell.velocity = 50;//中间值
    cell.velocityRange = 15;//(50+-15)
    cell.scale = .03;
    cell.scaleRange = .02;
    cell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;
    
    //设置粒子系统大小，位置，方向
    _emitterLayer.name = @"explosionLayer";
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    _emitterLayer.emitterSize = CGSizeMake(25, 25);
    _emitterLayer.emitterCells = @[cell];
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds = NO;
    _emitterLayer.birthRate = 0;
    _emitterLayer.position = CGPointMake(CGRectGetWidth(_likeBtn.bounds)/2, CGRectGetHeight(_likeBtn.bounds)/2);
    
    [_likeBtn.layer addSublayer:_emitterLayer];
}

#pragma mark ***************** CAEmitterLayer
- (void)_initEmitterLayer{
    _emitterLayer = [CAEmitterLayer layer];
    
    //发射的粒子
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    //内容标识
    cell.name = @"firework";
    //粒子的内容
    cell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;
    //出生率，ji
    cell.birthRate = 4000;
    
    //粒子存在时间
    cell.lifetime = 0.7;
    //粒子存在时间波动范围，
    // >0,粒子存活的总时间 = cell.lifetime + cell.lifetimeRange
    // <0,粒子存活的总时间 = cell.lifetime - cell.lifetimeRange
    //    cell.lifetimeRange = .3;
    
    //发射速度
    cell.velocity = 50;
    cell.velocityRange = 15;
    
    //    cell.alphaSpeed = -0.4;
    cell.scale = .03;
    cell.scaleRange = .02;
    
    //    cell.emissionRange = M_PI * 2.0;
    
    
    _emitterLayer.masksToBounds = NO;
    
    //总的出生率 = cell.birthRate*_emitterLayer.birthRate
    _emitterLayer.birthRate = 0;
    
    //设置发射器的发射内容，可为多个
    _emitterLayer.emitterCells = @[cell];
    
    //渲染模式
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    
    //发射模式
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    
    //发射源形状
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    
    _emitterLayer.position  = CGPointMake(CGRectGetWidth(self.likeBtn.bounds)/2, CGRectGetHeight(self.likeBtn.bounds)/2);
    
    //发射源大小
    _emitterLayer.emitterSize = CGSizeMake(25, 25);
    
    
    [self.likeBtn.layer addSublayer:_emitterLayer];
}

#pragma mark ***************** Action

- (void)clickLike:(id)sender {
    self.likeBtn.selected = !self.likeBtn.selected;
    
    [self scaleAnim];
    
    if (self.likeBtn.selected) {
        _emitterLayer.birthRate = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.emitterLayer.birthRate = 0;
        });
    }
}


//按钮缩放动画
- (void)scaleAnim{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.scale";
    if (self.likeBtn.selected) {
        anim.duration = .5f;
        anim.values = @[@1.2,@1.5,@0.8,@1];
    }else{
        anim.duration = .3f;
        anim.values = @[@0.8,@0.5,@1];
    }
    
    [self.likeBtn.layer addAnimation:anim forKey:nil];
}

- (void)jump:(id)sender {
    CATransition *anim = [CATransition animation];
    anim.type = @"oglFlip";
    anim.subtype = kCATransitionFromBottom;
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    
    [JKRouter open:@"TransitionSystemVC2"];
}



- (void)back{
    CATransition *anim = [CATransition animation];
    anim.type = @"suckEffect";
    //    anim.subtype = kCATransitionFromBottom;
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    
    [super back];
}

#pragma mark ***************** lazy load
- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(150, 200, 30, 30);
        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:(UIControlStateNormal)];
        [_likeBtn setImage:[UIImage imageNamed:@"liked"] forState:(UIControlStateSelected)];

        [_likeBtn addTarget:self action:@selector(clickLike:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _likeBtn;
}

- (UIButton *)jumpBtn{
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _jumpBtn.frame = CGRectMake(150, 300, 50, 30);
        [_jumpBtn setTitle:@"跳转" forState:(UIControlStateNormal)];
        
        [_jumpBtn addTarget:self action:@selector(jump:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _jumpBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    if (!CGRectContainsPoint(view2.frame, point)) {
        [super touchesBegan:touches withEvent:event];
    }
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
