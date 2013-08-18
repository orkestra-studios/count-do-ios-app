//
//  CDProgressView.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDProgressView : UIView
{
    NSTimer *timer;
    BOOL animation;
}

@property (strong, nonatomic) NSNumber *angle;
@property (strong, nonatomic) NSNumber *tangle;

- (void) increment;
- (void) stopAnimation;
@end
