//
//  ViewController.m
//  JCECircularCollectionViewExample
//
//  Created by Jai Chaudhry on 11/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "ViewController.h"
#import <JCECircularCollectionViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArray = @[@"First", @"Second", @"Third", @"Fourth"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 100)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    label.text = @"First";
    [vc1.view addSubview:label];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor yellowColor];
    label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 100)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"Second";
    [vc2.view addSubview:label];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor blueColor];
    label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 100)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"Third";
    [vc3.view addSubview:label];
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor cyanColor];
    label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 100)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"Fourth";
    [vc4.view addSubview:label];
    
    JCECircularCollectionViewController *circularCollectionViewController = [[JCECircularCollectionViewController alloc] initWithTitleArray:titleArray dataViewControllers:@[vc1, vc2, vc3, vc4]];
    circularCollectionViewController.showArrow = YES;
    circularCollectionViewController.arrowColor = [UIColor whiteColor];
    [self.navigationController pushViewController:circularCollectionViewController animated:NO];
//    [self.navigationController presentViewController:circularCollectionViewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
