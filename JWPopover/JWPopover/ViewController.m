//
//  ViewController.m
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//

#import "ViewController.h"
#import "JWPopupViewController.h"
@interface ViewController ()<JWPopupViewControllerDelegate>
@property (nonatomic,weak) JWPopupViewController *popView;
@end

@implementation ViewController{
    UIView *redView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setTextColor:[UIColor redColor]];
    [btn setTitle:@"btn1" forState:UIControlStateNormal];
    
    {
        redView = [UIView new];
        [redView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:redView];
        [redView setFrame:CGRectMake(50, 150, 150, 300)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 2;
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setFrame:CGRectMake(0, 0, 44, 44)];
        [redView addSubview:btn];
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setTextColor:[UIColor redColor]];
        [btn setTitle:@"btn1" forState:UIControlStateNormal];
    }

}


-(void)btnTouch:(UIButton *)sender{
    if (!_popView) {
        JWPopupViewController *popContentView = [[JWPopupViewController alloc]initWithStyle:UITableViewStylePlain];
        popContentView.modelPresent = YES;
        popContentView.dataSource = @[@"刷新",@"分享"];
        popContentView.maxPopContentSize = CGSizeMake(100, 200);
        popContentView.delegate = self;

        if (sender.tag == 2) {
            CGRect tmpFrame = sender.frame;
            [popContentView showAtRect:tmpFrame onView:redView];
        }else{
            CGRect tmpFrame =[sender convertRect:sender.bounds toView:self.view];
            [popContentView showAtRect:tmpFrame onView:self.view];
        }

        _popView = popContentView;
    }else{
        [_popView dismissCustomedPopoverAnimatd:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-JWPopupViewControllerDelegate
-(void)popUpViewSelectedIndex:(NSInteger)index{
    if (index < [_popView.dataSource count]) {//_popView.dataSource[0]
        NSLog(@"%@",_popView.dataSource[index]);
    }
}

@end
