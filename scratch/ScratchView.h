//
//  ScratchView
//  scratchdemo
//
//  Created by Alai on 16/9/19.
//  Copyright © 2016年 xiaoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScratchView;

@protocol ScratchViewDelegate <NSObject>

//擦除比例达到回调
- (void)clearEndWithPaySuccessScratchView:(ScratchView *)scratchView;

@end

@interface ScratchView : UIView

@property(nonatomic, weak) id<ScratchViewDelegate> delegate;

- (void)againCoverEliminateView;

- (void)clearEliminateView;

@end
