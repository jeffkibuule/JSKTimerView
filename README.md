# JSKTimerView

[![CI Status](http://img.shields.io/travis/jeffkibuule/JSKTimerView.svg?style=flat)](https://travis-ci.org/jeffkibuule/JSKTimerView)
[![Version](https://img.shields.io/cocoapods/v/JSKTimerView.svg?style=flat)](http://cocoadocs.org/docsets/JSKTimerView)
[![License](https://img.shields.io/cocoapods/l/JSKTimerView.svg?style=flat)](http://cocoadocs.org/docsets/JSKTimerView)
[![Platform](https://img.shields.io/cocoapods/p/JSKTimerView.svg?style=flat)](http://cocoadocs.org/docsets/JSKTimerView)

![GIF][gif0]

![Screenshot0][img0] 
![Screenshot1][img1]
![Screenshot2][img2]
![Screenshot3][img3]

JSKTimerView is a simple custom UIView that acts as a self-contained, animating timer.

* Set up timer based in seconds
* Start timer and have it animate automatically
* Full control of timer: start, pause, stop, reset, and reset
* Manually set timer progress and have timer update accordingly
* Get notified when timer has finished
* iOS 7+ and up

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 7.0+
* ARC

## Installation

JSKTimerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "JSKTimerView"

# Getting Started

````objective-c
#import <JSKTimerView/JSKTimerView.h>    // Import the relevant header
````

Create a 60-sec timer
```objective-c
JSKTimerView *timerView = [[JSKTimerView alloc] init];
[timerView setTimerWithDuration:60];
```

Start a timer
```objective-c
[timerView startTimer];
```

Pause a timer
```objective-c
[timerView pauseTimer];
```

Stop a timer
```objective-c
[timerView stopTimer];
```

Reset a timer
```objective-c
[timerView resetTimer];
```

Restart a timer
```objective-c
[timerView restartTimer];
```

Set timer progress manually 
```objective-c
// Progress should be a value between 0 and 1, timer value updates automatically
timerView.progress = 0.5;
```

Know when the timer naturally ends
```objective-c
// Assume self refers to object that implements timerDidFinish method of JSKTimerViewDelegate
timerView.setDelegate = self;

- (void)timerDidFinish {
    NSLog(@"Timer finished");
}
```

## Author

Joefrey Kibuule, jeff.kibuule@outlook.com

## License

JSKTimerView is available under the MIT license. See the LICENSE file for more info.

>**Copyright &copy; 2015 Joefrey Kibuule.**

*Please provide attribution, it is greatly appreciated.*

[gif0]:https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Pod/Assets/jsktimerview.gif
[img0]:https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Pod/Assets/img0.png
[img1]:https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Pod/Assets/img1.png
[img2]:https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Pod/Assets/img2.png
[img3]:https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Pod/Assets/img3.png
