//
//  MTPopupWindow.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Modified by Felix Xiao on 12/22/2012
//
//  Copyright (C) 2012 by Marin Todorov
//  Created by Marin Todorov on 05/09/2012
//  Implemented with MIT License
//

#import "MTPopupWindow.h"
#import "QuartzCore/QuartzCore.h"

#define kCloseBtnDiameter 30
#define kDefaultMargin 18
static CGSize kWindowMarginSize;

@interface MTPopupWindow() {
    UIView* _dimView;
    UIView* _bgView;
}
@end

@interface MTPopupWindowCloseButton : UIButton
+ (id)buttonInView:(UIView*)v;
@end

@interface UIView(MTPopupWindowLayoutShortcuts)
- (void)replaceConstraint:(NSLayoutConstraint*)c;
- (void)layoutCenterInView:(UIView*)v;
- (void)layoutInView:(UIView*)v setSize:(CGSize)s;
- (void)layoutMaximizeInView:(UIView*)v withInset:(float)inset;
- (void)layoutMaximizeInView:(UIView*)v withInsetSize:(CGSize)insetSize;
@end


@implementation MTPopupWindow

//synthesize properties
@synthesize selectedView;

//methods
+ (void)initialize
{
    kWindowMarginSize = CGSizeMake(kDefaultMargin, kDefaultMargin);
}

+ (void)setWindowMargin:(CGSize)margin
{
    kWindowMarginSize = margin;
}

+ (MTPopupWindow*)showWindowWithView:(UIView*)newView
{
    UIView* view = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    return [self showWindow:newView insideView:view];
}

+ (MTPopupWindow*)showWindow:(UIView*)newView insideView:(UIView*)view
{
    if ([UIApplication sharedApplication].statusBarHidden==NO) {
        [self setWindowMargin:CGSizeMake(kWindowMarginSize.width,50)];
    }
    
    MTPopupWindow* popup = [[MTPopupWindow alloc] initWithView:newView];
    if ([popup respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]) {
        [popup setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    [popup showInView:view];
    return popup;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithView:(UIView*)nView
{
    self = [super init];
    if (self) {
        self.selectedView = nView;
    }
    return self;
}

- (void)show
{
    UIView* view = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    [self showInView:view];
}

- (void)showInView:(UIView*)v //EDIT
{
    _dimView = [[UIView alloc] init];
    [v addSubview:_dimView];
    [_dimView layoutMaximizeInView:v withInset:0];
    
    _bgView = [[UIView alloc] init];
    [v addSubview:_bgView];
    [_bgView layoutMaximizeInView:v withInset:0];
    
    CGRect newFrame = CGRectMake(0,20,v.frame.size.width-20,v.frame.size.height-80);
    self.selectedView.frame = newFrame;
    [self addSubview:self.selectedView];
    
    MTPopupWindowCloseButton* btnClose = [MTPopupWindowCloseButton buttonInView:self];
    [btnClose addTarget:self action:@selector(closePopupWindow) forControlEvents:UIControlEventTouchUpInside];

    [self performSelector:@selector(animatePopup:) withObject:v afterDelay:0.01];
}

- (void)animatePopup:(UIView*)v
{
    UIView* fauxView = [[UIView alloc] init];
    fauxView.backgroundColor = [UIColor redColor];
    [_bgView addSubview:fauxView];
    [fauxView layoutMaximizeInView:_bgView withInset:kDefaultMargin];

    UIViewAnimationOptions options =
        UIViewAnimationOptionTransitionFlipFromRight |
        UIViewAnimationOptionAllowUserInteraction    |
        UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView transitionWithView:_bgView duration:.4 options:options animations:^{
        [fauxView removeFromSuperview];
        [_bgView addSubview:self];
        [self layoutMaximizeInView:_bgView withInsetSize:kWindowMarginSize];
        _dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closePopupWindow
{
    UIViewAnimationOptions options =
        UIViewAnimationOptionTransitionFlipFromLeft |
        UIViewAnimationOptionAllowUserInteraction   |
        UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView transitionWithView:_bgView duration:.4 options:options animations:^{
        _dimView.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
                        
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        _bgView = nil;
        
        [_dimView removeFromSuperview];
        _dimView = nil;
    }];
}

- (void)setupUI
{
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = 15.0;
    self.backgroundColor = [UIColor whiteColor];
}

@end


@implementation MTPopupWindowCloseButton
+ (id)buttonInView:(UIView*)v
{
    int closeBtnOffset = 5;
    MTPopupWindowCloseButton* closeBtn = [MTPopupWindowCloseButton buttonWithType:UIButtonTypeCustom];
    if ([closeBtn respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]) {
        closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [v addSubview:closeBtn];
    NSLayoutConstraint* rightc = [NSLayoutConstraint constraintWithItem: closeBtn
                                                              attribute: NSLayoutAttributeRight
                                                              relatedBy: NSLayoutRelationEqual
                                                                 toItem: v
                                                              attribute: NSLayoutAttributeRight
                                                             multiplier: 1.0f
                                                               constant: -closeBtnOffset];
    NSLayoutConstraint* topc = [NSLayoutConstraint constraintWithItem: closeBtn
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: v
                                                            attribute: NSLayoutAttributeTop
                                                           multiplier: 0.0f
                                                             constant: closeBtnOffset];
    NSLayoutConstraint* wwidth = [NSLayoutConstraint constraintWithItem: closeBtn
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy: NSLayoutRelationEqual
                                                                 toItem: v
                                                              attribute: NSLayoutAttributeWidth
                                                             multiplier: 0.0f
                                                               constant: kCloseBtnDiameter];
    NSLayoutConstraint* hheight = [NSLayoutConstraint constraintWithItem: closeBtn
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeHeight
                                                              multiplier: 0.0f
                                                                constant: kCloseBtnDiameter];
    //replace the automatically created constraints
    [v replaceConstraint:topc];
    [v replaceConstraint:rightc];
    [v replaceConstraint:wwidth];
    [v replaceConstraint:hheight];
    
    return closeBtn;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextAddEllipseInRect(ctx, CGRectOffset(rect, 0, 0));
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] CGColor]));
    CGContextFillPath(ctx);

    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 1, 1));
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] CGColor]));
    CGContextFillPath(ctx);

    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 4, 4));
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]));
    CGContextFillPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextMoveToPoint(ctx, kCloseBtnDiameter/4+1,kCloseBtnDiameter/4+1);
    CGContextAddLineToPoint(ctx, kCloseBtnDiameter/4*3+1,kCloseBtnDiameter/4*3+1);
    CGContextStrokePath(ctx);

    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextMoveToPoint(ctx, kCloseBtnDiameter/4*3+1,kCloseBtnDiameter/4+1);
    CGContextAddLineToPoint(ctx, kCloseBtnDiameter/4+1,kCloseBtnDiameter/4*3+1);
    CGContextStrokePath(ctx);
}
@end

@implementation UIView(MTPopupWindowLayoutShortcuts)
- (void)replaceConstraint:(NSLayoutConstraint*)c
{
    for (int i=0;i<[self.constraints count];i++) {
        NSLayoutConstraint* c1 = self.constraints[i];
        if (c1.firstItem==c.firstItem && c1.firstAttribute == c.firstAttribute) {
            [self removeConstraint:c1];
        }
    }
    [self addConstraint:c];
}
- (void)layoutCenterInView:(UIView*)v
{
    if ([self respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem: self
                                                               attribute: NSLayoutAttributeCenterX
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeCenterX
                                                              multiplier: 1.0f
                                                                constant: 0.0f];
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem: self
                                                               attribute: NSLayoutAttributeCenterY
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeCenterY
                                                              multiplier: 1.0f
                                                                constant: 0.0f];
    [v replaceConstraint:centerX];
    [v replaceConstraint:centerY];
    [v setNeedsLayout];
}
- (void)layoutInView:(UIView*)v setSize:(CGSize)s
{
    if ([self respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* wwidth = [NSLayoutConstraint constraintWithItem: self
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy: NSLayoutRelationEqual
                                                                 toItem: v
                                                              attribute: NSLayoutAttributeWidth
                                                             multiplier: 0.0f
                                                               constant: s.width];
    NSLayoutConstraint* hheight = [NSLayoutConstraint constraintWithItem: self
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeHeight
                                                              multiplier: 0.0f
                                                                constant: s.height];
    [v replaceConstraint: wwidth];
    [v replaceConstraint: hheight];
    [v setNeedsLayout];
}
- (void)layoutMaximizeInView:(UIView*)v withInset:(float)inset
{
    [self layoutMaximizeInView:v withInsetSize:CGSizeMake(inset,inset)];
}
- (void)layoutMaximizeInView:(UIView*)v withInsetSize:(CGSize)insetSize
{
    if ([self respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem: self
                                                               attribute: NSLayoutAttributeCenterX
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeCenterX
                                                              multiplier: 1.0f
                                                                constant: 0.0f];
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem: self
                                                               attribute: NSLayoutAttributeCenterY
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeCenterY
                                                              multiplier: 1.0f
                                                                constant: 0.0f];
    NSLayoutConstraint* wwidth = [NSLayoutConstraint constraintWithItem: self
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy: NSLayoutRelationEqual
                                                                 toItem: v
                                                              attribute: NSLayoutAttributeWidth
                                                             multiplier: 1.0f
                                                               constant: -insetSize.width];
    NSLayoutConstraint* hheight = [NSLayoutConstraint constraintWithItem: self
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: v
                                                               attribute: NSLayoutAttributeHeight
                                                              multiplier: 1.0f
                                                                constant: -insetSize.height];
    [v replaceConstraint: centerX];
    [v replaceConstraint: centerY];
    [v replaceConstraint: wwidth];
    [v replaceConstraint: hheight];
    
    [v setNeedsLayout];
}
@end
