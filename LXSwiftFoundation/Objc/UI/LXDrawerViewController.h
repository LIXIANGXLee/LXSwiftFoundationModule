//
//  LXDrawerViewController.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/5/5.
//

#import <UIKit/UIKit.h>

typedef void(^LXDrawerBlock)(void);

@interface LXDrawerViewController : UIViewController

@property(nonatomic,copy)LXDrawerBlock drawerBlock;

/// 初始化方法
- (instancetype)initWithMainViewController:(UITabBarController *)mainViewController leftViewConreoller:(UIViewController *)leftViewController maxWidth:(CGFloat)maxWidth duration:(double)duration;

/// 打开抽屉
-(void)openDrawer;

/// 打开抽屉
-(void)closeDrawer;

/// 跳转目标控制器
-(void)switchViewController:(UIViewController *)vc;

/// 返回到左侧控制器
-(void)switchBackMainViewController;

@end
