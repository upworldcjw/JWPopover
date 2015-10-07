//
//  JWPopoverController.m
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//


#import "JWPopoverController.h"
#import "JWPopoverTouchView.h"
#import "JWPopoverPopoverView.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN 5                //contetnView 距离 pop的左右上下边距
#define OUTER_MARGIN 5
#define TITLE_LABEL_HEIGHT 25   //标题的高度

#define ARROW_MARGIN 2
@interface JWPopoverController ()

@end

@implementation JWPopoverController

@synthesize contentViewController = _contentViewController;
@synthesize contentView = _contentView;
@synthesize innerCornerRadius = _innerCornerRadius;
@synthesize titleText = _titleText;
@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;
@synthesize arrowPosition = _arrowPosition;

- (id)init {
	if ((self = [super init])) {
        self.modelPresent = YES;
        self.innerCornerRadius = 0;//默认是5,里面的圆角
        self.outterCornerRadius = 0; //外面的圆角
        self.arrowHeight = 8;
        self.arrowWidth = 14;
        self.titleColor = [UIColor whiteColor];
        self.titleFont = [UIFont boldSystemFontOfSize:14];
        self.view.backgroundColor = [UIColor clearColor];
        self.arrowPosition = JWPopoverArrowPositionVertical;
        self.popoverBaseColor = [UIColor blackColor];
        screenRect = [[UIScreen mainScreen] bounds];
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            screenRect.size.width = [[UIScreen mainScreen] bounds].size.height;
            screenRect.size.height = [[UIScreen mainScreen] bounds].size.width;
        }
        self.view.frame = screenRect;

        titleLabelheight = 0;
	}
	return self;
}

- (id)initWithContentViewController:(UIViewController*)viewController
{
    self = [self init];
    
    self.contentViewController = viewController;
    self.contentView = viewController.view;
    
    return self;
}

- (id)initWithView:(UIView*)view
{
    self = [self init];
    self.contentView = view;
    
    return self;   
}

-(void)loadView{
    [super loadView];
    JWPopoverTouchView *touchView = [[JWPopoverTouchView alloc] init];
    touchView.frame = self.view.frame;
    touchView.delegate = self;
    self.view = touchView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) showPopoverWithTouch:(UIEvent*)senderEvent
{    
    UIView *senderView = [[senderEvent.allTouches anyObject] view];
    CGPoint applicationFramePoint = CGPointMake(screenRect.origin.x,0-screenRect.origin.y);
    //CGPoint senderLocationInWindowPoint = [[[UIApplication sharedApplication] keyWindow] convertPoint:applicationFramePoint fromView:senderView];
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint senderLocationInWindowPoint = [appWindow.rootViewController.view convertPoint:applicationFramePoint fromView:senderView];
    CGRect senderFrame = [[[senderEvent.allTouches anyObject] view] frame];
    senderFrame.origin.x = senderLocationInWindowPoint.x;
    senderFrame.origin.y = senderLocationInWindowPoint.y;
    CGPoint senderPoint = [self senderPointFromSenderRect:senderFrame];
    [self showPopoverWithPoint:senderPoint];
}

- (void) showPopoverWithCell:(UITableViewCell*)senderCell
{
    UIView *senderView = senderCell.superview;
    CGPoint applicationFramePoint = CGPointMake(screenRect.origin.x,0-screenRect.origin.y);
    CGPoint senderLocationInWindowPoint = [[[UIApplication sharedApplication] keyWindow] convertPoint:applicationFramePoint fromView:senderView];
    CGRect senderFrame = senderCell.frame;
    senderFrame.origin.x = senderLocationInWindowPoint.x;
    senderFrame.origin.y = senderLocationInWindowPoint.y + senderFrame.origin.y;
    CGPoint senderPoint = [self senderPointFromSenderRect:senderFrame];
    [self showPopoverWithPoint:senderPoint];
}

- (void) showPopoverWithRect:(CGRect)senderRect onView:(UIView *)view
{
    if (view) {//如果显示在某个视图上
        screenRect = view.bounds;
        self.view.frame = screenRect;
    }
    CGPoint senderPoint = [self senderPointFromSenderRect:senderRect];
    [self showPopoverWithPoint:senderPoint onView:view];
}

- (void) showPopoverWithPoint:(CGPoint)senderPoint{
    [self showPopoverWithPoint:senderPoint onView:nil];
}


- (void) showPopoverWithPoint:(CGPoint)senderPoint onView:(UIView *)view
{
    if(self.titleText){
        titleLabelheight = TITLE_LABEL_HEIGHT;
    }
    
    CGRect contentViewFrame = [self contentFrameRect:self.contentView.frame senderPoint:senderPoint];
    
    int backgroundPositionX = 0;
    int backgroundPositionY = 0;
    if(arrowDirection == JWPopoverArrowDirectionLeft){
        backgroundPositionX = self.arrowWidth;
    }
    if(arrowDirection == JWPopoverArrowDirectionTop){
        backgroundPositionY = self.arrowHeight;
    }
    
    UILabel *titleLabel;
    if(self.titleText){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundPositionX, backgroundPositionY, contentViewFrame.size.width+MARGIN*2, TITLE_LABEL_HEIGHT+MARGIN)];
        titleLabel.textColor = self.titleColor;
        titleLabel.text = self.titleText;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = self.titleFont;
    }
    contentViewFrame.origin.x = backgroundPositionX+MARGIN;
    contentViewFrame.origin.y = backgroundPositionY+titleLabelheight+MARGIN;
    
    
    self.contentView.frame = contentViewFrame;
    
    CALayer * contentViewLayer = [self.contentView layer];
    [contentViewLayer setMasksToBounds:YES];
    [contentViewLayer setCornerRadius:self.innerCornerRadius];
    
    popoverView = [[JWPopoverPopoverView alloc] init];
    popoverView.arrowHeight = self.arrowHeight;
    popoverView.arrowWidth = self.arrowWidth;
    popoverView.arrowDirection = arrowDirection;
    popoverView.arrowPosition = self.arrowPosition;
    popoverView.arrowPoint = senderPoint;
    popoverView.alpha = 0;
    popoverView.frame = [self popoverFrameRect:contentViewFrame senderPoint:senderPoint];
    if(self.outterCornerRadius == .0){
        self.outterCornerRadius = self.innerCornerRadius;
    }else{
        if (self.outterCornerRadius <= self.innerCornerRadius) {
            self.outterCornerRadius = self.innerCornerRadius + 5;
        }
    }
    popoverView.cornerRadius = self.outterCornerRadius;
    popoverView.baseColor = self.popoverBaseColor;
    [popoverView addSubview:self.contentView];
    [popoverView addSubview:titleLabel];
    
    if (self.showShadow) {
        CALayer* layer = popoverView.layer;
        layer.shadowOffset = CGSizeMake(0, 2);
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowOpacity = 0.5;
    }
    
    [self.view addSubview:popoverView];
    

    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    if (view) {
        [view addSubview:self.view];
    }else{
        [appWindow.rootViewController.view addSubview:self.view];
    }

    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         popoverView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}


- (void) dismissPopoverAnimatd:(BOOL)animated
{
    if (self.view) {
        if(animated) {
            [UIView animateWithDuration:0.2
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 popoverView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 [self.contentViewController viewDidDisappear:animated];
                                 popoverView=nil;
                                 [self.view removeFromSuperview];
                                 self.contentViewController = nil;
                                 self.titleText = nil;
                                 self.titleColor = nil;
                                 self.titleFont = nil;
                             }
             ];
        }else{
            [self.contentViewController viewDidDisappear:animated];
            popoverView=nil;
            [self.view removeFromSuperview];
            self.contentViewController = nil;
            self.titleText = nil;
            self.titleColor = nil;
            self.titleFont = nil;
        }
        
    }
}

- (CGRect) contentFrameRect:(CGRect)contentFrame senderPoint:(CGPoint)senderPoint
{
    CGRect contentFrameRect = contentFrame;
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height - screenRect.origin.y;

    contentFrameRect.origin.x = MARGIN;
    contentFrameRect.origin.y = MARGIN;


    if(self.arrowPosition == JWPopoverArrowPositionVertical){
        if(contentFrameRect.size.width > self.view.frame.size.width - (OUTER_MARGIN*2+MARGIN*2)){
            contentFrameRect.size.width = self.view.frame.size.width - (OUTER_MARGIN*2+MARGIN*2);
        }
        
        float popoverY;
        float popoverHeight = contentFrameRect.size.height+titleLabelheight+(self.arrowHeight+MARGIN*2);//pop+title+margin+contentHeight + margin
        
        if(arrowDirection == JWPopoverArrowDirectionTop){
            popoverY = senderPoint.y+ARROW_MARGIN;
            if((popoverY+popoverHeight) > screenHeight){
                contentFrameRect.size.height = screenHeight - (screenRect.origin.y + popoverY + titleLabelheight + (OUTER_MARGIN*2+MARGIN*2));
            }
        }
        
        if(arrowDirection == JWPopoverArrowDirectionBottom){
            popoverY = senderPoint.y - ARROW_MARGIN;
            float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
            if((popoverY-popoverHeight) < statusBarHeight){
                contentFrameRect.size.height = popoverY - (statusBarHeight + self.arrowHeight + screenRect.origin.y + titleLabelheight + (OUTER_MARGIN+MARGIN*2));
            }
        }
    }else if(self.arrowPosition == JWPopoverArrowPositionHorizontal){
        if(contentFrameRect.size.height > screenHeight - (OUTER_MARGIN*2+MARGIN*2)){
            contentFrameRect.size.height = screenHeight - (OUTER_MARGIN*2+MARGIN*2);
        }
        
        float popoverX;
        float popoverWidth = contentFrameRect.size.width+(self.arrowWidth+MARGIN*2);
        
        if(arrowDirection == JWPopoverArrowDirectionLeft){
            popoverX = senderPoint.x + ARROW_MARGIN;
            if((popoverX+popoverWidth)> screenWidth - (OUTER_MARGIN*2+MARGIN*2)){
                contentFrameRect.size.width = screenWidth - popoverX - self.arrowWidth - (OUTER_MARGIN*2+MARGIN*2);
            }
        }
        
        if(arrowDirection == JWPopoverArrowDirectionRight){
            popoverX = senderPoint.x - ARROW_MARGIN;
            if((popoverX-popoverWidth) < screenRect.origin.x+(OUTER_MARGIN*2+MARGIN*2)){
                contentFrameRect.size.width = popoverX - self.arrowWidth - (OUTER_MARGIN*2+MARGIN*2);
            }
        }
        
    }
    
    return contentFrameRect;
}


- (CGRect)popoverFrameRect:(CGRect)contentFrame senderPoint:(CGPoint)senderPoint
{
    CGRect popoverRect;
    float popoverWidth;
    float popoverHeight;
    float popoverX;
    float popoverY;

    if(self.arrowPosition == JWPopoverArrowPositionVertical){
        
        popoverWidth = contentFrame.size.width+MARGIN*2;
        popoverHeight = contentFrame.size.height+titleLabelheight+(self.arrowHeight+MARGIN*2);

        popoverX = senderPoint.x - (popoverWidth/2);
        if(popoverX < OUTER_MARGIN) {
            popoverX = OUTER_MARGIN;
        } else if((popoverX + popoverWidth)>self.view.frame.size.width) {
            popoverX = self.view.frame.size.width - (popoverWidth+OUTER_MARGIN);
        }
        
        if(arrowDirection == JWPopoverArrowDirectionBottom){
            popoverY = senderPoint.y - popoverHeight - ARROW_MARGIN;
        }else{
            popoverY = senderPoint.y + ARROW_MARGIN;
        }
        
        popoverRect = CGRectMake(popoverX, popoverY, popoverWidth, popoverHeight);
        
    }else if(self.arrowPosition == JWPopoverArrowPositionHorizontal){
        
        popoverWidth = contentFrame.size.width+self.arrowWidth+MARGIN*2;
        popoverHeight = contentFrame.size.height+titleLabelheight+MARGIN*2;

        if(arrowDirection == JWPopoverArrowDirectionRight){
            popoverX = senderPoint.x - popoverWidth - ARROW_MARGIN;
        }else{
            popoverX = senderPoint.x + ARROW_MARGIN;
        }
        
        popoverY = senderPoint.y - (popoverHeight/2);
        if(popoverY < OUTER_MARGIN){
            popoverY = OUTER_MARGIN;
        }else if((popoverY + popoverHeight)>self.view.frame.size.height){
            popoverY = self.view.frame.size.height - (popoverHeight+OUTER_MARGIN);
        }
        
        popoverRect = CGRectMake(popoverX, popoverY, popoverWidth, popoverHeight);

    }


    return popoverRect;
    
}

- (CGPoint)senderPointFromSenderRect:(CGRect)senderRect
{
    CGPoint senderPoint;
    [self checkArrowPosition:senderRect];
    
    if(arrowDirection == JWPopoverArrowDirectionTop){
        senderPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width/2), senderRect.origin.y + senderRect.size.height);
    }else if(arrowDirection == JWPopoverArrowDirectionBottom){
        senderPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width/2), senderRect.origin.y);
    }else if(arrowDirection == JWPopoverArrowDirectionRight){
        senderPoint = CGPointMake(senderRect.origin.x, senderRect.origin.y + (senderRect.size.height/2));
        senderPoint.y = senderPoint.y + screenRect.origin.y;
    }else if(arrowDirection == JWPopoverArrowDirectionLeft){
        senderPoint = CGPointMake(senderRect.origin.x + senderRect.size.width, senderRect.origin.y + (senderRect.size.height/2));
        senderPoint.y = senderPoint.y + screenRect.origin.y;
    }

    return senderPoint;
}

- (void) checkArrowPosition:(CGRect)senderRect
{
    float clearSpaceA=0;
    float clearSpaceB=0;
    if(self.arrowPosition == JWPopoverArrowPositionVertical){
        if(!arrowDirection){
            clearSpaceA = screenRect.origin.y + senderRect.origin.y;
            clearSpaceB = screenRect.size.height - (senderRect.origin.y+senderRect.size.height);
            if(clearSpaceA> clearSpaceB){
                if(clearSpaceA < titleLabelheight+10){//如果垂直方向间距空间过小，尝试箭头水平布局。
                    self.arrowPosition = JWPopoverArrowPositionHorizontal;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = JWPopoverArrowDirectionBottom;
                }
            }else{
                if(clearSpaceB < titleLabelheight+10){
                    self.arrowPosition = JWPopoverArrowPositionHorizontal;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = JWPopoverArrowDirectionTop;
                }
            }
        }
        
        
    }else if(self.arrowPosition == JWPopoverArrowPositionHorizontal){
        
        if(!arrowDirection){
            clearSpaceA = screenRect.origin.x + senderRect.origin.x;
            clearSpaceB = screenRect.size.width - (senderRect.origin.x+senderRect.size.width);
            if(clearSpaceA> clearSpaceB){
                if(clearSpaceA < 40){//如果水平间距过小，则尝试垂直布局
                    self.arrowPosition = JWPopoverArrowPositionVertical;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = JWPopoverArrowDirectionRight;
                }
            }else{
                if(clearSpaceB < 40){
                    self.arrowPosition = JWPopoverArrowPositionVertical;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = JWPopoverArrowDirectionLeft;
                }
            }
        }
        
    }
}


#pragma mark -TSPopoverTouchesDelegate
-(BOOL)popoverIsModelPresentWhenTouch{
    [self dismissPopoverAnimatd:YES];
    return self.modelPresent;
}

@end