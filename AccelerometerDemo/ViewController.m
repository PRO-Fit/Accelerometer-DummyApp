//
//  ViewController.m
//  AccelerometerDemo
//
//  Created by Arthur Knopper on 1/29/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import "ViewController.h"
//#import "AppDelegate.m"

static NSString * const BaseURLString = @"http://54.67.63.89:8000/api/insert/batch";


@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) IBOutlet UILabel *xAxis;
@property (nonatomic, strong) IBOutlet UILabel *yAxis;
@property (nonatomic, strong) IBOutlet UILabel *zAxis;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    appDelegate.viewController = self;
    
    self.xAxis.text = @"bla";
   
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = 0.05;
    
    if ([self.motionManager isAccelerometerAvailable])// & [self.motionManager isAccelerometerActive])
    {
        NSLog(@"Accelerometer is active and available");
        NSMutableArray *accelArray = [[NSMutableArray alloc] init];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
        
        {
          
//            NSDate *date = [[NSDate alloc] init];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS.SSS"];
//            NSString *localDateString = [dateFormatter stringFromDate:date];
//
            NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
            
            NSLog(@"X = %0.4f, Y = %.04f, Z = %.04f",
                  accelerometerData.acceleration.x,
                  accelerometerData.acceleration.y,
                  accelerometerData.acceleration.z);
            NSMutableDictionary *userAccelData = [[NSMutableDictionary alloc] init];
            
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
            
            //NSLog(@"%@", jsonData);
            
            
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
            
            //[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(sendAccelerometerData) userInfo: nil repeats: YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.xAxis.text = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.x];
                self.yAxis.text = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.y];
                self.zAxis.text = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.z];
            });
        }];
    }
    else
        NSLog(@"not active");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendAccelerometerData:(UIApplication *)application accelArray:(NSMutableArray *)accelArray
{

//    NSLog(@"inside method");
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:accelArray options:0 error:nil];
//    if (!jsonData) {
//        NSLog(@"Failed to create JSON data");
//    }
//    //NSLog(@"%@", jsonData);
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseURLString]];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:jsonData];
//    
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    op.responseSerializer = [AFJSONResponseSerializer serializer];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON responseObject: %@ ",responseObject);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", [error localizedDescription]);
//        
//    }];
//    [op start];
//    accelArray = Nil;
}



@end
