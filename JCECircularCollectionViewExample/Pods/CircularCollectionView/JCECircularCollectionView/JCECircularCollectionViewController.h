//
//  JCECircularCollectionViewController.h
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCECircularCollectionViewController;

@protocol JCECircularCollectionViewControllerDataSource <NSObject>

@required

/**
 * The object that provides the data for the collection view.
 */
- (NSInteger)numberOfItems;

/**
 * The titles corresponding to the view controllers to be presented. These will be shown in a scroll view.
 */
- (NSString *)circularCollectionViewController:(JCECircularCollectionViewController *)circularCollectionViewController titleForItemAtIndex:(NSInteger)index;

/**
 * The view controllers whose views are to be presented in the circular collection view.
 */
- (UIViewController *)circularCollectionViewController:(JCECircularCollectionViewController *)circularCollectionViewController viewControllerForItemAtIndex:(NSInteger)index;

@end

@interface JCECircularCollectionViewController : UIViewController

/**
 * The object that provides the data for the collection view.
 */
@property (nonatomic, weak) id <JCECircularCollectionViewControllerDataSource> datasource;

/**
 *  This can be used to show the arrow for the selected controller.
 */
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, strong) UIColor *arrowColor;

@end
