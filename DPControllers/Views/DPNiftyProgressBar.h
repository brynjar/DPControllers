//
//  DPNiftyProgressBar.h
//  Slidey
//
//  Created by Govi on 22/07/2013.
//  Copyright (c) 2013 DP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DPNiftyProgressColorTypeSolid,
    DPNiftyProgressColorTypeRGBGradient,
    DPNiftyProgressColorTypeHSVGradient
} DPNiftyProgressColorType;

@class DPNiftyRulerView;
@class RectFillerView;

@interface DPNiftyProgressBar : UIView {
    RectFillerView *gutterView;
    RectFillerView *progressView;
    DPNiftyRulerView *rulerView;
    UILabel *label;
}

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *fromProgressColor;
@property (nonatomic, strong) UIColor *toProgressColor;
@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) float progress;
@property (nonatomic) float points;
@property (nonatomic) DPNiftyProgressColorType progressColorType;
@property (nonatomic, strong) NSArray *thresholdColors;
@property (nonatomic, strong) NSArray *sectionPoints;

-(UIColor *)color;

@end

@interface DPNiftyRulerView : UIView {
    
}

@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic, strong) NSArray *sectionPoints;
@property (nonatomic, strong) UIColor *lineColor;

@end

@interface RectFillerView : UIView

@property (nonatomic, strong) UIColor *color;

@end