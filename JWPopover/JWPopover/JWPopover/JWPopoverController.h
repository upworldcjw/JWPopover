//
//  JWPopoverController.h
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JWPopoverTouchesDelegate.h"

enum {
    JWPopoverArrowDirectionTop = 0,
	JWPopoverArrowDirectionRight,
    JWPopoverArrowDirectionBottom,
    JWPopoverArrowDirectionLeft
};
typedef NSUInteger JWPopoverArrowDirection;

enum {
    JWPopoverArrowPositionVertical = 0,
    JWPopoverArrowPositionHorizontal
};
typedef NSUInteger JWPopoverArrowPosition;

@class JWPopoverPopoverView;

@interface JWPopoverController : UIViewController <JWPopoverTouchesDelegate>
{
    JWPopoverPopoverView * popoverView;
    JWPopoverArrowDirection arrowDirection;
    CGRect screenRect;
    int titleLabelheight;
}

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *popoverBaseColor;
@property (nonatomic, readwrite) JWPopoverArrowPosition arrowPosition;
@property (nonatomic) BOOL showShadow;          //是否显示
@property (nonatomic) CGFloat innerCornerRadius;
@property (nonatomic) CGFloat outterCornerRadius;
@property (nonatomic) CGFloat arrowHeight;
@property (nonatomic) CGFloat arrowWidth;
@property (nonatomic) BOOL modelPresent;

- (id)initWithContentViewController:(UIViewController*)viewController;
- (id)initWithView:(UIView*)view;
- (void) showPopoverWithTouch:(UIEvent*)senderEvent;
- (void) showPopoverWithCell:(UITableViewCell*)senderCell;
//senderRect 应该是相对view的坐标。
- (void) showPopoverWithRect:(CGRect)senderRect onView:(UIView *)view;
- (void) showPopoverWithPoint:(CGPoint)senderPoint;
- (void) dismissPopoverAnimatd:(BOOL)animated;

@end
