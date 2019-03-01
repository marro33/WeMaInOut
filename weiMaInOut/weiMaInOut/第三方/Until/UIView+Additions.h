//
//  UIView+Additions.h
//  Orimuse
//
//  Created by Bingjie on 14/12/11.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (UIViewController *)getViewController;


//frame
- (void)setX:(CGFloat)x;

- (void)setY:(CGFloat)y;

- (void)setWidth:(CGFloat)aWidth;

- (void)setHeight:(CGFloat)aHeight;

- (void)addX:(CGFloat)x;

- (void)addY:(CGFloat)y;

- (void)addWidth:(CGFloat)aWidth;

- (void)addHeight:(CGFloat)aHeight;


- (CGFloat)left;

- (CGFloat)top;

- (CGFloat)right;

- (CGFloat)bottom;

- (CGFloat)width;

- (CGFloat)height;

@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;
/**
 *	@brief	删除所有子对象
 */
- (void)removeAllSubviews;



- (void)addTapGesturesTarget:(id)target selector:(SEL)selector;

- (CGSize)doubleSizeOfFrame;

- (void)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )startPoint endPoint:(CGPoint)endPoint;


- (void)drawLineWidth:(CGFloat )width
          strokeColor:(UIColor *)color
           startPoint:(CGPoint )sPoint
             endPoint:(CGPoint )ePoint;
//动画

- (void)scaleViewAnimationDuration:(CGFloat)duration scaleValue:(CGFloat)scaleValue;

- (CABasicAnimation *)fadeInView;
- (CABasicAnimation *)fadeOutView;

@end