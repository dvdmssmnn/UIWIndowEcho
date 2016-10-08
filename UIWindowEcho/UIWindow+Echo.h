//
//  UIWindow+Echo.h
//  UIWindowEcho
//
//  Created by David Missmann on 08.10.16.
//  Copyright © 2016 David Missmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Echo)

- (void)echoSendEvent:(UIEvent *)event;

@end
