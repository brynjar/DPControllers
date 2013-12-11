//
//  ScrollableViewCell.m
//  EventGenie
//
//  Created by Govi Ram on 27/03/2012.
//  Copyright (c) 2012 GenieMobile. All rights reserved.
//

#import "DPScrollableViewCell.h"
#import "NSString+UI.h"

@implementation DPScrollableViewCell
@synthesize image, title, style, textColor, selected;
@synthesize selectedTextColor, selectedFont, highlighted, highlightedTextColor, highlightedBackgroundColor;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        selectedFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        normalFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        highlightedFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.textColor = [UIColor lightGrayColor];
        self.highlightedTextColor = [UIColor orangeColor];
        self.selectedTextColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    float lineHt = [UIFont systemFontSize];
    BOOL hasText = title && [title length] > 0;
    if (image)
    {
        if (hasText)
        {
            if ( frame.size.height > (3 * lineHt) )
            {
                style = ScrollableViewStyleImageWithCaption;
            }
            else
            {
                style = ScrollableViewStyleTrailingText;
            }
        }
        else
        {
            style = ScrollableViewStyleImageOnly;
        }
    }
    else
    {
        style = ScrollableViewStyleTextOnly;
    }
    
    switch (style)
    {
        case ScrollableViewStyleTextOnly:
            textRect = CGRectMake(3, 0, self.frame.size.width - 6, self.frame.size.height);
            break;
        case ScrollableViewStyleImageOnly:
            imageRect = self.bounds;
            break;
        case ScrollableViewStyleTrailingText:
            imageRect = CGRectMake(3, self.frame.size.height - 18, 15, 15);
            textRect = CGRectMake(21, 0, self.frame.size.width - 21, self.frame.size.height);
            break;
        case ScrollableViewStyleImageWithCaption:
            imageRect = CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.height - 21);
            textRect = CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 18);
            break;
        default:
            break;
    } /* switch */
}


- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIFont *font = normalFont;
    UIColor *color = textColor;
    if (highlighted)
    {
        font = highlightedFont;
        if (highlightedTextColor)
        {
            color = highlightedTextColor;
        }
        
        if (highlightedBackgroundColor)
        {
            [highlightedBackgroundColor setFill];
            CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
        }
    }
    
    if (selected)
    {
        font = selectedFont;
        if (selectedTextColor)
        {
            color = selectedTextColor;
        }
    }
    
    if (color)
    {
        [color setFill];
    }
    
    switch (style)
    {
        case ScrollableViewStyleImageWithCaption:
            [image drawInRect:imageRect];
            [title drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            break;
        case ScrollableViewStyleTrailingText:
            [image drawInRect:imageRect];
            [title drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeTailTruncation];
            break;
        case ScrollableViewStyleTextOnly:
            [title drawCenteredInRect:textRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
            break;
        case ScrollableViewStyleImageOnly:
            [image drawInRect:imageRect];
            break;
        default:
            break;
    } /* switch */
    
    if(self.separatorColor)
    {
        CGContextSaveGState(context);
        [self.separatorColor setFill];
        CGContextFillRect(context, CGRectMake(self.bounds.size.width-0.5, 0, 0.5, self.bounds.size.height));
        CGContextFillRect(context, CGRectMake(0, 0, 0.5, self.bounds.size.height));
        CGContextRestoreGState(context);
    }
}




@end
