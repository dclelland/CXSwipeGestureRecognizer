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
        case CXSwipeGestureDirectionDownwards: {
            return point.y;
        }
        case CXSwipeGestureDirectionLeftwards: {
            return -point.x;
        }
        case CXSwipeGestureDirectionUpwards: {
            return -point.y;
        }
        case CXSwipeGestureDirectionRightwards: {
            return point.x;
        }
        case CXSwipeGestureDirectionHorizontal: {
            return fabs(point.x);
        }
        case CXSwipeGestureDirectionVertical: {
            return fabs(point.y);
        }
        case CXSwipeGestureDirectionAll: {
            return hypot(point.x, point.y);
        }
        default: {
            return 0.0f;
        }
    }
}

CGFloat CGPointValueInRectInDirection(CGPoint point, CGRect rect, CXSwipeGestureDirection direction)
{
    switch (direction) {
        case CXSwipeGestureDirectionDownwards: {
            return CGRectGetMinY(rect) + point.y;
        }
        case CXSwipeGestureDirectionLeftwards: {
            return CGRectGetMaxX(rect) - point.x;
        }
        case CXSwipeGestureDirectionUpwards: {
            return CGRectGetMaxY(rect) - point.y;
        }
        case CXSwipeGestureDirectionRightwards: {
            return CGRectGetMinX(rect) + point.x;
        }
        case CXSwipeGestureDirectionHorizontal: {
            CGFloat downwards = CGPointValueInRectInDirection(point, rect, CXSwipeGestureDirectionDownwards);
            CGFloat upwards = CGPointValueInRectInDirection(point, rect, CXSwipeGestureDirectionUpwards);
            return MIN(downwards, upwards);
        }
        case CXSwipeGestureDirectionVertical: {
            CGFloat leftwards = CGPointValueInRectInDirection(point, rect, CXSwipeGestureDirectionLeftwards);
            CGFloat rightwards = CGPointValueInRectInDirection(point, rect, CXSwipeGestureDirectionRightwards);
            return MIN(leftwards, rightwards);
        }
        case CXSwipeGestureDirectionAll: {
            CGFloat horizontal = CGPointValueInRectInDirection(point, rect, CXSwipeGestureDirectionHorizontal);
            CGFloat vertical = CGPointValueInRectInDirection(point, rect, CXSwipeGestureDirectionVertical);
            CGFloat multiplier = CGRectContainsPoint(rect, point) ? 1.0f : -1.0f;
            return hypot(horizontal, vertical) * multiplier;
        }
        default: {
            return 0.0f;
        }
    }
}

CGFloat CGRectValueInDirection(CGRect rect, CXSwipeGestureDirection direction)
{
    switch (direction) {
        case CXSwipeGestureDirectionUpwards:
        case CXSwipeGestureDirectionDownwards:
        case CXSwipeGestureDirectionVertical: {
            return CGRectGetHeight(rect);
        }
        case CXSwipeGestureDirectionLeftwards:
        case CXSwipeGestureDirectionRightwards:
        case CXSwipeGestureDirectionHorizontal: {
            return CGRectGetWidth(rect);
        }
        case CXSwipeGestureDirectionAll: {
            return hypot(CGRectGetWidth(rect), CGRectGetHeight(rect));
        }
        default: {
            return 0.0f;
        }
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

#pragma mark - Location

- (CGFloat)location
{
    return [self locationInDirection:self.initialDirection];
}

- (CGFloat)locationInDirection:(CXSwipeGestureDirection)direction
{
    return [self locationInDirection:direction inView:self.view.superview];
}

- (CGFloat)locationInDirection:(CXSwipeGestureDirection)direction inView:(UIView *)view
{
    return CGPointValueInRectInDirection([self locationInView:view], self.view.frame, direction);
}

#pragma mark - Translation

- (CGFloat)translation
{
    return [self translationInDirection:self.initialDirection];
}

- (CGFloat)translationInDirection:(CXSwipeGestureDirection)direction
{
    return [self translationInDirection:direction inView:self.view.superview];
}

- (CGFloat)translationInDirection:(CXSwipeGestureDirection)direction inView:(UIView *)view
{
    return CGPointValueInDirection([self translationInView:view], direction);
}

#pragma mark - Velocity

- (CGFloat)velocity
{
    return [self velocityInDirection:self.initialDirection];
}

- (CGFloat)velocityInDirection:(CXSwipeGestureDirection)direction
{
    return [self velocityInDirection:direction inView:self.view.superview];
}

- (CGFloat)velocityInDirection:(CXSwipeGestureDirection)direction inView:(UIView *)view
{
    return CGPointValueInDirection([self velocityInView:view], direction);
}

#pragma mark - Progress

- (CGFloat)progress
{
    return [self progressInDirection:self.initialDirection];
}

- (CGFloat)progressInDirection:(CXSwipeGestureDirection)direction
{
    return [self progressInDirection:direction inView:self.view.superview];
}

- (CGFloat)progressInDirection:(CXSwipeGestureDirection)direction inView:(UIView *)view
{
    CGFloat maximum = CGRectValueInDirection(view.frame, direction);
    return maximum ? self.translation * self.bounceFactor / maximum : 0.0f;
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
