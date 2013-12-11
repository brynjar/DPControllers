//
//  ScrollableView.m
//  EventGenie
//
//  Created by Govi Ram on 27/03/2012.
//  Copyright (c) 2012 GenieMobile. All rights reserved.
//

#import "DPScrollableView.h"

@interface DPScrollableView ()

//-(UIView *)subviewAtPoint:(CGPoint)point;

@end

@implementation DPScrollableView
@synthesize pointerType, datasource, selectedIndex;
@synthesize leftPointer, centerPointer, rightPointer;
@synthesize textColor;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.pointerType = PointerTypeAppear;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.clipsToBounds = YES;
    }
    return self;
}


- (void) setPointerType:(PointerType)pType
{
    pointerType = pType;
    CGRect frame = self.frame;
    
    if (!leftPointer)
    {
        leftPointer = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 3.0, frame.size.height - 2.5, frame.size.width / 6.0, 2)];
        leftPointer.backgroundColor = [UIColor blueColor];
        [self addSubview:leftPointer];
        
        rightPointer = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, frame.size.height - 2.5, frame.size.width / 6.0, 2)];
        rightPointer.backgroundColor = [UIColor blueColor];
        [self addSubview:rightPointer];
        
        centerPointer = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 3.0, frame.size.height - 2.5, frame.size.width / 3.0, 2)];
        centerPointer.backgroundColor = [UIColor blueColor];
        [self addSubview:centerPointer];
    }
    else
    {
        leftPointer.frame = CGRectMake(frame.size.width / 3.0, frame.size.height - 2.5, frame.size.width / 6.0, 2);
        rightPointer.frame = CGRectMake(frame.size.width / 2.0, frame.size.height - 2.5, frame.size.width / 6.0, 2);
        centerPointer.frame = CGRectMake(frame.size.width / 3.0, frame.size.height - 2.5, frame.size.width / 3.0, 2);
    }
    
    leftPointer.hidden = NO;
    rightPointer.hidden = NO;
    
    if (pointerType == PointerTypeAppear)
    {
        leftPointer.center = CGPointMake(self.frame.size.width / 12.0, leftPointer.center.y);
        rightPointer.center = CGPointMake(11 * self.frame.size.width / 12.0, rightPointer.center.y);
        centerPointer.hidden = NO;
    }
    else if (pointerType == PointerTypeMoving)
    {
        centerPointer.hidden = YES;
        leftPointer.center = CGPointMake(5 * self.frame.size.width / 12.0, leftPointer.center.y);
        rightPointer.center = CGPointMake(7 * self.frame.size.width / 12.0, rightPointer.center.y);
    }
    else if (pointerType == PointerTypeNone)
    {
        centerPointer.hidden = YES;
        leftPointer.hidden = YES;
        rightPointer.hidden = YES;
    }
    else if (pointerType == PointerTypeCenter)
    {
        centerPointer.hidden = NO;
        leftPointer.hidden = YES;
        rightPointer.hidden = YES;
    }
    [self resetPointers];
}


- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event])
    {
        return scrollView;
    }
    return nil;
}


- (void) tapped:(UITapGestureRecognizer *)gesture
{
    CGPoint p = [gesture locationInView:scrollView];
    int point = ( (int)(p.x / scrollView.frame.size.width) ) * scrollView.frame.size.width + 2;
    [self reset:CGPointMake(point, p.y)];
}


- (void) scrollViewDidScroll:(UIScrollView *)sView
{
    [self adjustPointers];
}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    [self reset:sView.contentOffset];
    [self resetPointers];
}


- (void) scrollViewDidEndDragging:(UIScrollView *)sView willDecelerate:(BOOL)decelerate
{
    [self reset:sView.contentOffset];
    if (!decelerate)
    {
        [self resetPointers];
    }
}


- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)sVew
{
    if (!scrollView.isDecelerating && !scrollView.isDragging)
    {
        [self resetPointers];
    }
}


- (void) reset:(CGPoint)p
{
    int point = (int)roundf(p.x / scrollView.frame.size.width);
    int count = [datasource numberOfCellsforScrollableView:self];
    if (point >= count)
    {
        point = count - 1;
    }
    
    float offset = point * scrollView.frame.size.width;
    if ( offset < (scrollView.contentSize.width - scrollView.frame.size.width + 10) )
    {
        [UIView animateWithDuration:0.15 animations:^() {
            scrollView.contentOffset = CGPointMake(offset, 0);
        } completion:^(BOOL finished) {
            [self scrollViewDidEndScrollingAnimation:nil];
        }];
    }
}


- (void) resetPointers
{
    if ([datasource respondsToSelector:@selector(scrollableView:willSelectCellAtIndex:)])
    {
        [datasource scrollableView:self willSelectCellAtIndex:selectedIndex];
    }
    
    [UIView beginAnimations:@"pointeranims2" context:nil];
    [UIView setAnimationDelay:1.0];
    if (pointerType == PointerTypeMoving)
    {
        leftPointer.center = CGPointMake(5 * self.frame.size.width / 12.0, leftPointer.center.y);
        rightPointer.center = CGPointMake(7 * self.frame.size.width / 12.0, rightPointer.center.y);
    }
    else if (pointerType == PointerTypeAppear)
    {
        leftPointer.alpha = 0.0;
        rightPointer.alpha = 0.0;
    }
    
    [UIView commitAnimations];
    selectedIndex = [scrollView subviewAtPoint:CGPointMake(scrollView.contentOffset.x + scrollView.bounds.size.width / 2, 5)].tag - 1;
    int i = 0;
    for (UIView *v in scrollView.subviews)
    {
        if ([v isKindOfClass:[DPScrollableViewCell class]])
        {
            if (i == selectedIndex)
            {
                ( (DPScrollableViewCell *)v ).selected = YES;
            }
            else
            {
                ( (DPScrollableViewCell *)v ).selected = NO;
            }
            
            [v setNeedsDisplay];
        }
        
        i++;
    }
    
    if ([datasource respondsToSelector:@selector(scrollableView:didSelectCellAtIndex:)])
    {
        [datasource scrollableView:self didSelectCellAtIndex:selectedIndex];
    }
}


- (void) adjustPointers
{
    if (pointerType == PointerTypeMoving)
    {
        if (scrollView.contentOffset.x >= scrollView.frame.size.width * 1.5)
        {
            leftPointer.center = CGPointMake(self.frame.size.width / 12.0, leftPointer.center.y);
        }
        else
        {
            leftPointer.center = CGPointMake(5 * self.frame.size.width / 12.0, leftPointer.center.y);
        }
        
        if (scrollView.contentSize.width - scrollView.contentOffset.x > scrollView.frame.size.width * 2.5)
        {
            rightPointer.center = CGPointMake(11 * self.frame.size.width / 12.0, rightPointer.center.y);
        }
        else
        {
            rightPointer.center = CGPointMake(7 * self.frame.size.width / 12.0, rightPointer.center.y);
        }
    }
    else if (pointerType == PointerTypeAppear)
    {
        [UIView beginAnimations:@"pointeranims" context:nil];
        if (scrollView.contentOffset.x >= scrollView.frame.size.width * 1.5)
        {
            leftPointer.alpha = 1.0;
        }
        else
        {
            leftPointer.alpha = 0.0;
        }
        
        if (scrollView.contentSize.width - scrollView.contentOffset.x > scrollView.frame.size.width * 2.5)
        {
            rightPointer.alpha = 1.0;
        }
        else
        {
            rightPointer.alpha = 0.0;
        }
        
        [UIView commitAnimations];
    }
}


- (void) setDatasource:(id<DPScrollableViewDatasource>)ds
{
    if (scrollView)
    {
        [scrollView removeFromSuperview];
    }
    scrollView = nil;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3.0, 0, self.frame.size.width / 3.0, self.frame.size.height)];
    [self addSubview:scrollView];
    scrollView.scrollEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.clipsToBounds = NO;
    scrollView.delegate = self;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)]];
    
    datasource = ds;
    float x = 0;
    CGRect rect = CGRectZero;
    int count = [datasource numberOfCellsforScrollableView:self];
    BOOL hasView = [ds respondsToSelector:@selector(scrollableView:getViewForIndex:)];
    BOOL hasText = [ds respondsToSelector:@selector(scrollableView:getTitleForIndex:)];
    BOOL hasImage = [ds respondsToSelector:@selector(scrollableView:getImageForIndex:)];
    for (int i = 0; i < count; i++)
    {
        UIView *label = nil;
        if (hasView)
        {
            label = [ds scrollableView:self getViewForIndex:i];
        }
        
        if (!label)
        {
            DPScrollableViewCell *cell = [[DPScrollableViewCell alloc] initWithFrame:CGRectMake(x, 0, self.frame.size.width / 3, scrollView.frame.size.height)];
            [scrollView addSubview:cell];
            if (hasText)
            {
                cell.title = [ds scrollableView:self getTitleForIndex:i];
            }
            
            if (hasImage)
            {
                cell.image = [ds scrollableView:self getImageForIndex:i];
            }
            
            cell.separatorColor = [UIColor darkGrayColor];
            label = cell;
            if ([ds respondsToSelector:@selector(scrollableView:didAddCell:)])
            {
                [ds scrollableView:self didAddCell:cell];
            }
        }
        else
        {
            if (!label.superview)
            {
                label.frame = CGRectMake(x, 0, self.frame.size.width / 3, scrollView.frame.size.height);
                [scrollView addSubview:label];
            }
        }
        
        x += label.frame.size.width;
        rect = CGRectUnion(rect, label.frame);
        label.tag = i + 1;
        label.backgroundColor = [UIColor clearColor];
    }
    
    scrollView.contentSize = rect.size;
}

- (void)reloadTabTitles
{
    if ([datasource respondsToSelector:@selector(scrollableView:getTitleForIndex:)])
    {
        NSUInteger i = 0;
        for (DPScrollableViewCell *cell in scrollView.subviews)
        {
            cell.title = [datasource scrollableView:self getTitleForIndex:i];
            [cell setNeedsDisplay];
            i++;
        }
    }
    
}

- (UIView *) viewAtIndex:(NSUInteger)index
{
    return [self viewWithTag:index + 1];
}


- (void) setHighlightOnAllRows:(BOOL)high
{
    int count = [datasource numberOfCellsforScrollableView:self];
    for (int i = 0; i < count; i++)
    {
        UIView *v = [self viewAtIndex:i];
        if ([v isKindOfClass:[DPScrollableViewCell class]])
        {
            ( (DPScrollableViewCell *)v ).highlighted = high;
            [v setNeedsDisplay];
        }
    }
}


- (void) setSelectedIndex:(int)s
{
    selectedIndex = s;
    [self reset:CGPointMake( (scrollView.frame.size.width ) * s, 0 )];
    [self resetPointers];
}


- (DPScrollableViewCell *) cellAtIndex:(NSUInteger)index
{
    id val = [scrollView.subviews objectAtIndex:index];
    if ([val isKindOfClass:[DPScrollableViewCell class]])
    {
        return val;
    }
    
    return nil;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.datasource = datasource;
    self.pointerType = pointerType;
}

@end

@implementation UIView (Extras)

- (UIView *) subviewAtPoint:(CGPoint)point
{
    for (UIView *view in self.subviews)
    {
        if ( CGRectContainsPoint(view.frame, point) )
        {
            return view;
        }
    }
    
    return self;
}

@end
