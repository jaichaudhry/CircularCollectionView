//
//  JCEBorderLayer.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 11/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "JCEBorderLayer.h"

@implementation JCEBorderLayer

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Initialize defaults
    _arrowBorderWidth = 1.0/[UIScreen mainScreen].scale;
    _arrowBorderColor = [UIColor lightGrayColor];
    _arrowFillColor = [UIColor clearColor];
    _arrowDirection = JCEArrowDirectionDown;
    _arrowWidth = 24;
    _arrowHeight = 10;
    _showArrow = YES;
    _arrowPoint = CGPointMake(0, self.bounds.origin.y + self.bounds.size.height);
}

// We need the borderLayer to always be the top most layer, so each time the subLayers positioning change, we place the borderLayer at the top.
- (void)layoutSublayers {
    [super layoutSublayers];
    [self reloadBorders];
    // Move the borders to the top
    borderLayer.zPosition = self.sublayers.count;
}

- (void)setArrowFillColor:(UIColor *)arrowFillColor {
    _arrowFillColor = arrowFillColor;
    borderLayer.fillColor = _arrowFillColor.CGColor;
}

- (void)setArrowBorderColor:(UIColor *)arrowBorderColor {
    _arrowBorderColor = arrowBorderColor;
    borderLayer.strokeColor = arrowBorderColor.CGColor;
}

- (void)setArrowBorderWidth:(CGFloat)arrowBorderWidth {
    _arrowBorderWidth = arrowBorderWidth;
    borderLayer.lineWidth = _arrowBorderWidth;
}

- (void)setArrowPoint:(CGPoint)arrowPoint {
    [self initializeBorderLayer];
    _arrowPoint = arrowPoint;
    [self reloadBorders];
}

- (void)setShowArrow:(BOOL)showArrow {
    if (_showArrow != showArrow) {
        _showArrow = showArrow;
        [self reloadBorders];
    }
}

- (void)showArrowAtPoint:(CGPoint)point {
    [self initializeBorderLayer];
    _arrowPoint = point;
    _showArrow = YES;
    [self reloadBorders];
}

- (void)initializeBorderLayer {
    // Lazily create the border layer only if setting the selective borders property
    if (!borderLayer) {
        borderLayer = [[CAShapeLayer alloc] init];
        [self addSublayer:borderLayer];
    }
}


#pragma mark -
#pragma mark Drawing

- (void)reloadBorders {
    if (!borderLayer)
        return;
    
    UIBezierPath *path = [self bezierPathWithArrowDownAtPoint:self.arrowPoint];
    borderLayer.fillColor = self.arrowFillColor.CGColor;
    
    borderLayer.frame = self.bounds;
    borderLayer.path = path.CGPath;
    
    borderLayer.strokeColor = self.arrowBorderColor.CGColor;
    borderLayer.lineWidth = self.arrowBorderWidth;
}

- (UIBezierPath *)bezierPathWithArrowDownAtPoint:(CGPoint)point {
    CGFloat yOffset = point.y;
    CGFloat xOffset = point.x;
    UIBezierPath *fillPath = [[UIBezierPath alloc] init];
    [fillPath moveToPoint:CGPointMake(0, yOffset)];
    if (self.showArrow) {
        [fillPath addLineToPoint:CGPointMake(xOffset - (_arrowWidth/2), yOffset)];
        CGFloat newYOffset = yOffset + _arrowHeight;
        if (self.arrowDirection == JCEArrowDirectionUp) {
            newYOffset = yOffset - _arrowHeight;
        }
        [fillPath addLineToPoint:CGPointMake(xOffset, newYOffset)];
        [fillPath addLineToPoint:CGPointMake(xOffset + (_arrowWidth/2), yOffset)];
    }
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, yOffset)];
    return fillPath;
}

@end
