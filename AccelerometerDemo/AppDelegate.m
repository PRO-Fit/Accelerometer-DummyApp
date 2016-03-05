//
//  AppDelegate.m
//  AccelerometerDemo
//
//  Created by Arthur Knopper on 1/29/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[self.viewController viewDidLoad];
    
    self.xAxis.text = @"bla";
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = 0.05;
    NSLog(@"I'm running in BG");
//    if ([self.motionManager isAccelerometerAvailable])// & [self.motionManager isAccelerometerActive])
//    {
    static NSString * const BaseURLString = @"http://54.67.63.89:8000/api/insert/batch";

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    while (true) {
        
    [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
     
     {
         NSMutableDictionary *userAccelData = [[NSMutableDictionary alloc] init];
         NSMutableArray *accelArray = [[NSMutableArray alloc] init];
         NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
         
         [userAccelData setObject:[NSNumber numberWithDouble: accelerometerData.acceleration.x] forKey:@"x"];
         [userAccelData setObject:[NSNumber numberWithDouble: accelerometerData.acceleration.y] forKey:@"y"];
         [userAccelData setObject:[NSNumber numberWithDouble: accelerometerData.acceleration.z] forKey:@"z"];
         [userAccelData setObject:[NSNumber numberWithDouble:timeInMiliseconds] forKey:@"timestamp"];
         
         UIDevice *device = [UIDevice currentDevice];
         NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
         NSLog(@"%@",uniqueIdentifier);
         NSLog(@"%@",device);
         
         [userAccelData setObject:[NSString stringWithString: uniqueIdentifier] forKey:@"user_id"];
         
         
         [accelArray addObject: userAccelData];
         NSLog(@"Before 5 - CALL : %@", accelArray);

         
         
         if ((int)timeInMiliseconds % 5 == 0) {
             NSLog(@"inside REST call");
             //NSLog(@"%@", accelArray);
             
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:accelArray options:0 error:nil];
             if (!jsonData) {
                 NSLog(@"Failed to create JSON data");
             }
             
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseURLString]];
             
             [request setHTTPMethod:@"POST"];
             [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
             [request setHTTPBody:jsonData];
             
             AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
             op.responseSerializer = [AFJSONResponseSerializer serializer];
             [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSLog(@"JSON responseObject: %@ ",responseObject);
                 accelArray.removeAllObjects;
                 userAccelData.removeAllObjects;
                 __block NSMutableArray *accelArray = NULL;
                 __block NSMutableDictionary *userAccelData = NULL;
                 __block jsonData = NULL;
                 
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", [error localizedDescription]);
                 
             }];
             
             [op start];
             accelArray.removeAllObjects;
             userAccelData.removeAllObjects;
             jsonData = NULL;
             NSLog(@"After CALL : %@", accelArray);
             
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             self.xAxis.text = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.x];
             self.yAxis.text = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.y];
             self.zAxis.text = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.z];
         });
     }];
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
