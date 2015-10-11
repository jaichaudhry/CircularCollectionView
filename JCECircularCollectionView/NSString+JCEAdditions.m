//
//  NSString+JCEAdditions.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "NSString+JCEAdditions.h"

@implementation NSString(JCEAdditions)

- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width {
    return [self suggestedSizeWithFont:font width:width lineBreakMode:NSLineBreakByTruncatingTail];
}

- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self suggestedSizeWithFont:font size:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    CGRect bounds = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return bounds.size;
}

@end
