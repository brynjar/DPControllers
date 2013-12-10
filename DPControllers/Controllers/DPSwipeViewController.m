//
//  DPViewController.m
//  Slidey
//
//  Created by Govi on 16/07/2013.
//  Copyright (c) 2013 DP. All rights reserved.
//

#import "DPSwipeViewController.h"
#import "DPScrollableView.h"

int signum(int n) { return (n < 0) ? -1 : (n > 0) ? +1 : 0; }

@interface DPSwipeViewController ()

@end

@implementation DPSwipeViewController

-(id)initWithDelegate:(id<DPSwipeViewControllerDelegate>)delegate {
    self = [super init];
    if(self) {
        if(delegate) {
            self.delegate = delegate;
            if(self.delegate && [self.delegate respondsToSelector:@selector(numberOfCellsForSlideyViewController:)])
                self.numberOfPages = [self.delegate numberOfCellsForSlideyViewController:self];
        }
        else {
            self.delegate = self;
            self.numberOfPages = 4;
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        _scrollableView = [[DPScrollableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0)];
        [self.view addSubview:_scrollableView];
        _scrollableView.datasource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* contentView = ((UIViewController *)[self viewControllerForPage:0]).view;
    contentView.frame = CGRectMake(0, 40.0, self.view.frame.size.width, self.view.frame.size.height - 40.0);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentView];
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiping:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiping:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    self.currentPage = 0;
    [self.scrollableView setSelectedIndex:0];
}

-(void)swiping:(UISwipeGestureRecognizer *)gesture {
    int from = self.currentPage;
    int to = self.currentPage + 1;
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        to = self.currentPage - 1;
    }
    swiping = YES;
    [self transitionFrom:from to:to];
}

-(void)transitionFrom:(NSInteger)from to:(NSInteger)to {
    if(from != to && to < self.numberOfPages && to >= 0 && to != transitioningTo) {
        transitioningTo = to; //dummy variable with no other purpose rather than allowing transitions to not call here twice.
        UIViewController *fromvc = [self viewControllerForPage:from];
        UIViewController *tovc = [self viewControllerForPage:to];
        tovc.view.frame = fromvc.view.frame;
        tovc.view.center = CGPointMake(3*self.view.center.x*signum(to-from), fromvc.view.center.y);
        __block id<DPSwipeViewControllerDelegate> dele = self.delegate;
        __block DPScrollableView *scView = self.scrollableView;
        __block DPSwipeViewController *current = self;
        if(self.delegate && [self.delegate respondsToSelector:@selector(slideyController:willTransitionFrom:viewController:to:viewController:)])
            [self.delegate slideyController:self willTransitionFrom:(NSInteger)from viewController:fromvc to:(NSInteger)to viewController:tovc];
        
        [self transitionFromViewController:fromvc toViewController:tovc duration:0.4 options:UIViewAnimationOptionTransitionNone animations:^{
            float tmp = fromvc.view.center.x;
            fromvc.view.center = CGPointMake(3*self.view.center.x*signum(from-to), fromvc.view.center.y);
            tovc.view.center = CGPointMake(tmp, fromvc.view.center.y);
        } completion:^(BOOL finished) {
            current.currentPage = to;
            if(dele && [dele respondsToSelector:@selector(slideyController:didTransitionFrom:viewController:to:viewController:)])
                [dele slideyController:self didTransitionFrom:from viewController:fromvc to:to viewController:tovc];
            if(swiping) {
                [scView setSelectedIndex:to];
                swiping = NO;
            }
        }];
    }
}

-(void)setNumberOfPages:(int)numberOfPages {
    _numberOfPages = numberOfPages;
    [self resetChildViewControllers];
    [self.scrollableView setDatasource:self.scrollableView.datasource];
}

- (void)setNumberOfPagesWithoutReset:(int)numberOfPages {
    _numberOfPages = numberOfPages;
    [self.scrollableView setDatasource:self.scrollableView.datasource];
}

- (void)resetViewControllerAtIndex:(int)index {

    UIViewController *controller = [childControllers objectForKey:[NSNumber numberWithInt:index]];
    
    if ([controller.view superview])
    {
        [controller.view removeFromSuperview];
        
    }
    
    [controller removeFromParentViewController];
    [childControllers removeObjectForKey:[NSNumber numberWithInt:index]];
    
    UIView* contentView = ((UIViewController *)[self viewControllerForPage:index]).view;
    contentView.frame = CGRectMake(0, 40.0, self.view.frame.size.width, self.view.frame.size.height - 40.0);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentView];
    
}

-(void) resetChildViewControllers {
    for (UIViewController *controller in self.childViewControllers) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
    [childControllers removeAllObjects];
    
    UIView* contentView = ((UIViewController *)[self viewControllerForPage:self.currentPage]).view;
    contentView.frame = CGRectMake(0, 40.0, self.view.frame.size.width, self.view.frame.size.height - 40.0);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentView];
}

-(UIViewController *)viewControllerForPage:(NSInteger)page {
    
    if (childControllers == nil) {
        childControllers = [NSMutableDictionary dictionary];
    }
    
    UIViewController *vc = nil;
    if ([childControllers objectForKey:[NSNumber numberWithInt:page]])
    {
        vc = [childControllers objectForKey:[NSNumber numberWithInt:page]];
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(slideyController:viewControllerForPage:)]) {
            vc = [_delegate slideyController:self viewControllerForPage:page];
            [self addChildViewController:vc];
            [childControllers setObject:vc forKey:[NSNumber numberWithInt:page]];
        }
    }
    
    return vc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)numberOfCellsforScrollableView:(DPScrollableView *)view {
    return 4;
}

-(NSString *)scrollableView:(DPScrollableView *)view getTitleForIndex:(int)i {
    return @"Deviant";
}

-(void)scrollableView:(DPScrollableView *)view didSelectCellAtIndex:(int)index {
    if(!swiping)
        [self transitionFrom:self.currentPage to:index];
    else
        swiping = NO;
}

@end
