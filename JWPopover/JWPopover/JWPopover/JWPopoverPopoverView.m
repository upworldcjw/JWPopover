//
//  JWPopoverPopoverView.m
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//


#import "JWPopoverPopoverView.h"

@implementation JWPopoverPopoverView

@synthesize cornerRadius = _cornerRadius;
@synthesize arrowPoint = _arrowPoint;
@synthesize arrowDirection = _arrowDirection;
@synthesize arrowPosition = _arrowPosition;
@synthesize baseColor = _baseColor;

- (id)init
{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.baseColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    UIImage *backgroundImage = self.backgroundImage;
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1];
    
}

-(UIImage*)backgroundImage
{
    UIColor *arrowColor = self.baseColor;
    //size
    float bgSizeWidth = self.frame.size.width;
    float bgSizeHeight = self.frame.size.height;
    float bgRectSizeWidth = 0;
    float bgRectSizeHeight = 0;
    float bgRectPositionX = 0;
    float bgRectPositionY = 0;
    float arrowHead = 0;
    float arrowBase = self.arrowHeight+1;
    float arrowFirst =0;
    float arrowLast = 0;
    
    CGPoint senderLocationInViewPoint = self.arrowPoint;

    if(self.arrowPosition == JWPopoverArrowPositionVertical){
        bgRectSizeWidth = bgSizeWidth;
        bgRectSizeHeight = bgSizeHeight - self.arrowHeight;
        
        if(self.arrowDirection == JWPopoverArrowDirectionTop){
            bgRectPositionY = self.arrowHeight;
        }
        
        if(self.arrowDirection == JWPopoverArrowDirectionBottom){
            arrowHead = bgRectSizeHeight + self.arrowHeight;
            arrowBase = bgRectSizeHeight - 1;
        }
    }else if(self.arrowPosition == JWPopoverArrowPositionHorizontal){
        bgRectSizeWidth = bgSizeWidth - self.arrowWidth;
        bgRectSizeHeight = bgSizeHeight;
        
        if(self.arrowDirection == JWPopoverArrowDirectionLeft){
            bgRectPositionX = self.arrowWidth;
        }
        
        if(self.arrowDirection == JWPopoverArrowDirectionRight){
            arrowHead = bgRectSizeWidth + self.arrowWidth;
            arrowBase = bgRectSizeWidth - 1;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bgSizeWidth, bgSizeHeight), NO, 0);

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(bgRectPositionX, bgRectPositionY, bgRectSizeWidth, bgRectSizeHeight) cornerRadius: self.cornerRadius];

    
    //// Polygon Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    if(self.arrowPosition == JWPopoverArrowPositionVertical){
        arrowFirst = senderLocationInViewPoint.x-self.arrowWidth/2;
        arrowLast = senderLocationInViewPoint.x+self.arrowWidth/2;
        if(arrowFirst < bgRectPositionX + (self.cornerRadius)){
            arrowFirst = bgRectPositionX + (self.cornerRadius);
            arrowLast = arrowFirst + self.arrowWidth;
        }
        if(arrowLast > (bgRectPositionX + bgRectSizeWidth) - (self.cornerRadius)){
            arrowLast = (bgRectPositionX + bgRectSizeWidth) - (self.cornerRadius);
            arrowFirst = arrowLast -  self.arrowWidth;
        }
//        arrowFirst =self.frame.size.width -40;
//        arrowLast = arrowFirst + ARROW_SIZE;
        
        [bezierPath moveToPoint: CGPointMake(arrowFirst, arrowBase)];
        [bezierPath addLineToPoint: CGPointMake(arrowFirst + self.arrowWidth/2.0, arrowHead)];
        [bezierPath addLineToPoint: CGPointMake(arrowLast, arrowBase)];
    }else if(self.arrowPosition == JWPopoverArrowPositionHorizontal){
        arrowFirst = senderLocationInViewPoint.y-self.arrowHeight/2;
        arrowLast = senderLocationInViewPoint.y+self.arrowHeight/2;
        
        if(arrowFirst < bgRectPositionY + (self.cornerRadius)){
            arrowFirst = bgRectPositionY + (self.cornerRadius);
            arrowLast = arrowFirst + self.arrowHeight;
        }

        if(arrowLast > (bgRectPositionY + bgRectSizeHeight) - (self.cornerRadius)){
            arrowLast = (bgRectPositionY + bgRectSizeHeight) - (self.cornerRadius);
            arrowFirst = arrowLast - self.arrowHeight;
        }

        [bezierPath moveToPoint: CGPointMake(arrowBase, arrowFirst)];
        [bezierPath addLineToPoint: CGPointMake(arrowHead, senderLocationInViewPoint.y)];
        [bezierPath addLineToPoint: CGPointMake(arrowBase, arrowLast)];
    }

    CGContextSaveGState(context);
    [arrowColor setFill];
    [bezierPath fill];
    
    [roundedRectanglePath appendPath:bezierPath];
    [roundedRectanglePath addClip];  
    
    [self.baseColor setFill];
    [roundedRectanglePath fill];

    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

@end
