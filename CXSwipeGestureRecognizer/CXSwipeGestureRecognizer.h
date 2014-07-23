//
//  CXSwipeGestureRecognizer.h
//  CALX
//
//  Created by Daniel Clelland on 24/06/14.
//  Copyright (c) 2014 Daniel Clelland. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CXSwipeGestureDirectionNone = 0,
    CXSwipeGestureDirectionDownwards = 1 << 0,
    CXSwipeGestureDirectionLeftwards = 1 << 1,
    CXSwipeGestureDirectionUpwards = 1 << 2,
    CXSwipeGestureDirectionRightwards = 1 << 3
} CXSwipeGestureDirection;

@class CXSwipeGestureRecognizer;

@protocol CXSwipeGestureRecognizerDelegate <UIGestureRecognizerDelegate>

@optional

- (void)gestureRecognizerDidStart:(CXSwipeGestureRecognizer *)gestureRecognizer;
- (void)gestureRecognizerDidUpdate:(CXSwipeGestureRecognizer *)gestureRecognizer;
- (void)gestureRecognizerDidCancel:(CXSwipeGestureRecognizer *)gestureRecognizer;
- (void)gestureRecognizerDidFinish:(CXSwipeGestureRecognizer *)gestureRecognizer;

- (BOOL)gestureRecognizerShouldCancel:(CXSwipeGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizerShouldBounce:(CXSwipeGestureRecognizer *)gestureRecognizer;

@end

@interface CXSwipeGestureRecognizer : UIPanGestureRecognizer

@property (unsafe_unretained) id<CXSwipeGestureRecognizerDelegate> delegate;

- (CXSwipeGestureDirection)initialDirection;
- (CXSwipeGestureDirection)currentDirection;

- (CGFloat)locationInDirection:(CXSwipeGestureDirection)direction;
- (CGFloat)translationInDirection:(CXSwipeGestureDirection)direction;
- (CGFloat)velocityInDirection:(CXSwipeGestureDirection)direction;
- (CGFloat)progressInDirection:(CXSwipeGestureDirection)direction;

- (CGFloat)location;
- (CGFloat)translation;
- (CGFloat)velocity;
- (CGFloat)progress;

@end
