/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */

#import "HRColorCursor.h"

@interface HRColorCursor ()
- (id)initWithPoint:(CGPoint)point;

@property (nonatomic) BOOL editing;
@property (nonatomic, getter=isGrayCursor) BOOL grayCursor;

@end

@implementation HRColorCursor {
    CALayer *_backLayer;
    CALayer *_colorLayer;
    UIColor *_color;
    BOOL _editing;
}

@synthesize color = _color;

+ (CGSize)cursorSize {
    return CGSizeMake(28.0, 28.0f);
}

+ (HRColorCursor *)colorCursorWithPoint:(CGPoint)point {
    return [[HRColorCursor alloc] initWithPoint:point];
}

- (id)initWithPoint:(CGPoint)point {
    CGSize size = [HRColorCursor cursorSize];
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:FALSE];
        self.color = [UIColor whiteColor];

        CGRect backFrame = (CGRect) {.origin = CGPointZero, .size = self.frame.size};
        _backLayer = [[CALayer alloc] init];
        _backLayer.frame = backFrame;
        _backLayer.cornerRadius = CGRectGetHeight(self.frame) / 2;
        _backLayer.borderColor = [[UIColor colorWithWhite:0.65 alpha:1.] CGColor];
        _backLayer.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
        _backLayer.backgroundColor = [[UIColor colorWithWhite:1. alpha:.7] CGColor];
        [self.layer addSublayer:_backLayer];

        _colorLayer = [[CALayer alloc] init];
        _colorLayer.frame = CGRectInset(backFrame, 5.5, 5.5);
        _colorLayer.cornerRadius = CGRectGetHeight(_colorLayer.frame) / 2;
        [self.layer addSublayer:_colorLayer];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    HRHSVColor hsvColor;
    HSVColorFromUIColor(_color, &hsvColor);
    BOOL shouldBeGrayCursor = hsvColor.v > 0.7 && hsvColor.s < 0.4;


    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _colorLayer.backgroundColor = [_color CGColor];
    if (self.isGrayCursor != shouldBeGrayCursor) {
        if (shouldBeGrayCursor) {
            _backLayer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
            _backLayer.backgroundColor = [[UIColor colorWithWhite:0. alpha:0.2] CGColor];
        } else {
            _backLayer.borderColor = [[UIColor colorWithWhite:0.65 alpha:1] CGColor];
            _backLayer.backgroundColor = [[UIColor colorWithWhite:1. alpha:0.7] CGColor];
        }
        self.grayCursor = shouldBeGrayCursor;
    }

    [CATransaction commit];
    [self setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing {
    if (editing == _editing) {
        return;
    }
    _editing = editing;
    void (^showState)() = ^{
        _backLayer.transform = CATransform3DMakeScale(1.6, 1.6, 1.0);
        _colorLayer.transform = CATransform3DMakeScale(1.4, 1.4, 1.0);
    };
    void (^hiddenState)() = ^{
        _backLayer.transform = CATransform3DIdentity;
        _colorLayer.transform = CATransform3DIdentity;
    };
    if (_editing) {
        hiddenState();
    } else {
        showState();
    }
    [UIView animateWithDuration:0.1
                     animations:_editing ? showState : hiddenState];
}

@end

