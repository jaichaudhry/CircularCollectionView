//
//  JCECircularCollectionViewController.m
//  JCECircularCollectionView
//
//  Created by Jai Chaudhry on 08/10/15.
//  Copyright © 2015 jce. All rights reserved.
//

#import "JCECircularCollectionViewController.h"
#import "JCETitleView.h"
#import "JCEBorderLayer.h"

static CGFloat const kTitleViewHeight = 35;

static NSString *kCollectionViewReusableIdentifier = @"COLLECTION_VIEW_IDENTIFIER";


@interface JCECircularCollectionViewItemMetadata : NSObject
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) UIViewController *itemDataViewController;
@end

@implementation JCECircularCollectionViewItemMetadata
@end


@interface JCECircularCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *circularCollectionView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIView *titleScrollDummyView;

@property (nonatomic, assign) NSInteger itemsCount;
@property (nonatomic, strong) NSArray *itemMetadataArray;

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
@property (nonatomic, assign) BOOL defaultScrollViewsPostionSet;

@property (nonatomic, assign) NSInteger numberOfTitlesVisible;

@property (nonatomic, strong) JCEBorderLayer *arrowLayer;

@end

@implementation JCECircularCollectionViewController

- (instancetype)init {
    if (self = [super init]) {
        _numberOfTitlesVisible = 3;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self p_prepareDataSource];
    [self p_updateDataArrayAndTitleArray];
    [self p_initSubViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.bounds.size;
    CGFloat yOffset = 0;
    
    _titleScrollDummyView.frame = CGRectMake(0, yOffset, viewSize.width, kTitleViewHeight);
    _titleScrollView.frame = CGRectMake(0, 0, viewSize.width, kTitleViewHeight);
    CGFloat xOffset = 0;
    CGFloat titleViewWidth = viewSize.width/_numberOfTitlesVisible;
    for (JCETitleView *titleView in _titleScrollView.subviews) {
        titleView.frame = CGRectMake(xOffset, 0, titleViewWidth, kTitleViewHeight);
        xOffset += titleViewWidth;
    }
    _titleScrollView.contentSize = CGSizeMake((viewSize.width * _itemsCount)/_numberOfTitlesVisible, kTitleViewHeight);
    yOffset += kTitleViewHeight;
    
    if (_showArrow) {
        if (!_arrowLayer) {
            _arrowLayer = [JCEBorderLayer new];
            _arrowLayer.arrowDirection = JCEArrowDirectionUp;
            UIColor *arrowColor = _arrowColor ? _arrowColor : [UIColor whiteColor];
            _arrowLayer.arrowFillColor = arrowColor;
            _arrowLayer.showArrow = YES;
            _arrowLayer.arrowWidth = 12.0;
            _arrowLayer.arrowHeight = 8.0;
            _arrowLayer.arrowBorderColor = arrowColor;
        }
        _arrowLayer.arrowPoint = CGPointMake(viewSize.width/2, kTitleViewHeight);
        _arrowLayer.frame = CGRectMake(0, 0, viewSize.width, kTitleViewHeight);
        if ([_arrowLayer superlayer]) {
            [_arrowLayer removeFromSuperlayer];
        }
        [_titleScrollDummyView.layer addSublayer:_arrowLayer];
    }
    
    _circularCollectionView.frame = CGRectMake(0,yOffset, viewSize.width, viewSize.height - kTitleViewHeight);
    
    if (!_defaultScrollViewsPostionSet) {
        // Set the title scroll view and circular collection view to the first original item as the item at index 0 is fake inserted item.
        [self p_setTitleColorAtIndex:1];
        [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [_titleScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _defaultScrollViewsPostionSet = YES;
    }
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 2 is added for 2 fake items
    return _datasource ? [_datasource numberOfItems] + 2 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewReusableIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JCECircularCollectionViewItemMetadata *itemMetadata = [_itemMetadataArray objectAtIndex:indexPath.row];
    [self p_displayDataViewController:itemMetadata.itemDataViewController onCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JCECircularCollectionViewItemMetadata *itemMetadata = [_itemMetadataArray objectAtIndex:indexPath.row];
    [self p_removeDataViewController:itemMetadata.itemDataViewController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_circularCollectionView]) {
        _titleScrollView.contentOffset = CGPointMake((scrollView.contentOffset.x - self.view.frame.size.width)/_numberOfTitlesVisible, scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_circularCollectionView]) {
        _titleWasTapped = NO;
        CGFloat viewWidth = self.view.frame.size.width;
        NSInteger currentIndex = (scrollView.contentOffset.x / viewWidth);
        _currentIndex = currentIndex;
        CGFloat endingContentOffset = viewWidth * (_itemsCount - 1);
        
        if (scrollView.contentOffset.x == endingContentOffset) {
            // Move to fake item added in the begining.
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        } else if (scrollView.contentOffset.x == 0) {
            // Move to the fake item added in the end.
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_itemsCount - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        } else {
            // For all the other items in between.
            [self p_setTitleColorAtIndex:currentIndex];
        }
        if (currentIndex == _itemsCount - 1) {
            // Move to fake item of the title scroll view in the beggining.
            [_titleScrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:1];
        }
        if (currentIndex == 0) {
            //Move to the fake item of the title scroll view added in the end.
            [_titleScrollView scrollRectToVisible:CGRectMake(viewWidth * (_itemsCount - 3) / _numberOfTitlesVisible, 0, viewWidth, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:_itemsCount - 2];
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
        if (_currentIndex == _itemsCount - 1) {
            [_titleScrollView scrollRectToVisible:CGRectMake(0, 0, viewSize.width, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:1];
        } else if (_currentIndex == 0) {
            [_titleScrollView scrollRectToVisible:CGRectMake(viewSize.width * (_itemsCount - 3) / _numberOfTitlesVisible, 0, viewSize.width, kTitleViewHeight) animated:NO];
            [self p_setTitleColorAtIndex:_itemsCount - 2];
        }
        _lastContentOffset = scrollView.contentOffset.x;
    } else if ([scrollView isEqual:_circularCollectionView]) {
        /**
         *  This is done to maintain the animation of main collection view when reaching to the fake items of title scroll view.
         */
        if (_currentIndex == _itemsCount - 1) {
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self p_setTitleColorAtIndex:1];
        }
        if (_currentIndex == 0) {
            [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_itemsCount - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
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
        [_titleScrollView setContentOffset:CGPointMake(-viewSize.width/_numberOfTitlesVisible, 0) animated:YES];
    } else {
        [_titleScrollView scrollRectToVisible:CGRectMake((viewSize.width * (index - 1))/ _numberOfTitlesVisible, 0, viewSize.width, kTitleViewHeight) animated:YES];
    }
    [_circularCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - Private

- (void)p_prepareDataSource {
    _itemsCount = 0;
    if (_datasource && [_datasource respondsToSelector:@selector(numberOfItems)]) {
        _itemsCount = [_datasource numberOfItems];
    }

    NSMutableArray *itemsArray = _itemsCount > 0 ? [NSMutableArray arrayWithCapacity:_itemsCount] : [NSMutableArray array];
    for (NSInteger itemIndex = 0; itemIndex < _itemsCount; itemIndex++) {
        JCECircularCollectionViewItemMetadata *itemMetadata = [JCECircularCollectionViewItemMetadata new];
        itemMetadata.itemIndex = itemIndex;
        if (_datasource && [_datasource respondsToSelector:@selector(circularCollectionViewController:titleForItemAtIndex:)]) {
            itemMetadata.itemTitle = [_datasource circularCollectionViewController:self titleForItemAtIndex:itemIndex];
        }
        if (_datasource && [_datasource respondsToSelector:@selector(circularCollectionViewController:viewControllerForItemAtIndex:)]) {
            itemMetadata.itemDataViewController = [_datasource circularCollectionViewController:self viewControllerForItemAtIndex:itemIndex];
        }
        [itemsArray addObject:itemMetadata];
    }

    _itemMetadataArray = [NSArray arrayWithArray:itemsArray];
    _itemsCount = _itemsCount + 2;
}

- (void)p_initSubViews {
    _titleScrollDummyView = [UIView new];
    [self.view addSubview:_titleScrollDummyView];
    
    _titleScrollView = [[UIScrollView alloc] init];
    _titleScrollView.scrollEnabled = NO;
    _titleScrollView.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0];
    _titleScrollView.delegate = self;
    [_titleScrollDummyView addSubview:_titleScrollView];
    
    for (NSInteger i = 0; i < _itemsCount; i++) {
        JCETitleView *titleView = [JCETitleView new];
        JCECircularCollectionViewItemMetadata *itemMetadata = [_itemMetadataArray objectAtIndex:i];
        titleView.titleLabel.text = itemMetadata.itemTitle;
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
    JCECircularCollectionViewItemMetadata *firstItemMetadata = [_itemMetadataArray firstObject];
    JCECircularCollectionViewItemMetadata *lastItemMetadata = [_itemMetadataArray lastObject];
    NSMutableArray *mutableItemsMetadataArray = [NSMutableArray arrayWithArray:_itemMetadataArray];
    [mutableItemsMetadataArray insertObject:lastItemMetadata atIndex:0];
    [mutableItemsMetadataArray addObject:firstItemMetadata];
    _itemMetadataArray = [mutableItemsMetadataArray copy];
}

- (void)p_displayDataViewController: (UIViewController*)dataViewController onCell:(UICollectionViewCell *)cell {
    if (dataViewController == nil) {
        return;
    }
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
