//
//  JCETitleView.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "JCETitleView.h"
#import "JCEViewUtils.h"
#import "NSString+JCEAdditions.h"

static CGFloat const kTitleLabelFontSize = 12;

@implementation JCETitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_initSubviews];
    }
    return self;
}

- (void)p_initSubviews {
    _titleLabel = [JCEViewUtils labelWithFont:[UIFont systemFontOfSize:kTitleLabelFontSize] textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor] setAutoResizingMask:NO multipleLines:NO];
    [self addSubview:_titleLabel];
}

#pragma mark - Layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize viewSize = self.frame.size;
    CGSize titleLabelSize = [_titleLabel.text suggestedSizeWithFont:_titleLabel.font width:viewSize.width];
    CGFloat yOffset = (viewSize.height - titleLabelSize.height)/2;
    CGFloat xOffset = (viewSize.width - titleLabelSize.width)/2;
    _titleLabel.frame = CGRectMake(xOffset, yOffset, viewSize.width, titleLabelSize.height);
}

@end
