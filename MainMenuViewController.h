//
//  SlideMenuViewController.h
//  SchoolCorporation
//
//  Created by 曾玉路 on 15/4/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SideBarSelectDelegate; //引入SideBarSelectDelegate


@interface MainMenuViewController : UIViewController
@property (assign,nonatomic) id<SideBarSelectDelegate> sideBarSelectDelegate; //定义一个遵守SideBarSelectDelegate协议的对象
@end
