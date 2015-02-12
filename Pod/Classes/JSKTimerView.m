// JSKTimerView.m
//
// Copyright (c) 2015 Joefrey Kibuule
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "JSKTimerView.h"

static NSString *jsk_progressAnimationKey = @"progressAnimationKey";

@interface JSKTimerView ()

@property (nonatomic, readwrite, getter=isRunning) BOOL running;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;

@property (nonatomic, assign) NSInteger remainingTimeInSeconds;
@property (nonatomic, assign) NSInteger totalTimeInSeconds;
@property (nonatomic, assign) CGFloat timerStrokeWidth;
@property (nonatomic, strong) NSTimer *timerViewTimer;

@property (nonatomic, strong) UIColor *timerProgressColor;
@property (nonatomic, strong) UIColor *timerProgressStartColor;
@property (nonatomic, strong) UIColor *timerProgressNearFinishedColor;
@property (nonatomic, strong) UIColor *timerProgressAlmostFinishedColor;
@property (nonatomic, strong) UIColor *timerProgressFinishedColor;

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIBezierPath *timerStrokePath;
@property (nonatomic, strong) CAShapeLayer *timerProgressLayer;

@end

@implementation JSKTimerView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 50, 50)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initalSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initalSetup];
    }
    
    return self;
}

- (void)initalSetup {
    self.remainingTimeInSeconds = 0;
    self.totalTimeInSeconds = 0;
    
    self.running = NO;
    self.finished = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.timerProgressColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    self.timerProgressStartColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    self.timerProgressNearFinishedColor = [UIColor colorWithRed:1.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    self.timerProgressAlmostFinishedColor = [UIColor redColor];
    self.timerProgressFinishedColor = [UIColor darkGrayColor];
    
    [self createLayer];
    [self createLabel];
    [self createPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timerProgressLayer.frame = self.bounds;
}

#pragma mark - Timer methods

- (void)setTimerWithDuration:(NSInteger)durationInSeconds {
    self.remainingTimeInSeconds = durationInSeconds;
    self.totalTimeInSeconds = durationInSeconds;
    
    [self setProgress:1 animated:NO];
    [self updateLabel];
    [self setNeedsDisplay];
}

- (void)startTimer {
    [self startTick];
    
    self.running = YES;
    self.finished = NO;
}

- (void)startTimerWithDuration:(NSInteger)durationInSeconds {
    [self setTimerWithDuration:durationInSeconds];
    
    [self startTimer];
}

- (void)pauseTimer {
    [self invalidateTimer];
    
    self.running = NO;
}

- (void)stopTimer {
    self.remainingTimeInSeconds = 0;
    
    [self pauseTimer];
    
    self.timerProgressColor = self.timerProgressFinishedColor;
   
    [self updateLabel];
    [self updateProgress];
    [self setNeedsDisplay];
}

- (void)resetTimer {
    self.remainingTimeInSeconds = self.totalTimeInSeconds;
    
    [self pauseTimer];
    
    [self updateLabel];
    [self updateProgress];
    [self setNeedsDisplay];
}

- (void)restartTimer {
    [self resetTimer];
    
    [self startTimer];
}

#pragma mark - Accessors

- (NSInteger)remainingDurationInSeconds {
    return self.remainingTimeInSeconds;
}

- (NSInteger)totalDurationInSeconds {
    return self.totalTimeInSeconds;
}

#pragma mark - Timer Progress Methods

- (void)setProgress:(CGFloat)progress {
    
    progress = [self sanitizeProgressValue:progress];
    
    if (progress > 0) {
        self.remainingTimeInSeconds = (NSInteger)(self.totalTimeInSeconds * progress);
        [self.timerProgressLayer removeAnimationForKey:jsk_progressAnimationKey];
        
        [self setProgress:progress animated:NO];
    } else {
        [self stopTimer];
    }
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    progress = [self sanitizeProgressValue:progress];
    
    if (progress > 0.4) {
        self.timerProgressColor = self.timerProgressStartColor;
    } else if (progress > 0.15) {
        self.timerProgressColor = self.timerProgressNearFinishedColor;
    } else if (progress == 0) {
        self.timerProgressColor = self.timerProgressFinishedColor;
    } else {
        self.timerProgressColor = self.timerProgressAlmostFinishedColor;
    }
    
    if (progress > 0) {
        if (animated) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = progress == 0 ? @0 : nil;
            animation.toValue = [NSNumber numberWithFloat:progress];
            animation.duration = 1;
            self.timerProgressLayer.strokeEnd = progress;
            [self.timerProgressLayer addAnimation:animation forKey:jsk_progressAnimationKey];
        } else {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.timerProgressLayer.strokeEnd = progress;
            [CATransaction commit];
        }
    } else {
        self.timerProgressLayer.strokeEnd = 0.0f;
        [self.timerProgressLayer removeAnimationForKey:jsk_progressAnimationKey];
    }
    
    _progress = progress;
    
    [self updateLabel];
}

#pragma mark - Private Timer Methods

- (void)startTick {
    [self invalidateTimer];
    
    self.timerViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(id)sender {
    if (self.remainingTimeInSeconds <= 1) {
        [self stopTimer];
        
        self.finished = YES;
        
        if (self.delegate) {
            [self.delegate timerDidFinish];
        }
    } else {
        self.remainingTimeInSeconds -= 1;
        
        [self updateProgress];
    }
    
    [self updateLabel];
    [self setNeedsDisplay];
}

- (void)invalidateTimer {
    if (self.timerViewTimer) {
        [self.timerViewTimer invalidate];
        self.timerViewTimer = nil;
    }
}

- (CGFloat)sanitizeProgressValue:(CGFloat)progress {
    if (progress > 1) {
        progress = 1;
    } else if (progress < 0) {
        progress = 0;
    }
    
    return progress;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: (%ld of %ld sec remaining)", [super description], (long)self.remainingTimeInSeconds, (long)self.totalTimeInSeconds];
}

#pragma mark - Private Create UI Methods

- (void)createLabel {
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.text = @"0";
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [self.timerLabel sizeToFit];
    self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.timerLabel];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    [self addConstraints:@[centerXConstraint, centerYConstraint]];
}

- (void)createLayer {
    self.timerStrokeWidth = CGRectGetWidth(self.bounds) / 15;
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.path = self.timerStrokePath.CGPath;
    progressLayer.fillColor = [[UIColor clearColor] CGColor];
    progressLayer.lineWidth = self.timerStrokeWidth;
    progressLayer.strokeColor = [self.timerProgressStartColor CGColor];
    progressLayer.strokeEnd = 0;
    
    self.timerProgressLayer = progressLayer;
    
    [self.layer addSublayer:progressLayer];
}

- (void)createPath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.timerProgressLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width / 2 - 6 startAngle:-M_PI_2 endAngle:-M_PI_2 + 2 * M_PI clockwise:YES].CGPath;
}

#pragma mark - Private Update UI Methods

- (void)updateLabel {
    NSInteger numSeconds = self.remainingTimeInSeconds % 60;
    NSInteger numMinutes = self.remainingTimeInSeconds / 60;
    NSInteger numHours = self.remainingTimeInSeconds / 3600;
    
    if (numHours > 0) {
        self.timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)numHours, (long)numMinutes, (long)numSeconds];
    } else if (numMinutes > 0) {
        self.timerLabel.text = [NSString stringWithFormat:@"%01ld:%02ld", (long)numMinutes, (long)numSeconds];
    } else {
        self.timerLabel.text = [NSString stringWithFormat:@"%01ld", (long)numSeconds];
    }
}

- (void)updateProgress {
    CGFloat progress = ((CGFloat)(self.remainingTimeInSeconds) / self.totalTimeInSeconds);
    [self setProgress:progress animated:YES];
}

- (void)setTimerProgressColor:(UIColor *)timerProgressColor {
    _timerProgressColor = timerProgressColor;
    
    self.timerProgressLayer.strokeColor = timerProgressColor.CGColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.timerProgressColor.CGColor);
    CGContextSetLineWidth(context, self.timerStrokeWidth / 4);
    CGContextSetStrokeColorWithColor(context, self.timerProgressColor.CGColor);
    CGContextStrokeEllipseInRect(context, CGRectInset(self.bounds, 6, 6));
} 

@end
