//
//  JWPopoverTouchView.h
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//


#import "JWPopoverTouchView.h"

@implementation JWPopoverTouchView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event{
    UIView *subView = [super hitTest:point withEvent:event];
    if (subView == self) {
        if([self.delegate popoverIsModelPresentWhenTouch]){
            return self;
        }else{
            return nil;
        };
    }
    return subView;
}

@end
