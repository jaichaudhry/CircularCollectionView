//
//  JCECircularCollectionViewController.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "JCECircularCollectionViewController.h"
#import "JCETitleView.h"

static CGFloat const kTitleViewHeight = 35;

static NSString *kCollectionViewReusableIdentifier = @"COLLECTION_VIEW_IDENTIFIER";

@interface JCECircularCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *circularCollectionView;
@property (nonatomic, strong) UIScrollView *titleScrollView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataViewControllers;

/**
 *  To know the scrolling direction.
 */
@property (nonatomic, assign) CGFloat lastContentOffset;

/**
 *  To keep track of scrolling when done via tapping on title.
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  To keep track of scrolling via tapping.
 */
@property (nonatomic, assign) BOOL titleWasTapped;
@property (nonatomic, assign) BOOL mainCollectionViewScrolled;

@end

@implementation JCECircularCollectionViewController

- (instancetype)initWithTitleArray:(NSArray *)titleArray andDataViewControllers:(NSArray *)dataViewControllers {
    if (self = [super init]) {
        _titleArray = titleArray;
        _dataViewControllers = dataViewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_updateDataArrayAndTitleArray];
    [self p_initSubViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.frame.size;
    CGFloat yOffset = self.view.frame.origin.y;
    _titleScrollView.frame = CGRectMake(0, yOffset, viewSize.width, kTitleViewHeight);
    CGFloat xOffset = 0;
    CGFloat titleViewWidth = viewSize.width/3;
    for (JCETitleView *titleView in _titleScrollView.subviews) {
        titleView.frame = CGRectMake(xOffset, 0, titleViewWidth, kTitleViewHeight);
        xOffset += titleViewWidth;
    }
    _titleScrollView.contentSize = CGSizeMake((viewSize.width * [_titleArray count])/3, kTitleViewHeight);
    yOffset += kTitleViewHeight;
    
    _circularCollectionView.frame = CGRectMake(0,yOffset, viewSize.width, viewSize.height - kTitleViewHeight);
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataViewControllers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewReusableIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *dataViewController = [_dataViewControllers objectAtIndex:indexPath.row];
    [self p_displayDataViewController:dataViewController onCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *dataViewController = [_dataViewControllers objectAtIndex:indexPath.row];
    [self p_removeDataViewController:dataViewController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_circularCollectionView]) {
        _titleScrollView.contentOffset = CGPointMake((scrollView.contentOffset.x - self.view.frame.size.width) /3, scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_circularCollectionView]) {
        _titleWasTapped = NO;
        CGFloat viewWidth = self.view.frame.size.width;
        NSInteger currentIndex = (scrollView.contentOffset.x / viewWidth);
        _currentIndex = currentIndex;
        CGFloat endingContentOffset = viewWidth * ([_dataViewControllers count] - 1);
        
        if (scrollView.contentOffset.x == endingContentOffset) {
            // Move to fake item added in the begining.
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        } else if (scrollView.contentOffset.x == 0) {
            // Move to the fake item added in the end.
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[_dataViewControllers count] - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        } else {
            // For all the other items in between.
            [self p_setTitleColorAtIndex:currentIndex];
        }
        if (currentIndex == [_titleArray count] - 1) {
            // Move to fake item of the title scroll view in the beggining.
            [self p_setTitleColorAtIndex:1];
            [_titleScrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, kTitleViewHeight) animated:NO];
        }
        if (currentIndex == 0) {
            //Move to the fake item of the title scroll view added in the end.
            [_titleScrollView scrollRectToVisible:CGRectMake(viewWidth * ([_titleArray count] - 3) / 3, 0, viewWidth, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:[_titleArray count] - 2];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGSize viewSize = self.view.frame.size;
    if (!_titleWasTapped) {
        return;
    }
    if ([scrollView isEqual:_titleScrollView]) {
        /**
         *  This is done to handle the the movement of main collection view on tapping the title scroll view.
         */
        UICollectionViewScrollPosition scrollPosition;
        if (_lastContentOffset < scrollView.contentOffset.x) {
            scrollPosition = UICollectionViewScrollPositionLeft;
        } else {
            scrollPosition = UICollectionViewScrollPositionRight;
        }
        
        /**
         *  This is done to maintain the animation of main collection view when reaching to the fake items of title scroll view.
         */
        if (_currentIndex == [_titleArray count] - 1) {
            [_titleScrollView scrollRectToVisible:CGRectMake(0, 0, viewSize.width, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:1];
        } else if (_currentIndex == 0) {
            [_titleScrollView scrollRectToVisible:CGRectMake(viewSize.width * ([_titleArray count] - 3) / 3, 0, viewSize.width, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:[_titleArray count] - 2];
        }
        _lastContentOffset = scrollView.contentOffset.x;
    } else if ([scrollView isEqual:_circularCollectionView]) {
        /**
         *  This is done to maintain the animation of main collection view when reaching to the fake items of title scroll view.
         */
        if (_currentIndex == [_titleArray count] - 1) {
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        if (_currentIndex == 0) {
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[_dataViewControllers count] - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize viewSize = self.view.frame.size;
    return CGSizeMake(viewSize.width, viewSize.height - kTitleViewHeight);
}

#pragma mark - Action handlers

- (void)p_titleViewTapped:(UITapGestureRecognizer *)sender {
    _titleWasTapped = YES;
    NSInteger index = [_titleScrollView.subviews indexOfObject:sender.view];
    _currentIndex = index;
    CGSize viewSize = self.view.frame.size;
    [self p_setTitleColorAtIndex:index];
    if (index == 0) {
        [_titleScrollView setContentOffset:CGPointMake(-viewSize.width/3, 0) animated:YES];
    } else {
        [_titleScrollView scrollRectToVisible:CGRectMake((viewSize.width * (index - 1))/ 3, 0, viewSize.width, viewSize.height) animated:YES];
    }
    [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - Private

- (void)p_initSubViews {
    _titleScrollView = [[UIScrollView alloc] init];
    _titleScrollView.backgroundColor = [UIColor whiteColor];
    _titleScrollView.delegate = self;
    [self.view addSubview:_titleScrollView];
    
    for (int i = 0; i < [_titleArray count]; i++) {
        JCETitleView *titleView = [JCETitleView new];
        titleView.titleLabel.text = [_titleArray objectAtIndex:i];
        [_titleScrollView addSubview:titleView];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_titleViewTapped:)];
        [titleView addGestureRecognizer:gestureRecognizer];
    }
    
    _circularCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self p_collectionViewLayout]];
    _circularCollectionView.backgroundColor = [UIColor whiteColor];
    [_circularCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewReusableIdentifier];
    _circularCollectionView.dataSource = self;
    _circularCollectionView.delegate = self;
    _circularCollectionView.pagingEnabled = YES;
    _circularCollectionView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:_circularCollectionView];
    
    [self.view layoutIfNeeded];

    // Set the title scroll view and circular collection view to the first original item as the item at index 0 is fake inserted item.
    [self p_setTitleColorAtIndex:1];
    [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [_titleScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (UICollectionViewFlowLayout *)p_collectionViewLayout {
    UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.minimumLineSpacing = 0;
    return collectionViewLayout;
}

/**
 *  Adding fake items to both ends of title scroll view and circular collection view for circular funcationality.
 */
- (void)p_updateDataArrayAndTitleArray {
    UIViewController *firstViewController = [_dataViewControllers firstObject];
    UIViewController *lastViewController = [_dataViewControllers lastObject];
    NSMutableArray *mutableViewControllersArray = [NSMutableArray arrayWithArray:_dataViewControllers];
    [mutableViewControllersArray insertObject:lastViewController atIndex:0];
    [mutableViewControllersArray addObject:firstViewController];
    _dataViewControllers = [mutableViewControllersArray copy];
    
    NSString *firstTitle = [_titleArray firstObject];
    NSString *lastTitle = [_titleArray lastObject];
    NSMutableArray *titleWorkinArray = [NSMutableArray arrayWithArray:_titleArray];
    [titleWorkinArray insertObject:lastTitle atIndex:0];
    [titleWorkinArray addObject:firstTitle];
    _titleArray = titleWorkinArray;
}

- (void)p_displayDataViewController: (UIViewController*)dataViewController onCell:(UICollectionViewCell *)cell {
    [self addChildViewController:dataViewController];
    dataViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kTitleViewHeight);
    [cell addSubview:dataViewController.view];
    [dataViewController didMoveToParentViewController:self];
}

- (void)p_removeDataViewController:(UIViewController *)dataViewController {
    [dataViewController willMoveToParentViewController:nil];
    [dataViewController.view removeFromSuperview];
}

- (void)p_setTitleColorAtIndex:(NSInteger)index {
    for (JCETitleView *titleView in _titleScrollView.subviews) {
        if (![titleView isKindOfClass:[JCETitleView class]]) {
            continue;
        }
        if (index == [_titleScrollView.subviews indexOfObject:titleView]) {
            titleView.titleLabel.textColor = [UIColor blackColor];
        } else {
            titleView.titleLabel.textColor = [UIColor grayColor];
        }
    }
}

@end
