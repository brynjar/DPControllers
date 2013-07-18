//
//  ScrollableViewCell.h
//  EventGenie
//
//  Created by Govi Ram on 27/03/2012.
//  Copyright (c) 2012 GenieMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ScrollableViewStyleTrailingText,
    ScrollableViewStyleImageOnly,
    ScrollableViewStyleImageWithCaption,
    ScrollableViewStyleTextOnly
} ScrollableViewStyle;

@interface DPScrollableViewCell : UIView {
    UIImage *image;
    NSString *title;
    ScrollableViewStyle style;
    CGRect imageRect;
    CGRect textRect;
    BOOL selected;
    BOOL highlighted;
    UIColor *textColor;
    UIColor *selectedTextColor;
    UIColor *highlightedTextColor;
    UIFont *selectedFont;
    UIFont *normalFont;
    UIFont *highlightedFont;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) ScrollableViewStyle style;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL highlighted;

@end
