//
//  SidebarViewController.h
//  YQYX
//
//  Created by 曾玉路 on 15/3/25.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectDelegate.h"

@interface SidebarViewController : UIViewController<SideBarSelectDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic)IBOutlet UIView *contentView;
@property (strong,nonatomic)IBOutlet UIView *navBackView;

+ (id)share;

@end
