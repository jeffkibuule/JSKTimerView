//
//  JSKTimerViewTests.m
//  JSKTimerViewTests
//
//  Created by Joefrey Kibuule on 2/3/15.
//  Copyright (c) 2015 Joefrey Kibuule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#include "JSKTimerView.h"

@interface JSKTimerViewTests : XCTestCase

@end

@implementation JSKTimerViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatInitCreatesAnObject {
    // Given
    // nothing
    
    // When
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // Then
    XCTAssertNotNil(timerView, "Timer view should not be nil");
}

- (void)testThatSetTimerDurationDoesntCauseTimerToRun {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    [timerView setTimerWithDuration:5];
    
    // Then
    XCTAssertFalse(timerView.isRunning, "Timer view should not be running without call to `startTimer`");
}

- (void)testThatSetProgressCantBeBelowZero {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    [timerView setTimerWithDuration:5];
    
    // When
    timerView.progress = -10;
    
    // Then
    XCTAssertNotEqual(timerView.progress, -10, "Timer view progress should not be below zero");
    XCTAssertEqual(timerView.progress, 0, "Timer view progress should be zero when set to below zero");
}

- (void)testThatSetProgressCantBeAboveOne {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    [timerView setTimerWithDuration:5];
    
    // When
    timerView.progress = 10;
    
    // Then
    XCTAssertNotEqual(timerView.progress, 10, "Timer view progress should not be above one");
    XCTAssertEqual(timerView.progress, 1, "Timer view progress should be one when set to above one");
}

- (void)testThatSetProgressChangesDuration {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    [timerView setTimerWithDuration:10];
    
    // When
    timerView.progress = 0.5;
    
    // Then
    XCTAssertEqual([timerView remainingDurationInSeconds], 5, "Changing timer view progress should change remaining duration in seconds");
    XCTAssertEqual([timerView totalDurationInSeconds], 10, "Change timer view progress should not change total timer duration in seconds");
}

- (void)testThatStartTimerTriggersTimerToRun {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    [timerView setTimerWithDuration:5];
    [timerView startTimer];
    
    // Then
    XCTAssertTrue(timerView.isRunning, "Timer view should be running after call to `startTimer`");
    XCTAssertFalse(timerView.isFinished, "Timer view should not be finished after call to `startTimer`");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatStartTimerWithDurationTriggersTimerToRun {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    [timerView startTimerWithDuration:5];
    
    // Then
    XCTAssertTrue(timerView.isRunning, "Timer view should be running after call to `startTimerWithDuration`");
    XCTAssertFalse(timerView.isFinished, "Timer view should not be finished after call to `startTimerWithDuration`");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatStartTimerWithEndDateInFutureTriggersTimerToRun {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    BOOL dateInFuture = [timerView startTimerWithEndDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
    // Then
    XCTAssertTrue(dateInFuture, "Timer view should return true if call to `startTimerWithEndDate` date is in future");
    XCTAssertTrue(timerView.isRunning, "Timer view should be running after call to `startTimerWithEndDate` date if date is in future");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatStartTimerWithEndDateNotInFutureDoesntTriggerTimerToRun {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    BOOL dateInFuture = [timerView startTimerWithEndDate:[NSDate dateWithTimeIntervalSinceNow:-5]];
    
    // Then
    XCTAssertFalse(dateInFuture, "Timer view should return false if call to `startTimerWithEndDate` date is not in future");
    XCTAssertFalse(timerView.isRunning, "Timer view should not be running after call to `startTimerWithEndDate` date is not in future");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatPauseTimerPausesTimer {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    [timerView setTimerWithDuration:5];
    [timerView startTimer];
    [timerView pauseTimer];
    
    // Then
    XCTAssertFalse(timerView.isRunning, "Timer view should not be running after call to `pauseTimer`");
    XCTAssertFalse(timerView.isFinished, "Timer view should not be finished after call to `pauseTimer`");
    XCTAssertGreaterThan([timerView remainingDurationInSeconds], 0, "Timer view should have remaining seconds greater than zero after immediate call to `pauseTimer`");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatStopTimerStopsTimer {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    
    // When
    [timerView setTimerWithDuration:5];
    [timerView startTimer];
    [timerView stopTimer];
    
    // Then
    XCTAssertFalse(timerView.isRunning, "Timer view should not be running after call to `stopTimer`");
    XCTAssertFalse(timerView.isFinished, "Timer view should not be finished after call to `stopTimer`");
    XCTAssertEqual([timerView remainingDurationInSeconds], 0, "Timer view should have remaining seconds equal to zero after call to `stopTimer`");
}

- (void)testThatResetTimerResetsTimer {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    NSInteger timerDuration = 5;
    
    // When
    [timerView setTimerWithDuration:timerDuration];
    [timerView startTimer];
    [timerView stopTimer];
    [timerView resetTimer];
    
    // Then
    XCTAssertFalse(timerView.isRunning, "Timer view should not be running after call to `resetTimer`");
    XCTAssertFalse(timerView.isFinished, "Timer view should not be finished after call to `resetTimer`");
    XCTAssertEqual([timerView remainingDurationInSeconds], timerDuration, "Timer view should have remaining duration in seconds equal to total duration after call to `resetTimer`");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatRestartTimerRestartsTimer {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    NSInteger timerDuration = 5;
    
    // When
    [timerView setTimerWithDuration:timerDuration];
    [timerView startTimer];
    [timerView stopTimer];
    [timerView restartTimer];
    
    // Then
    XCTAssertTrue(timerView.isRunning, "Timer view should be running after call to `restartTimer`");
    XCTAssertFalse(timerView.isFinished, "Timer view should not be finished after call to `restartTimer`");
    XCTAssertEqual([timerView remainingDurationInSeconds], timerDuration, "Timer view should have remaining duration in seconds equal to start duration after call to `restartTimer`");
    
    // Cleanup
    [timerView stopTimer];
}

- (void)testThatDelegateFiresWhenTimerIsFinished {
    // Given
    JSKTimerView *timerView = [[JSKTimerView alloc] init];
    [timerView setTimerWithDuration:2];
    XCTestExpectation *expectation = [self expectationWithDescription:@"timerDidFinish"];
    
    // When
    id mockDelegate = OCMProtocolMock(@protocol(JSKTimerViewDelegate));
    timerView.delegate = mockDelegate;
    OCMStub([mockDelegate timerDidFinish]).andDo(^(NSInvocation *invocation) {
        XCTAssertFalse(timerView.isRunning, "Timer view should not be running during delegate call `timerDidFinish`");
        XCTAssertTrue(timerView.isFinished, "Timer view should be finished during delegate call `timerDidFinish`");
        XCTAssertEqual([timerView remainingDurationInSeconds], 0, "Timer view should have zero remaining seconds during delegate call `timerDidFinish`");
        
        [expectation fulfill];
    });
    [timerView startTimer];
    
    // Then
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timer view did not call delegate with method `timerDidFinish` within expected time, got error: %@", error);
        }
        
        // Cleanup
        [timerView stopTimer];
    }];
}

@end
