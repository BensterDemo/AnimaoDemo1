//
//  ViewController.m
//  AnimaoDemo1
//
//  Created by Benster on 15/4/2.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "ViewController.h"
#import "Waver.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _circleChart = [[CCProgressView alloc] initWithFrame:CGRectMake(30, 100, 300, 300)];
    _circleChart.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_circleChart];
    
    [self batteryLevel];
    [self startGravity];
    
    currentTransform = _circleChart.transform;

//    self.view.backgroundColor = [UIColor grayColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self drawInContext:context];
    
    [self drawWater];
}

- (double)batteryLevel
{
    double percent = 50;
    [_circleChart setProgress:percent/100 animated:YES];
    
    return 10;
}

- (void)startGravity
{
    if (self.motionDisplayLink == nil) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.1;// 0.02; // 50 Hz
        
        self.motionLastYaw = 0;
        
        _theTimer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(motionRefresh:) userInfo:nil repeats:YES];
    }
    if ([self.motionManager isDeviceMotionAvailable]) {
        
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    }
}

- (void)motionRefresh:(id)sender
{
    CMQuaternion quat = self.motionManager.deviceMotion.attitude.quaternion;
    double yaw = asin(2*(quat.x*quat.z - quat.w*quat.y));
    
    yaw *= -1;
    
    if (self.motionLastYaw == 0) {
        self.motionLastYaw = yaw;
    }
    
    static float q = 0.1;   // process noise
    static float s = 0.1;   // sensor noise
    static float p = 0.1;   // estimated error
    static float k = 0.5;   // kalman filter gain
    
    float x = self.motionLastYaw;
    p = p + q;
    k = p / (p + s);
    x = x + k*(yaw - x);
    p = (1 - k)*p;
    
    newTransform = CGAffineTransformRotate(currentTransform, -x);
    _circleChart.transform = newTransform;
    
    self.motionLastYaw = x;
}

- (void)drawWater
{
    self.view.backgroundColor = [UIColor grayColor];
    Waver * waver = [[Waver alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)/2.0 - 50.0, CGRectGetWidth(self.view.bounds), 100.0)];
    
   	__weak Waver * weakWaver = waver;
   	waver.waverLevelCallback = ^() {
   	    weakWaver.level = 0.2;
   	};
   	[self.view addSubview:waver];
}

@end
