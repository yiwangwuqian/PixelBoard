//
//  ViewController.m
//  PixelBoard
//
//  Created by guohaoyang on 2021/1/9.
//

#import "ViewController.h"
#import "PixelBoardView.h"
#import "PaletteView.h"

@interface ViewController ()

@property(nonatomic)PaletteView*    paletteView;

@property(nonatomic)PixelBoardView* drawingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_paletteView) {
        _paletteView = [[PaletteView alloc] init];
        __weak __typeof(self) weakSelf = self;
        [_paletteView setDidSelect:^(UIColor * _Nonnull color) {
            weakSelf.drawingView.penColor = color;
        }];
        [self.view addSubview:_paletteView];
    }
    
    if (!_drawingView) {
        _drawingView = [[PixelBoardView alloc] init];
        _drawingView.penColor = _paletteView.defaultColor;
        [self.view addSubview:_drawingView];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGRect drawingFrame = CGRectMake(0,
                                     self.view.safeAreaInsets.top,
                                     viewWidth,
                                     viewWidth);
    if (!CGRectEqualToRect(drawingFrame, _drawingView.frame)) {
        _drawingView.frame = drawingFrame;
    }
    
    CGFloat paletteHeight = 100;
    CGRect paletteFrame = CGRectMake(0,
                                     CGRectGetHeight(self.view.frame) - self.view.safeAreaInsets.bottom - paletteHeight,
                                     viewWidth,
                                     paletteHeight);
    if (!CGRectEqualToRect(paletteFrame, _paletteView.frame)) {
        _paletteView.frame = paletteFrame;
    }
}
-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}
@end
