//
//  DPViewController.h
//  Slidey
//
//  Created by Govi on 16/07/2013.
//  Copyright (c) 2013 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPScrollableView.h"

@class DPSwipeViewController;

@protocol DPSwipeViewControllerDelegate <NSObject>

@optional
-(void) slideyController:(DPSwipeViewController *)slidey willTransitionFrom:(NSInteger)from viewController:(UIViewController *)fromvc to:(NSInteger)to viewController:(UIViewController *)tovc;
-(void) slideyController:(DPSwipeViewController *)slidey didTransitionFrom:(NSInteger)from viewController:(UIViewController *)fromvc to:(NSInteger)to viewController:(UIViewController *)tovc;
-(UIViewController *) slideyController:(DPSwipeViewController *)slidey viewControllerForPage:(NSInteger)page;
-(NSInteger) numberOfCellsForSlideyViewController:(DPSwipeViewController *)vc;

@end

@interface DPSwipeViewController : UIViewController <UIScrollViewDelegate, DPSwipeViewControllerDelegate, DPScrollableViewDatasource> {
    BOOL swiping;
    int transitioningTo;
    NSMutableDictionary *childControllers;
}

@property (nonatomic) int numberOfPages;
@property (nonatomic) float startOffset;
@property (nonatomic) int currentPage;
@property (nonatomic, weak) id<DPSwipeViewControllerDelegate> delegate;
@property (nonatomic, strong) DPScrollableView *scrollableView;

-(id)initWithDelegate:(id<DPSwipeViewControllerDelegate>)delegate;
- (void)setNumberOfPagesWithoutReset:(int)numberOfPages;
- (void)resetViewControllerAtIndex:(int)index;

@end
