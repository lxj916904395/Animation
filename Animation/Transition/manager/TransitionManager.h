//
//  TransitionManager.h
//  Animation
//
//  Created by zhongding on 2018/9/26.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TransitionStyle){
    TransitionStyleSystem,
    TransitionStyleVerticalOpen,//垂直打开
    TransitionStyleCircleOpen,//任一点圆弧打开
    TransitionStyleTodaytopOpen,//今日头条打开

};


@interface TransitionManager : NSObject

+ (instancetype)shared;

+ (void)transitionWithStyle:(TransitionStyle)style navi:(UINavigationController*)navi toVC:(NSString*)toVC;


@end

