//
//  ViewController.h
//  AnimaoDemo1
//
//  Created by Benster on 15/4/2.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "CCProgressView.h"

@interface ViewController : UIViewController
{
    CGAffineTransform currentTransform;
    CGAffineTransform newTransform;
}

@property (nonatomic, strong)  NSTimer *theTimer;
@property (nonatomic, strong) CCProgressView * circleChart;

@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) CADisplayLink* motionDisplayLink;
@property (nonatomic, assign) float motionLastYaw;

@end

