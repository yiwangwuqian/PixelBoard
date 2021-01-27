//
//  PaletteView.m
//  PixelBoard
//
//  Created by guohaoyang on 2021/1/10.
//

#define kPaletteColumnCount 8

#import "PaletteView.h"

@interface PaletteView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)UICollectionView*       collectionView;
@property(nonatomic)NSArray*                dataSource;
@property(nonatomic)NSIndexPath*            selectedIndexPath;

@end

@implementation PaletteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (!_collectionView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            _collectionView.backgroundColor = [UIColor lightGrayColor];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            _collectionView.showsVerticalScrollIndicator = NO;
            _collectionView.showsHorizontalScrollIndicator = NO;
            [_collectionView registerClass:[PaletteViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PaletteViewCell class])];
            [self addSubview:_collectionView];
        }
        
        if (!_dataSource) {
            _dataSource = @[[UIColor redColor],
                            [UIColor orangeColor],
                            [UIColor yellowColor],
                            [UIColor greenColor],
                            [UIColor cyanColor],
                            [UIColor blueColor],
                            [UIColor purpleColor],
                            [UIColor brownColor]];
        }
        
        if (!_selectedIndexPath) {
            _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
    }
    return self;
}

- (UIColor *)defaultColor
{
    return self.dataSource[self.selectedIndexPath.row];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDatasource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PaletteViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PaletteViewCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        cell.color = self.dataSource[indexPath.row];
    }
    
    cell.cSelected = [self.selectedIndexPath isEqual:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPathArray = nil;
    if (self.selectedIndexPath) {
        if ([self.selectedIndexPath isEqual:indexPath]) {
            return;
        }
        indexPathArray = @[indexPath,self.selectedIndexPath];
    } else {
        indexPathArray = @[indexPath];
    }
    self.selectedIndexPath = indexPath;
    
    [collectionView reloadItemsAtIndexPaths:indexPathArray];
    if (self.didSelect) {
        self.didSelect(self.dataSource[indexPath.row]);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(self.frame)/kPaletteColumnCount;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end

@interface PaletteViewCell()

@property(nonatomic)UIView* colorView;

@end

@implementation PaletteViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_colorView) {
            _colorView = [[UIView alloc] init];
            _colorView.layer.borderWidth = 2;
            [self.contentView addSubview:_colorView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _colorView.frame = self.bounds;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    _colorView.backgroundColor = color;
}

- (void)setCSelected:(BOOL)cSelected
{
    _cSelected = cSelected;
    if (cSelected) {
        _colorView.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        _colorView.layer.borderColor = nil;
    }
}

@end

#undef kPaletteColumnCount
