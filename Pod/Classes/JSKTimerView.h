// JSKTimerView.h
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

#import <UIKit/UIKit.h>

@class JSKTimerView;

/**
 `JSKTimerViewDelegate` is a protocol which a `JSKTimerView` instance will use to call timerDidFinish when the timer has finished
 */
@protocol JSKTimerViewDelegate <NSObject>

/**
 This delegate method is called when the timer has naturally finished (i.e. timerProgress was not manually set to 0)
 */
- (void)timerDidFinish:(JSKTimerView *)timerView;

@end


/**
 `JSKTimerView` is a custom UIView class which represents a simple, self-contained timer with different color states based on how close the timer is to finishing.
 */
@interface JSKTimerView : UIView

/**
 The current timer progress with a range between 0 and 1
 */
@property (nonatomic, assign) CGFloat progress;

/**
 Whether or not the timer is currently running
 */
@property (readonly, nonatomic, getter=isRunning) BOOL running;

/**
 Whether or not the timer has naturally finished
 
 @warning Setting timerProgress to zero will not set finished to true
 */
@property (readonly, nonatomic, getter=isFinished) BOOL finished;

/**
 The text color of the UILabel with the time remaining
 */
@property (nonatomic, strong) UIColor *labelTextColor;

/**
 The delegate called when the timer has naturally finished
 */
@property (nonatomic, weak) id<JSKTimerViewDelegate> delegate;


///-----------------------------------------------------------
/// @name Timer Methods
///-----------------------------------------------------------

/**
 Sets the duration of the timer and updates the progress to 1.
 
 @param durationInSeconds The number of seconds the timer is set for.
 
 @warning This does *not* start the timer
 */
- (void)setTimerWithDuration:(NSInteger)durationInSeconds;

/**
 Starts the timer.
 */
- (void)startTimer;

/**
 Starts the timer with the given duration in seconds.
 
 @param durationInSeconds The number of seconds the timer is set for.
 */
- (void)startTimerWithDuration:(NSInteger)durationInSeconds;


/**
 Starts the timer with a given end date.
 
 @param endDate The date the timer should end.
 
 @return Returns true if the given date is in the future
 */
- (BOOL)startTimerWithEndDate:(NSDate *)endDate;

/**
 Pauses the timer.
 
 @note Start the timer again with `startTimer`.
 */
- (void)pauseTimer;

/**
 Stops the timer.
 
 @note This animates the remaining seconds to zero.
 */
- (void)stopTimer;

/**
 Resets the timer to the original duration.
 */
- (void)resetTimer;

/**
 Resets the timer to the original duration and starts it.
 */
- (void)restartTimer;

///-----------------------------------------------------------
/// @name Accessor Methods
///-----------------------------------------------------------

/**
 The remaining number of seconds left in the timer
 */
- (NSInteger)remainingDurationInSeconds;

/**
 The start number of seconds in the timer
 */
- (NSInteger)totalDurationInSeconds;

@end
