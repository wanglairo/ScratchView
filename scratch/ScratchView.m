//
//  DDPaySuccessScratchView.m
//  ddycPayComponent
//
//  Created by Alai on 2016/11/25.
//  Copyright © 2016年 xiaoka. All rights reserved.
//

#import "ScratchView.h"

static double _clearProportion = 0.45;
static int _clearPenHeight = 25;

@interface ScratchView ()

@property (nonatomic,assign)BOOL isEnbale;

@property (nonatomic,assign)CGFloat currentEraseAcreage;

@property (nonatomic,assign)CGFloat eliminateImageViewAcreage;

@property (nonatomic,strong)UIImageView *eliminateImageView;

@end

@implementation ScratchView

- (instancetype)init
{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"pay_paysuccess_scratchdiscountopenbackground"];
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:backgroundImageView];
    
    self.eliminateImageView = [[UIImageView alloc] init];
    self.eliminateImageView.image = [UIImage imageNamed:@"pay_paysuccess_scratchdiscountclosebackground"];
    self.eliminateImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.eliminateImageView];
    
    NSMutableDictionary *viewDic = [NSMutableDictionary dictionary];
    [viewDic setObject:backgroundImageView forKey:@"backgroundImageView"];
    [viewDic setObject:self.eliminateImageView forKey:@"eliminateImageView"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundImageView]-0-|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundImageView]-0-|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[eliminateImageView]-0-|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[eliminateImageView]-0-|" options:0 metrics:nil views:viewDic]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.eliminateImageViewAcreage = CGRectGetWidth(self.eliminateImageView.bounds) * CGRectGetHeight(self.eliminateImageView.bounds);
}

- (void)clearEliminateView
{
    self.currentEraseAcreage = 0.0;
    [self clearViewWithCurrentPoint:CGPointMake(0, 0) andPreviousPoint:CGPointMake(0, 0) andIsclearAllRegion:YES];
}

- (void)againCoverEliminateView
{
    self.currentEraseAcreage = 0.0;
    self.eliminateImageView.image = [UIImage imageNamed:@"pay_paysuccess_scratchdiscountclosebackground"];
}

#pragma mark - 刮奖处理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _isEnbale = YES;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if(_isEnbale)
    {
        CGPoint currentPoint = [touch locationInView:self.eliminateImageView];
        CGPoint previousPoint = [touch previousLocationInView:self.eliminateImageView];
        NSLog(@"currentPoint X = %f Y = %f",currentPoint.x,currentPoint.y);
        if ([self transparentWithPonit:currentPoint]) {//没擦除&不透明
            [self clearViewWithCurrentPoint:currentPoint andPreviousPoint:previousPoint andIsclearAllRegion:NO];
            CGFloat clearPercentage = self.currentEraseAcreage / self.eliminateImageViewAcreage;
            if (clearPercentage >= (_clearProportion)) {//擦除比例达到
                if (self.delegate && [self.delegate respondsToSelector:@selector(clearEndWithPaySuccessScratchView:)]) {
                    [self.delegate clearEndWithPaySuccessScratchView:self];
                }
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _isEnbale = NO;
}

- (void)clearViewWithCurrentPoint:(CGPoint)currentPoint andPreviousPoint:(CGPoint)previousPoint andIsclearAllRegion:(BOOL)clearAllRegion
{
    float dis = [self distanceFromPointX:previousPoint distanceToPointY:currentPoint];
    self.currentEraseAcreage = self.currentEraseAcreage + (dis * _clearPenHeight);
    
    //解决精度丢失导致画布尺寸不对
    double scratchViewHeight = round(CGRectGetHeight(self.bounds));
    CGRect bounds = self.bounds;
    bounds.size.height = scratchViewHeight;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    [self.eliminateImageView.image drawInRect:bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (clearAllRegion) {
        CGContextClearRect(context, self.eliminateImageView.bounds);
    }else{
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context,_clearPenHeight);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        
        CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        CGContextStrokePath(context);
    }
    
    self.eliminateImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (BOOL)transparentWithPonit:(CGPoint)point
{
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 1, NULL,
                                                 kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [self.eliminateImageView.image drawAtPoint:CGPointMake(-point.x, -point.y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0f;
    BOOL transparent = alpha < 0.01f;
    
    return !transparent;
}

-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

@end
