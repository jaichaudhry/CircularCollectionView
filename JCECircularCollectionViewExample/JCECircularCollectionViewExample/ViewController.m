//
//  ViewController.m
//  JCECircularCollectionViewExample
//
//  Created by Jai Chaudhry on 11/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "ViewController.h"
#import <JCECircularCollectionViewController.h>

@interface ViewController () <JCECircularCollectionViewControllerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JCECircularCollectionViewController *circularCollectionViewController = [[JCECircularCollectionViewController alloc] init];
    circularCollectionViewController.datasource = self;
    circularCollectionViewController.showArrow = YES;
    circularCollectionViewController.arrowColor = [UIColor whiteColor];
    [self.navigationController pushViewController:circularCollectionViewController animated:NO];
//    [self.navigationController presentViewController:circularCollectionViewController animated:NO completion:nil];
}

#pragma mark - JCECircularCollectionViewControllerDataSource methods

- (NSInteger)numberOfItems {
    return 4;
}

- (UIViewController *)circularCollectionViewController:(JCECircularCollectionViewController *)circularCollectionViewController viewControllerForItemAtIndex:(NSInteger)index {
    return [self p_viewControllerForIndex:index];
}

- (NSString *)circularCollectionViewController:(JCECircularCollectionViewController *)circularCollectionViewController titleForItemAtIndex:(NSInteger)index {
    return [self p_titleForIndex:index];
}

#pragma mark - Private methods

- (NSString *)p_titleForIndex:(NSInteger)index {
    NSArray *titleArray = @[@"First", @"Second", @"Third", @"Fourth"];
    return [titleArray objectAtIndex:index];
}

- (UIViewController *)p_viewControllerForIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 100)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [self p_colorForViewControllerAtIndex:index];
    label.text = [self p_titleForIndex:index];
    [vc.view addSubview:label];
    return vc;
}

- (UIColor *)p_colorForViewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor yellowColor];
        case 2:
            return [UIColor blueColor];
        case 3:
            return [UIColor greenColor];
        default:
            return [UIColor blackColor];
    }
}

@end
