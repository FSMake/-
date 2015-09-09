//
//  SideBarSelectDelegate.h
//  YQYX
//
//  Created by 曾玉路 on 15/3/25.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}SideBarShowDirection;

@protocol SideBarSelectDelegate <NSObject>

- (void)leftSideBarSelectWithController:(UIViewController *)controller;
- (void)rightSideBarSelectWithController:(UIViewController *)controller;
- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction;

@end
