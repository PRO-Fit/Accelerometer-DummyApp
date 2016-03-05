//
//  AppDelegate.h
//  AccelerometerDemo
//
//  Created by Arthur Knopper on 1/29/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) IBOutlet UILabel *xAxis;
@property (nonatomic, strong) IBOutlet UILabel *yAxis;
@property (nonatomic, strong) IBOutlet UILabel *zAxis;

@end
