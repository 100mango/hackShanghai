//
//  ViewController.m
//  hackShanghai
//
//  Created by Mango on 14/11/16.
//  Copyright (c) 2014年 Mango. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "JZLocationConverter.h"
#import "AFNetworking.h"

static const NSString *annotationReuseIdentifier = @"myAnnotation";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(31.279469, 121.49622299999999);
    CLLocationCoordinate2D realLocation = [JZLocationConverter wgs84ToGcj02:location];

    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.title = @"上海纽约大学";
    point.coordinate = realLocation;
    
    [self.mapView setRegion:MKCoordinateRegionMake(realLocation, MKCoordinateSpanMake(0.004, 0.004))];
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://121.40.93.149:9999/start" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserLocationFromPush:) name:@"updateLocation" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switch:(UISwitch *)sender
{
 
    if(sender.on == YES)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://121.40.93.149:9999/start" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    else
    {   
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://121.40.93.149:9999/stop" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
#pragma mark - handel notification
-(void)updateUserLocationFromPush:(NSNotification*)notification
{
    NSLog(@"%@",notification.userInfo);
    
    
    NSString *update = [NSString stringWithFormat:@"latitude update to %@ \n longitude update to %@",notification.userInfo[@"lat"],notification.userInfo[@"lng"]];
    
    self.updateLabel.text = update;
    
    CGFloat red = arc4random_uniform(255)/ 255.0;
    CGFloat green = arc4random_uniform(255)/ 255.0;
    CGFloat blue = arc4random_uniform(255)/ 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.updateLabel.textColor = color;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([notification.userInfo[@"lat"] doubleValue], [notification.userInfo[@"lng"] doubleValue]);
    CLLocationCoordinate2D realLocation = [JZLocationConverter wgs84ToGcj02:location];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.title = @"上海纽约大学";
    point.coordinate = realLocation;

    //[self.mapView setRegion:MKCoordinateRegionMake(realLocation, MKCoordinateSpanMake(0.01, 0.01))];
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
    
}

@end
