//
//  JCEBorderLayer.h
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 11/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCEArrowDirection) {
    JCEArrowDirectionUp,
    JCEArrowDirectionDown
};

@interface JCEBorderLayer : CALayer {
    CAShapeLayer *borderLayer;
}

@property (nonatomic, strong) UIColor *arrowFillColor;
@property (nonatomic, strong) UIColor *arrowBorderColor;
@property (nonatomic, assign) CGFloat arrowBorderWidth;
@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, assign) JCEArrowDirection arrowDirection;
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, assign) CGFloat arrowHeight;
@property (nonatomic, assign) BOOL showArrow;

- (void)showArrowAtPoint:(CGPoint)point;

@end
