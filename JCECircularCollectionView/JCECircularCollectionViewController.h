//
//  JCECircularCollectionViewController.h
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCECircularCollectionViewController : UIViewController

/**
 *  To initialize with title array and data views array.
 *  Note: The title array count must be equal to data views count.
 *
 *  @param titleArray          The titles corresponding to the view controllers to be presented. These will be shown in a scroll view.
 *  @param dataViewControllers The view controllers whose views are to be presented in the circular collection view.
 *
 */
- (instancetype)initWithTitleArray:(NSArray *)titleArray andDataViewControllers:(NSArray *)dataViewControllers;

@end
