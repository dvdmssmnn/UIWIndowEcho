//
//  UIWindow+Echo.m
//  UIWindowEcho
//
//  Created by David Missmann on 08.10.16.
//  Copyright © 2016 David Missmann. All rights reserved.
//

#import "UIWindow+Echo.h"
#import <objc/runtime.h>
#import "DMOverlayView.h"

static DMOverlayView *overlay = nil;

__attribute__((constructor))
static void initialize_UIWindow() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        overlay = [[DMOverlayView alloc] init];
    });
    
    id uiWindowClass = objc_getClass("UIWindow");
    
    Method origSendEvent = class_getInstanceMethod(uiWindowClass, @selector(sendEvent:));
    Method echoSendEvent = class_getInstanceMethod(uiWindowClass, @selector(echoSendEvent:));
    
    method_exchangeImplementations(origSendEvent, echoSendEvent);
}

@implementation UIWindow (Echo)

- (void)echoSendEvent:(UIEvent *)event {
    [self echoSendEvent:event];
    
    // TODO removing this every time is probably not needed
    [overlay removeFromSuperview];
    [self addSubview:overlay];
    [overlay addEvent:event];
}

@end
