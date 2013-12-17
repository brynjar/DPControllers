//
//  DPNiftyProgressBar.m
//  Slidey
//
//  Created by Govi on 22/07/2013.
//  Copyright (c) 2013 DP. All rights reserved.
//

#import "DPNiftyProgressBar.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+GradientOffset.h"

const float BARSIZE = 5.0;

@implementation DPNiftyProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        gutterView = [[RectFillerView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - BARSIZE, self.frame.size.width - 10, BARSIZE)];
        gutterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        gutterView.color = [UIColor lightGrayColor];
        gutterView.layer.cornerRadius = BARSIZE;
        gutterView.clipsToBounds = YES;
        gutterView.layer.shadowColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5].CGColor;
        gutterView.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        gutterView.layer.shadowRadius = 3.0;
        [self addSubview:gutterView];
        
        progressView = [[RectFillerView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - BARSIZE, 0, BARSIZE)];
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        progressView.layer.cornerRadius = BARSIZE;
        progressView.clipsToBounds = YES;
        [self addSubview:progressView];
        
        rulerView = [[DPNiftyRulerView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - BARSIZE - 1, self.frame.size.width - 10, BARSIZE + 1)];
        rulerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        rulerView.sectionPoints = self.sectionPoints;
        [self addSubview:rulerView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 90.0, 0, 80.0, self.frame.size.height - BARSIZE - 2)];
        [self addSubview:label];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:10.0];
        label.highlightedTextColor = [UIColor blackColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.lineColor = [UIColor blackColor];
        self.progressColor = [UIColor blueColor];
        self.numberOfSections = 3;
        self.progressColorType = DPNiftyProgressColorTypeSolid;
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    rulerView.lineColor = lineColor;
    label.textColor = lineColor;
}

-(void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    progressView.color = progressColor;
}

-(void)setNumberOfSections:(NSInteger)numberOfSections {
    _numberOfSections = numberOfSections;
    rulerView.numberOfSections = numberOfSections;
}

-(void)setFromProgressColor:(UIColor *)fromProgressColor {
    _fromProgressColor = fromProgressColor;
    [self setProgress:self.progress];
}

-(void)setToProgressColor:(UIColor *)toProgressColor {
    _toProgressColor = toProgressColor;
    [self setProgress:self.progress];
}

-(void)setThresholdColors:(NSArray *)thresholdColors {
    if(thresholdColors) {
        if([thresholdColors count] == self.numberOfSections) {
            NSArray *item = @[[UIColor blackColor]];
            _thresholdColors = [item arrayByAddingObjectsFromArray:thresholdColors];
        } else if([thresholdColors count] == self.numberOfSections + 1) {
            _thresholdColors = thresholdColors;
        }
    }
}

-(void)setProgress:(float)progress {
    _progress = progress;
    if(progress > 0) {
        if(progress == 1.0)
            label.text = [NSString stringWithFormat:@"%0.1f%% (%0.0f)", progress*100.0, self.points];
        else
            label.text = [NSString stringWithFormat:@"%0.1f%%", progress*100.0];
    }
    else if(self.points > 0)
        label.text = [NSString stringWithFormat:@"%0.0f", self.points];
    else
        label.text = @" ➖ ";
    int count = 0;
    float offset = 0;
    float lastP = 0;
    while (count < [self.sectionPoints count]){
        float val = [[self.sectionPoints objectAtIndex:count] intValue]/[[self.sectionPoints lastObject] floatValue];
        if (progress>=val) {
            count++;
        } else {
            offset = progress - lastP;
            break;
        }
        lastP = val;
    }
    
    if(self.thresholdColors && [self.thresholdColors count] == (self.numberOfSections + 1)) {
        if(self.progressColorType == DPNiftyProgressColorTypeRGBGradient && count < self.numberOfSections)
            progressView.color = [UIColor RGBColorBetween:[self.thresholdColors objectAtIndex:count] and:[self.thresholdColors objectAtIndex:count+1] withOffset:offset];
        else if(self.progressColorType == DPNiftyProgressColorTypeHSVGradient && count < self.numberOfSections)
            progressView.color = [UIColor HSVColorBetween:[self.thresholdColors objectAtIndex:count] and:[self.thresholdColors objectAtIndex:count+1] withOffset:offset];
        else
            progressView.color = [self.thresholdColors objectAtIndex:count];
    }
    else if(self.toProgressColor && self.fromProgressColor) {
        if(self.progressColorType == DPNiftyProgressColorTypeRGBGradient)
            progressView.color = [UIColor RGBColorBetween:self.fromProgressColor and:self.toProgressColor withOffset:progress];
        else if(self.progressColorType == DPNiftyProgressColorTypeHSVGradient)
            progressView.color = [UIColor HSVColorBetween:self.fromProgressColor and:self.toProgressColor withOffset:progress];
    }
    label.textColor = [UIColor darkGrayColor];
    
    [UIView beginAnimations:@"progress animations" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:0.4];
    progressView.frame = CGRectMake(5, self.frame.size.height - BARSIZE, (self.frame.size.width - 10)* progress, BARSIZE);
    [UIView commitAnimations];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setProgress:self.progress];
}

-(UIColor *)color {
    return progressView.color;
}

-(void)setSectionPoints:(NSArray *)sectionPoints {
    _sectionPoints = sectionPoints;
    rulerView.sectionPoints = sectionPoints;
}

@end


@implementation DPNiftyRulerView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    [self.lineColor setStroke];
    float resolution = self.frame.size.width / self.numberOfSections;
    float x = resolution;
    for(int i=0;i<self.numberOfSections-1;i++) {
        if(self.sectionPoints && [self.sectionPoints count] == self.numberOfSections) {
            x = ([[self.sectionPoints objectAtIndex:i] intValue]/[[self.sectionPoints lastObject] floatValue])*self.frame.size.width;
        }
        CGContextStrokeRect(c, CGRectMake(x, 0, 0.5, self.frame.size.height));
        x += resolution;
    }
    CGContextRestoreGState(c);
}

@end

@implementation RectFillerView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    [self.color setFill];
    CGContextFillRect(c, self.bounds);
    CGContextRestoreGState(c);
}

@end
