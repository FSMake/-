//
//  SidebarViewController.m
//  YQYX
//
//  Created by 曾玉路 on 15/3/25.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "SidebarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainMenuViewController.h"

@interface SidebarViewController ()
{
    UIViewController  *_currentMainController; //定义当前视图控制器
    UITapGestureRecognizer *_tapGestureRecognizer; //拍击手势
    UIScreenEdgePanGestureRecognizer *_panLeftGestureReconginzer; //屏幕边缘拖动手势（左边缘拖动）
    UIPanGestureRecognizer *_panGestureRecognizer; //拖动手势
    BOOL sideBarShowing; //侧边栏是否显示标志
    CGFloat currentTranslate; //当前平移量
}
@property (strong,nonatomic) MainMenuViewController *leftSideBarViewController; //将左侧边栏视图加进来
@end

@implementation SidebarViewController

static SidebarViewController *rootViewController;

/*以下常量根据项目需要可以修改*/
const int LeftContentOffset = 280; //左侧边栏偏移量（显示的宽度）
const int RightContentOffset = 220; //右侧边栏偏移量（显示的宽度）
const int ContentMinOffset = 60; //内容最小偏移量
const float MoveAnimationDuration = 0.3; //移动动画时间

//目的得到类本身(警告：此处不能用单例替换)
+ (id)share
{
    return rootViewController;
}

//加载视图
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES; //隐藏navigationBar
  //  self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    //将self赋值给rootViewController
    if (rootViewController) {
        rootViewController = nil;
    }
	rootViewController = self;
    
    sideBarShowing = NO;
    currentTranslate = 0; //初始化当前偏移量为0
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0); //阴影偏移量
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影颜色
    self.contentView.layer.shadowOpacity = 1; //阴影不透明度
    
    MainMenuViewController *_leftCon = [[MainMenuViewController alloc] init];
    _leftCon.sideBarSelectDelegate = self;  //将self（本类）传到MainMenuViewController类里面
    self.leftSideBarViewController = _leftCon;

    
    [self addChildViewController:self.leftSideBarViewController]; //添加MainMenuViewController作为SidebarViewController的子视图控制器
    self.leftSideBarViewController.view.frame = self.navBackView.bounds;
    [self.navBackView addSubview:self.leftSideBarViewController.view]; //添加MainMenuViewController的view到navBackView中
    
    //屏幕左边缘拖动手势
    _panLeftGestureReconginzer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [_panLeftGestureReconginzer setEdges:UIRectEdgeLeft]; //UIRectEdgeLeft：左边缘
    [self.contentView addGestureRecognizer:_panLeftGestureReconginzer];
}

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

- (void)contentViewAddPanGestures
{
    if (_panGestureRecognizer) {
        [self.contentView removeGestureRecognizer:_panGestureRecognizer];
        _panGestureRecognizer = nil;
    }
    
    _panGestureRecognizer = [[UIPanGestureRecognizer  alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.contentView addGestureRecognizer:_panGestureRecognizer];
}

- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration]; //(0, 0) 侧边栏关闭
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    }];
}

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged) //拖动过程中
    {
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        self.tabBarController.tabBar.frame = CGRectMake(currentTranslate + translation, self.view.frame.size.height-49, self.view.frame.size.width, 49);
        //NSLog(@"%f",currentTranslate + translation);
        if (currentTranslate + translation > 0) {
            self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
            UIView *view ;
            if (translation+currentTranslate>0)
            {
                view = self.leftSideBarViewController.view;
            }
            [self.navBackView bringSubviewToFront:view];
        }
    } else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded) //拖动过程结束
    {
		currentTranslate = self.contentView.transform.tx;
      //  NSLog(@"%f",currentTranslate); //相对与之前的（0，0）的位置坐标（currentTranslate,0）
        if (!sideBarShowing) { //让侧边栏显示（从无到有）
            [UIView animateWithDuration:0.3 animations:^{
                self.tabBarController.tabBar.frame = CGRectMake(280, self.view.frame.size.height-49, self.view.frame.size.width, 49);
            }];

            if (fabs(currentTranslate)<ContentMinOffset) { //fabs取绝对值  
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            } else if(currentTranslate>ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            } else {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }else //让侧边栏不显示（从有到无）
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.tabBarController.tabBar.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
            }];

            if (fabs(currentTranslate)<LeftContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration]; //(0, 0) 侧边栏关闭
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.hidesBottomBarWhenPushed = NO;
            }else if(currentTranslate>LeftContentOffset-ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration]; //(LeftContentOffset, 0) 侧边栏显示
                self.hidesBottomBarWhenPushed = YES;
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
    }
}

#pragma mark - nav con delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark - side bar select delegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}


- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
     
    if (currentTranslate == LeftContentOffset) {
        [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration]; //(0, 0) 侧边栏关闭
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
        }];
    } else {
        if (direction!=SideBarShowDirectionNone) {
            UIView *view ;
            if (direction == SideBarShowDirectionLeft)
            {
                view = self.leftSideBarViewController.view;
            }
            [self.navBackView bringSubviewToFront:view];
        }
        [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
    }
}



#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    //Block块，其它地方可以通过调用Block名（animations）来调用这部分代码
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.tabBarController.tabBar.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
//                }];

            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(LeftContentOffset, 0);
                [UIView animateWithDuration:0.3 animations:^{
                    self.tabBarController.tabBar.frame = CGRectMake(280, self.view.frame.size.height-49, self.view.frame.size.width, 49);
                }];

            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(-RightContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES; //设置可以和用户进行交互
        
        if (direction == SideBarShowDirectionNone)
        {
            if (_tapGestureRecognizer) { //如果是拍击手势
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            if (_panGestureRecognizer) { //如果是拖动手势
                [self.contentView removeGestureRecognizer:_panGestureRecognizer];
                _panGestureRecognizer = nil;
            }
            sideBarShowing = NO; //关闭侧边栏
        }else
        {
            [self contentViewAddTapGestures]; //添加拍击手势
            [self contentViewAddPanGestures]; //添加拖动手势
             sideBarShowing = YES; //显示侧边栏
        }
        currentTranslate = self.contentView.transform.tx; //设置当前偏移量
        //NSLog(@"%f",currentTranslate); //输出得到0和LeftContentOffset（280）
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO; //设置不可以和用户进行交互
    [UIView animateWithDuration:duration animations:animations completion:complete]; //设置UIView方法
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
