//
//  JWPopoverPopoverView.h
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JWPopoverController.h"

@interface JWPopoverPopoverView : UIView

@property (nonatomic) int cornerRadius;
@property (nonatomic) CGPoint arrowPoint;
@property (nonatomic, strong) UIColor *baseColor;
@property (nonatomic, readwrite) JWPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) JWPopoverArrowPosition arrowPosition;
@property (nonatomic) CGFloat arrowHeight;
@property (nonatomic) CGFloat arrowWidth;


@end
