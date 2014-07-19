CXSwipeGestureRecognizer
========================

UIGestureRecognizer subclass that takes much of the effort out of managing directional swipes.

    CXSwipeGestureRecognizer *gestureRecognizer = [[CXSwipeGestureRecognizer alloc] init];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];

✓ Keeps track of both the current direction and the direction the gesture was started in.

    if (gestureRecognizer.initialDirection == CXSwipeGestureDirectionUpwards) {
        if (gestureRecognizer.currentDirection == CXSwipeGestureDirectionDownwards) {
            NSLog(@"Gesture recognizer started swiping upwards and then changed direction");
        }
    }

✓ Delegate protocol methods for `start`, `update`, `cancel`, and `finish`.
    
    - (void)gestureRecognizerDidStart:(CXSwipeGestureRecognizer *)gestureRecognizer
    {
        NSLog("Gesture recognizer started");
    }
    
    - (void)gestureRecognizerDidUpdate:(CXSwipeGestureRecognizer *)gestureRecognizer
    {
        NSLog("Gesture recognizer updated");
    }
    
    - (void)gestureRecognizerDidCancel:(CXSwipeGestureRecognizer *)gestureRecognizer
    {
        NSLog("Gesture recognizer cancelled");
    }
    
    - (void)gestureRecognizerDidFinish:(CXSwipeGestureRecognizer *)gestureRecognizer
    {
        NSLog("Gesture recognizer finished");
    }

✓ Convenience methods for `location`, `translation`, `velocity`, and `progress` (note that these work by calling `locationInView:` etc on `self.view.superview`, in case you are using the gesture recognizer to translate the view directly underneath itself).

    NSLog(@"location: %f", gestureRecognizer.location);
    NSLog(@"translation: %f", gestureRecognizer.translation);
    NSLog(@"velocity: %f", gestureRecognizer.velocity);
    NSLog(@"progress: %f", gestureRecognizer.progress);

✓ Delegate method for bouncing (returning `YES` causes the `progress` value to be halved, useful when emulating a UIScrollView-style bounce effect).

    /* Bounces the gesture if it has moved backwards past its origin */
    - (BOOL)gestureRecognizerShouldBounce:(CXSwipeGestureRecognizer *)gestureRecognizer
    {
        return gestureRecognizer.translation < 0.0f;
    }

    /* Cancels the gesture if it has moved than 32 pixels, or if it is moving in the wrong direction */
    - (BOOL)gestureRecognizerShouldCancel:(CXSwipeGestureRecognizer *)gestureRecognizer
    {
        return gestureRecognizer.translation < 32.0f && gestureRecognizer.velocity < 0.0f;
    }