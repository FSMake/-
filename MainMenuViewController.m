//
//  SlideMenuViewController.m
//  SchoolCorporation
//
//  Created by 曾玉路 on 15/4/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SidebarViewController.h"
#import "HomePageViewController.h"


#import "Settings_ViewController.h"
//#import "UMSocial.h"
#import "Collecting_ViewController.h"
#import "Support_ViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    if ([self.sideBarSelectDelegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [self.sideBarSelectDelegate leftSideBarSelectWithController:[self showHomePage]];
    }


    //设置侧滑栏背景图片
    UIImageView *beiJing=[[UIImageView alloc]initWithFrame:self.view.frame];
    beiJing.image=[UIImage imageNamed:@"beijing.jpg"];
    
    [self.view addSubview:beiJing];
    
    //初始化头像按钮
    UIButton *touXiang=[UIButton buttonWithType:UIButtonTypeCustom];
    
    touXiang.frame=CGRectMake(80, 30, 80,80);
    
    touXiang.backgroundColor=[UIColor clearColor];
    
    
    
    
    [touXiang setBackgroundImage:[UIImage imageNamed:@"headImg"] forState:UIControlStateNormal];
    
    [touXiang addTarget:self action:@selector(touxiang) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:touXiang];
    
    
    //初始化登陆注册按钮
    UIButton *dengLu=[[UIButton alloc]initWithFrame:CGRectMake(70, 130, 120, 40)];
    
    [dengLu setTitle:@"登陆/注册" forState:UIControlStateNormal];
    
    dengLu.backgroundColor=[UIColor grayColor];
    
    [dengLu addTarget:self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:dengLu];
    
    
    //初始化我的收藏按钮
    UIButton *shoucang=[[UIButton alloc]initWithFrame:CGRectMake(70,200,120, 40)];
    
    [shoucang setTitle:@"我的收藏" forState:UIControlStateNormal];
    
    shoucang.backgroundColor=[UIColor grayColor];
    
    [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shoucang];
    
    
    //初始化设置按钮
    UIButton *shezhi=[[UIButton alloc]initWithFrame:CGRectMake(70, 270, 120, 40)];
    
    [shezhi setTitle:@"设置" forState:UIControlStateNormal];
    
    shezhi.backgroundColor=[UIColor grayColor];
    
    [shezhi addTarget:self action:@selector(shezhi) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shezhi];
    
    
    //初始化辅助功能按钮
    UIButton *fuzhu=[[UIButton alloc]initWithFrame:CGRectMake(70, 340, 120, 40)];
    
    [fuzhu setTitle:@"辅助功能" forState:UIControlStateNormal];
    
    fuzhu.backgroundColor=[UIColor grayColor];
    
    [fuzhu addTarget:self action:@selector(fuzhu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fuzhu];
    
    //初始化退出按钮
    UIButton *tuichu=[[UIButton alloc]initWithFrame:CGRectMake(70, 410, 120, 40)];
    
    [tuichu setTitle:@"退出账号" forState:UIControlStateNormal];
    
    tuichu.backgroundColor=[UIColor grayColor];
    
    [tuichu addTarget:self action:@selector(tuichu ) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tuichu];
    
    
    
    
    
}


#pragma mark-------跳转到个人资料界面----------
-(void)touxiang
{
    
    
    
    
}



#pragma mark-------跳转到登陆注册界面----------
-(void)dengLu
{
    
    
    
    
}

#pragma mark-------跳转到我的收藏界面----------
-(void)shoucang
{
    Collecting_ViewController *collect=[[Collecting_ViewController alloc]init];
    
    [self.navigationController pushViewController:collect animated:YES];
    
    
    
    
    
}

#pragma mark------跳转到设置界面------------
-(void)shezhi
{
    
    Settings_ViewController *set=[[Settings_ViewController alloc]init];
    
    [self.navigationController pushViewController:set animated:YES];
    
    
}

#pragma mark------跳转到辅助功能界面-------
-(void)fuzhu
{
    
    Support_ViewController *support=[[Support_ViewController alloc]init];
    
    [self.navigationController pushViewController:support animated:YES];
    
    
    
    
}


#pragma mark-------退出当前账号---------
-(void)tuichu
{
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出当前账号吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    
    [alert show];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    
    self.title=@"返回";
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=NO;
    
    self.title=@"返回";
    
}




#pragma -mark 跳转接口

//首页
- (UINavigationController *)showHomePage {
    HomePageViewController *homePage = [[HomePageViewController alloc] init];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:homePage];
    return nav ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
