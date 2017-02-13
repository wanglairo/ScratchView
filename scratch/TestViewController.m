//
//  TestViewController.m
//  scratch
//
//  Created by Alai on 2017/2/10.
//  Copyright © 2017年 xiaoka. All rights reserved.
//

#import "TestViewController.h"
#import "ScratchView.h"

@interface TestViewController ()<ScratchViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    ScratchView *scratchView = [[ScratchView alloc] init];
    scratchView.translatesAutoresizingMaskIntoConstraints = NO;
    scratchView.delegate = self;
    [self.view addSubview:scratchView];
    
    NSMutableDictionary *viewDic = [NSMutableDictionary dictionary];
    [viewDic setObject:scratchView forKey:@"scratchView"];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[scratchView]-10-|" options:0 metrics:nil views:viewDic]];
    NSLayoutConstraint *CenterYconstraint = [NSLayoutConstraint constraintWithItem:scratchView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0 constant:0];
    [self.view addConstraint:CenterYconstraint];
    NSLayoutConstraint *heightYconstraint = [NSLayoutConstraint constraintWithItem:scratchView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0 constant:200];
    [self.view addConstraint:heightYconstraint];
    
}

- (void)clearEndWithPaySuccessScratchView:(ScratchView *)scratchView
{
    NSLog(@"  擦除比例达到 ");
    
}

@end
