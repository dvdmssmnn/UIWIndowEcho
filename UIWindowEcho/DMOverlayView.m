//
//  DMOverlayView.m
//  UIWindowEcho
//
//  Created by David Missmann on 08.10.16.
//  Copyright © 2016 David Missmann. All rights reserved.
//

#import "DMOverlayView.h"

static NSString *const kFadeOutAnimationKey = @"animationFadeOut";
static NSString *const kPulseAnimationKey = @"animationPulse";

static const CFTimeInterval kTouchBeganAnimationTime = 1.0;
static const CGFloat kPointRadius = 10.0;

@interface DMOverlayView ()

@property (nonatomic) CAAnimation *fadeOutAnimation;
@property (nonatomic) CAAnimation *pulseAnimation;

@end

@implementation DMOverlayView

- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        self.layer.zPosition = CGFLOAT_MAX;
        
        self.backgroundColor = [UIColor clearColor];
        
        _fadeOutAnimation = [self createFadeOutAnimation];
        _pulseAnimation = [self createPulseAnimation];
    }
    return self;
}

- (void)addEvent:(UIEvent *)event {
    self.frame = self.superview.frame;
    [self.layer removeAllAnimations];
    self.alpha = 1.0;
    
    
    for (UITouch *touch in event.allTouches) {
        if (touch.phase == UITouchPhaseBegan) {
            [self addTouchBeganLayer:touch];
            continue;
        }
    }
}

- (void)addTouchBeganLayer:(UITouch *)touch {
    CGPoint pos = [touch locationInView:self];
    
    CAShapeLayer *circle = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                                        radius:kPointRadius
                                                    startAngle:0
                                                      endAngle:2 * M_PI
                                                     clockwise:YES];
    circle.path = path.CGPath;
    circle.position = CGPointMake(pos.x - kPointRadius / 2,
                                  pos.y - kPointRadius / 2);
    circle.fillColor = [UIColor redColor].CGColor;
    
    [circle addAnimation:self.fadeOutAnimation
                  forKey:kFadeOutAnimationKey];
    
    [circle addAnimation:self.pulseAnimation
                  forKey:kPulseAnimationKey];
    
    [self.layer addSublayer:circle];
}

- (CAAnimation *)createFadeOutAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.0);
    animation.duration = kTouchBeganAnimationTime;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    return animation;
}


- (CAAnimation *)createPulseAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = kTouchBeganAnimationTime;
    animation.values = @[@(1.0), @(0.7), @(1.0)];
    animation.keyTimes = @[@(0.0), @(0.2), @(0.7)];
    
    
    return animation;
}

#pragma mark CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!flag) {
        return;
    }
    
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer animationForKey:kFadeOutAnimationKey] == anim) {
            [layer removeFromSuperlayer];
            return;
        }
    }
}

@end
