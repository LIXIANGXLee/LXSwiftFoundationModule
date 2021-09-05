//
//  LXDrawerViewController.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/5/5.
//

#import "LXDrawerViewController.h"
#import "UIView+LXObjcMargin.h"

#define maxOffSet 0.3

@interface LXDrawerViewController ()
@property(nonatomic,strong) UIViewController *lelfViewController;
@property(nonatomic,strong) UITabBarController *mainViewController;
@property(nonatomic,assign) CGFloat maxWidth;
@property(nonatomic,assign) double duration;

//打开抽屉后的遮盖层
@property(nonatomic,strong) UIButton *coverButton;
@property(nonatomic,assign) CGAffineTransform transformMain;
@property(nonatomic,assign) CGAffineTransform transformLeft;
@property(nonatomic,strong) UIViewController *currentViewController;

@end

@implementation LXDrawerViewController
   
- (instancetype)initWithMainViewController:(UITabBarController *)mainViewController leftViewConreoller:(UIViewController *)leftViewController maxWidth:(CGFloat)maxWidth duration:(double)duration {
    
    if (self = [super init]) {
        self.maxWidth = maxWidth;
        self.duration = duration;
        
        self.lelfViewController = leftViewController;
        self.mainViewController = mainViewController;
        self.transformMain = CGAffineTransformIdentity;
        self.transformLeft = CGAffineTransformIdentity;
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:leftViewController.view];
        [self addChildViewController:leftViewController];
        self.lelfViewController.view.lx_left = -self.maxWidth * maxOffSet;
        self.lelfViewController.view.lx_top = 0;
        self.lelfViewController.view.lx_width = maxWidth;
        self.lelfViewController.view.lx_height = [UIScreen mainScreen].bounds.size.height;
        
        [self.view addSubview:mainViewController.view];
        [self addChildViewController:mainViewController];
        [self.mainViewController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(screenVCViewGestureRecognizer:)];
            [obj.view addGestureRecognizer:panGesture];
        }];
    }
    return  self;
}

-(UIButton *)coverButton{
    if (!_coverButton) {
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _coverButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
        
        // 点击关闭
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawer)];
        [_coverButton addGestureRecognizer:tapGesture];
        
        // 滑动事件处理
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(screenCoverViewGestureRecognizer:)];
        [_coverButton addGestureRecognizer:panGesture];
    }
    return _coverButton;
}

/// 屏幕滑动处理
-(void)screenGestureRecognizer:(UIPanGestureRecognizer *)pan offsetX:(CGFloat)offsetX isCoverPan:(BOOL)isCoverPan {
    
    if (pan.state  == UIGestureRecognizerStateChanged && ABS(offsetX) < self.maxWidth) {
        self.mainViewController.view.transform = CGAffineTransformTranslate( self.transformMain, offsetX, 0);
        self.lelfViewController.view.transform = CGAffineTransformTranslate( self.transformLeft, maxOffSet * offsetX, 0);
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (ABS(offsetX) > [UIScreen mainScreen].bounds.size.width * 0.5) {
            (isCoverPan) ? [self closeDrawer] : [self openDrawer];
        }else{
            (isCoverPan) ? [self openDrawer] : [self closeDrawer];
        }
    }
}
    
/// 点击覆盖层调用
-(void)screenCoverViewGestureRecognizer:(UIPanGestureRecognizer *)panGesture {

    CGFloat offSetX = [panGesture translationInView:_coverButton].x;
    if (offSetX > 0 ) return;
    [self screenGestureRecognizer:panGesture offsetX:offSetX isCoverPan:YES];
}
    
//点击当前控制器view调用
-(void)screenVCViewGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)panGesture{
    
    CGFloat offSetX = [panGesture translationInView:panGesture.view].x;
    if (offSetX < 0) return;
    [self screenGestureRecognizer:panGesture offsetX:offSetX isCoverPan:NO];
}

/// 打开抽屉
-(void)openDrawer {
      __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:self.duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainViewController.view.transform = CGAffineTransformMakeTranslation(self.maxWidth, 0);
        self.lelfViewController.view.transform = CGAffineTransformMakeTranslation(self.maxWidth * maxOffSet, 0);
        self.transformMain = self.mainViewController.view.transform;
        self.transformLeft = self.lelfViewController.view.transform;
    } completion:^(BOOL finished) {
          __strong __typeof(weakSelf)strongSelf = weakSelf;
        [self.mainViewController.view addSubview:self.coverButton];
        [UIView animateWithDuration:self.duration animations:^{
            strongSelf.coverButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
        }];
    }];
}

/// 关闭抽屉
-(void)closeDrawer {
    
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:self.duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainViewController.view.transform = CGAffineTransformIdentity;
        self.lelfViewController.view.transform = CGAffineTransformIdentity;
        self.transformMain = self.mainViewController.view.transform;
        self.transformLeft = self.lelfViewController.view.transform;
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [UIView animateWithDuration:self.duration animations:^{
            strongSelf.coverButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        }];
        [self.coverButton removeFromSuperview];
    }];
}

/// - parameter viewController: 跳转目标控制器
-(void)switchViewController:(UIViewController *)vc {
    [self addChildViewController:vc];
    self.currentViewController = vc;
    [self.view addSubview:vc.view];
        vc.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    [UIView animateWithDuration:self.duration animations:^{
        vc.view.transform = CGAffineTransformIdentity;
    }];
}

 /// 返回到左侧控制器
-(void)switchBackMainViewController {
      __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:self.duration animations:^{
          __strong __typeof(weakSelf)strongSelf = weakSelf;
        self.currentViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        if (strongSelf.drawerBlock) {
            strongSelf.drawerBlock();
        }
    } completion:^(BOOL finished) {
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController.view removeFromSuperview];
    }];
}

@end
