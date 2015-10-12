//
//  JCEViewUtils.h
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCEViewUtils : NSObject

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor backGroundColor:(UIColor *)backGroundColor setAutoResizingMask:(BOOL)setAutoResizingMask multipleLines:(BOOL)showMultipleLine;

@end
