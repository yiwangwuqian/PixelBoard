//
//  PixelBoardView.m
//  PixelBoard
//
//  Created by guohaoyang on 2021/1/9.
//

#define kPixelGridCount 40

#import "PixelBoardView.h"

@interface PixelBoardView()

@property(nonatomic)CGSize              selfSize;
@property(nonatomic)UIImageView*        imageView;

@property(nonatomic)NSMutableArray*     pointArray;
@property(nonatomic)NSMutableArray*     pointColorArray;

@end

@implementation PixelBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
        [self addGestureRecognizer:recognizer];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _pointArray = [[NSMutableArray alloc] init];
        _pointColorArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setPenColor:(UIColor *)penColor
{
    _penColor = penColor;
    if (self.superview) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            [self drawImageWork];
        });
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _selfSize = frame.size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_imageView.frame, self.bounds)) {
        _imageView.frame = self.bounds;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            [self drawImageWork];
        });
    }
}

- (void)drawImageWork
{
    CGSize size = _selfSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextAddPath(context, CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), NULL));
    UIColor *bgColor = [UIColor grayColor];
    if (!bgColor){
        bgColor = [UIColor whiteColor];
    }
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    //绘制网格
    NSInteger count = kPixelGridCount;
    CGFloat stepLength = size.width / count;
    CGMutablePathRef gridPath = CGPathCreateMutable();
    for (NSInteger i=0; i<=count; i++) {
        CGFloat originValue = i * stepLength;
        CGPathMoveToPoint(gridPath, NULL, 0, originValue);
        CGPathAddLineToPoint(gridPath, NULL, size.width, originValue);
        
        CGPathMoveToPoint(gridPath, NULL, originValue, 0);
        CGPathAddLineToPoint(gridPath, NULL, originValue, size.height);
    }
    
    CGFloat borderLineWidth = 1;
    CGContextAddPath(context, gridPath);
    CGContextSetStrokeColorWithColor(context,  [UIColor colorWithRed:220/255.0 green:223/255.0 blue:227/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(context, borderLineWidth);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(gridPath);
    
    //填充被操作过的网格
    if (self.pointArray.count) {
        CGFloat fillOriginOffset = borderLineWidth/2;
        for (NSValue *pointValue in self.pointArray) {
            CGMutablePathRef fillPath = CGPathCreateMutable();
            
            CGFloat originX = [pointValue CGPointValue].x * stepLength + fillOriginOffset;
            CGFloat originY = [pointValue CGPointValue].y * stepLength + fillOriginOffset;
            CGPathMoveToPoint(fillPath, NULL, originX, originY);
            CGPathAddRect(fillPath, NULL, CGRectMake(originX, originY, stepLength-1, stepLength-1));
            
            CGContextAddPath(context, fillPath);
            NSUInteger index = [self.pointArray indexOfObject:pointValue];
            UIColor *penColor = self.pointColorArray[index];
            CGContextSetFillColorWithColor(context, penColor.CGColor);
            CGContextDrawPath(context, kCGPathFill);
            CGPathRelease(fillPath);
        }
    }

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = finalImage;
    });
}

- (void)tappedView:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    
    NSInteger count = kPixelGridCount;
    CGFloat stepLength = _selfSize.width / count;
    CGFloat x = floor(point.x/stepLength);
    CGFloat y = floor(point.y/stepLength);
    NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    if (![self.pointArray containsObject:pointValue]) {
        [self.pointArray addObject:pointValue];
        [self.pointColorArray addObject:self.penColor];
    } else {
        NSUInteger index = [self.pointArray indexOfObject:pointValue];
        [self.pointArray removeObject:pointValue];
        [self.pointColorArray removeObjectAtIndex:index];
    }
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self drawImageWork];
    });
}

@end
