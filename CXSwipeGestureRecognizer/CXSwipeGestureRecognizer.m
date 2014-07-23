//
//  CXSwipeGestureRecognizer.m
//  CALX
//
//  Created by Daniel Clelland on 5/06/14.
//  Copyright (c) 2014 Daniel Clelland. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

#import "CXSwipeGestureRecognizer.h"

CGFloat CGPointValueInDirection(CGPoint point, CXSwipeGestureDirection direction);
CGFloat CGPointValueInRectInDirection(CGPoint point, CGRect rect, CXSwipeGestureDirection direction);
CGFloat CGRectValueInDirection(CGRect rect, CXSwipeGestureDirection direction);

CGFloat CGPointValueInDirection(CGPoint point, CXSwipeGestureDirection direction)
{
    switch (direction) {
        case CXSwipeGestureDirectionUpwards: return -point.y;
        case CXSwipeGestureDirectionDownwards: return point.y;
        case CXSwipeGestureDirectionLeftwards: return -point.x;
        case CXSwipeGestureDirectionRightwards: return point.x;
        default: return 0.0f;
    }
}

CGFloat CGPointValueInRectInDirection(CGPoint point, CGRect rect, CXSwipeGestureDirection direction)
{
    switch (direction) {
        case CXSwipeGestureDirectionUpwards: return CGRectGetMaxY(rect) - point.y;
        case CXSwipeGestureDirectionDownwards: return CGRectGetMinY(rect) + point.y;
        case CXSwipeGestureDirectionLeftwards: return CGRectGetMaxX(rect) - point.x;
        case CXSwipeGestureDirectionRightwards: return CGRectGetMinX(rect) + point.x;
        default: return 0.0f;
    }
}

CGFloat CGRectValueInDirection(CGRect rect, CXSwipeGestureDirection direction)
{
    switch (direction) {
        case CXSwipeGestureDirectionUpwards: return CGRectGetHeight(rect);
        case CXSwipeGestureDirectionDownwards: return CGRectGetHeight(rect);
        case CXSwipeGestureDirectionLeftwards: return CGRectGetWidth(rect);
        case CXSwipeGestureDirectionRightwards: return CGRectGetWidth(rect);
        default: return 0.0f;
    }
}

@interface CXSwipeGestureRecognizer ()

@property (nonatomic) CXSwipeGestureDirection initialDirection;

- (void)onSwipe:(CXSwipeGestureRecognizer *)gestureRecognizer;

- (CGFloat)bounceFactor;

@end

@implementation CXSwipeGestureRecognizer

- (instancetype)init
{
    self = [super initWithTarget:self action:@selector(onSwipe:)];
    if (self) {
        self.initialDirection = CXSwipeGestureDirectionNone;
    }
    return self;
}

- (void)reset
{
    [super reset];
    self.initialDirection = CXSwipeGestureDirectionNone;
}

#pragma mark - Getters

- (CXSwipeGestureDirection)currentDirection
{
    CGPoint translation = [self translationInView:self.view.superview];
    
    if (CGPointEqualToPoint(translation, CGPointZero)) {
        return CXSwipeGestureDirectionNone;
    } else if (fabsf(translation.x) < fabsf(translation.y)) {
        return translation.y > 0.0f ? CXSwipeGestureDirectionDownwards: CXSwipeGestureDirectionUpwards;
    } else {
        return translation.x > 0.0f ? CXSwipeGestureDirectionRightwards: CXSwipeGestureDirectionLeftwards;
    }
}

- (CGFloat)locationInDirection:(CXSwipeGestureDirection)direction
{
    return CGPointValueInRectInDirection([self locationInView:self.view.superview], self.view.frame, direction);
}

- (CGFloat)translationInDirection:(CXSwipeGestureDirection)direction
{
    return CGPointValueInDirection([self translationInView:self.view.superview], direction);
}

- (CGFloat)velocityInDirection:(CXSwipeGestureDirection)direction
{
    return CGPointValueInDirection([self velocityInView:self.view.superview], direction);
}

- (CGFloat)progressInDirection:(CXSwipeGestureDirection)direction
{
    CGFloat maximum = CGRectValueInDirection(self.view.frame, direction);
    return maximum ? self.translation * self.bounceFactor / maximum : 0.0f;
}

- (CGFloat)location
{
    return [self locationInDirection:self.initialDirection];
}

- (CGFloat)translation
{
    return [self translationInDirection:self.initialDirection];
}

- (CGFloat)velocity
{
    return [self velocityInDirection:self.initialDirection];
}

- (CGFloat)progress
{
    return [self progressInDirection:self.initialDirection];
}

#pragma mark - Actions

- (void)onSwipe:(CXSwipeGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.initialDirection = self.currentDirection;
            if ([gestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerDidStart:)]) {
                [gestureRecognizer.delegate gestureRecognizerDidStart:gestureRecognizer];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if ([gestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerDidUpdate:)]) {
                [gestureRecognizer.delegate gestureRecognizerDidUpdate:gestureRecognizer];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            if ([gestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerDidCancel:)]) {
                [gestureRecognizer.delegate gestureRecognizerDidCancel:gestureRecognizer];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ([gestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerShouldCancel:)]
                && [gestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerDidCancel:)]
                && [gestureRecognizer.delegate gestureRecognizerShouldCancel:self]) {
                [gestureRecognizer.delegate gestureRecognizerDidCancel:gestureRecognizer];
            } else if ([gestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerDidFinish:)]) {
                [gestureRecognizer.delegate gestureRecognizerDidFinish:gestureRecognizer];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

- (CGFloat)bounceFactor
{
    if ([self.delegate respondsToSelector:@selector(gestureRecognizerShouldBounce:)]) {
        return [self.delegate gestureRecognizerShouldBounce:self] ? 0.5f : 1.0f;
    } else {
        return 1.0f;
    }
}

@end
