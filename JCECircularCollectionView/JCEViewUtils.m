//
//  JCEViewUtils.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "JCEViewUtils.h"

@implementation JCEViewUtils

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor backGroundColor:(UIColor *)backGroundColor setAutoResizingMask:(BOOL)setAutoResizingMask multipleLines:(BOOL)showMultipleLine {
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    if (setAutoResizingMask) {
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    if (showMultipleLine) {
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
    }
    label.backgroundColor = backGroundColor;
    return label;
}

@end
