//
//  PaletteView.h
//  PixelBoard
//
//  Created by guohaoyang on 2021/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaletteView : UIView

@property(nonatomic,copy)void(^didSelect)(UIColor *color);
@property(nonatomic,readonly)UIColor*   defaultColor;

@end

@interface PaletteViewCell : UICollectionViewCell
@property(nonatomic)BOOL        cSelected;
@property(nonatomic)UIColor*    color;
@end

NS_ASSUME_NONNULL_END
