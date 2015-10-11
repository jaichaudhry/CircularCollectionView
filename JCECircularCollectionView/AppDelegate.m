//
//  AppDelegate.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "AppDelegate.h"
#import "JCECircularCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
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
    JCECircularCollectionViewController *circularCollectionViewController = [[JCECircularCollectionViewController alloc] initWithTitleArray:titleArray andDataViewControllers:@[vc1, vc2, vc3, vc4]];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:circularCollectionViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = circularCollectionViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
