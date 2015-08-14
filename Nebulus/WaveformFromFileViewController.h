//
//  WaveformFromFileViewController.h
//  EZAudioWaveformFromFileExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2015 Syed Haris Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLMoveMeView.h"

// Import EZAudio header
#import "EZAudio.h"

/**
 Here's the default audio file included with the example
 */
#define kAudioFileDefault [[NSBundle mainBundle] pathForResource:@"simple-drum-beat" ofType:@"wav"]
#define kAudioFile1 [[NSBundle mainBundle] pathForResource:@"track1" ofType:@"wav"]
#define kAudioFile2 [[NSBundle mainBundle] pathForResource:@"track2" ofType:@"wav"]
#define kAudioFile3 [[NSBundle mainBundle] pathForResource:@"track3" ofType:@"wav"]
#define kAudioFile4 [[NSBundle mainBundle] pathForResource:@"track4" ofType:@"wav"]

@interface WaveformFromFileViewController : UIViewController

#pragma mark - Components
/**
 The EZAudioFile representing of the currently selected audio file
 */
@property (nonatomic,strong) EZAudioFile *audioFile1;
@property (nonatomic,strong) EZAudioFile *audioFile2;
@property (nonatomic,strong) EZAudioFile *audioFile3;
@property (nonatomic,strong) EZAudioFile *audioFile4;

/**
 The CoreGraphics based audio plot
 */
@property (nonatomic,strong) IBOutlet EZAudioPlot *audioPlot1;
@property (nonatomic,strong) IBOutlet EZAudioPlot *audioPlot2;
@property (nonatomic,strong) IBOutlet EZAudioPlot *audioPlot3;
@property (nonatomic,strong) IBOutlet EZAudioPlot *audioPlot4;

@property (nonatomic, strong) IBOutlet APLMoveMeView *moveMeView;


/**
 A BOOL indicating whether or not we've reached the end of the file
 */
@property (nonatomic,assign) BOOL eof;

#pragma mark - UI Extras
/**
 A label to display the current file path with the waveform shown
 */
@property (nonatomic,weak) IBOutlet UILabel *filePathLabel;

@property (nonatomic,strong) AVPlayer* player;
@property (nonatomic,strong) AVMutableComposition* composition;
@property (nonatomic,strong) NSMutableDictionary* audioMixValues;  // track name -> volume level 0.0 - 1.0
@property (nonatomic,strong) NSMutableDictionary* audioMixTrackIDs; // track name -> track ID



@end
