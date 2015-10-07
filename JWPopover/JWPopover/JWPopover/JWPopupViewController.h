//
//  JWPopupViewController.h
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWPopupViewControllerDelegate <NSObject>
-(void)popUpViewSelectedIndex:(NSInteger)index;
@end

@interface JWPopupViewController : UITableViewController

/*
 *modelPresent = yes的时候，pop所在view（-(void)showAtRect:(CGRect)rect onView:(UIView *)view）
 *下面的视图不响应事件。modelPresent = NO，pop所在view 可以响应事件
 */
@property(nonatomic,assign) BOOL modelPresent;

/*
 *如 @[@"qq",@["wechat"]]
 */
@property(nonatomic,strong) NSArray *dataSource;

/*
 *ContentSize.width 为所在pop的宽度（-10），ContentSize.height 为内容最大高度，
 *如果小于最大高度，pop的高度会自动调整的适合的大小。
 */
@property(nonatomic,assign)  CGSize maxPopContentSize;


@property(nonatomic,strong)  NSString *popTitle;  //是否显示标题
@property(nonatomic,assign)  BOOL   hasArrow;   //是否有向上箭头
@property (nonatomic,assign) UIColor *popContentColor;
@property (nonatomic,assign) UIColor *popBgColor;
/*
 *dataSource数组对应的索引index
 */
@property(nonatomic,weak)  id<JWPopupViewControllerDelegate> delegate;

-(void)showAtRect:(CGRect)rect onView:(UIView *)view;

-(void)showAtRect:(CGRect)rect ;

- (void)dismissCustomedPopoverAnimatd:(BOOL)animated;

@end
