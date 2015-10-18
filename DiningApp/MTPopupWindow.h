//
//  MTPopupWindow.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Modified by Felix Xiao on 12/22/2012
//
//  Copyright (C) 2012 by Marin Todorov
//  Created by Marin Todorov on 05/09/2012
//  Implemented with MIT License
//  

#import <UIKit/UIKit.h>

@interface MTPopupWindow : UIView

//properties
@property (nonatomic,strong) UIView *selectedView;

//methods
+ (MTPopupWindow*)showWindowWithView:(UIView*)newView;
+ (MTPopupWindow*)showWindow:(UIView*)newView insideView:(UIView*)view;
- (void)show;
- (void)showInView:(UIView*)v;
+ (void)setWindowMargin:(CGSize)margin;

@end