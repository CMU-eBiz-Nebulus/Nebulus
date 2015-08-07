//
//  WaveformFromFileViewController.m
//  EZAudioWaveformFromFileExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2015 Syed Haris Ali. All rights reserved.
//

#import "WaveformFromFileViewController.h"

@implementation WaveformFromFileViewController

//------------------------------------------------------------------------------
#pragma mark - Status Bar Style
//------------------------------------------------------------------------------

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//------------------------------------------------------------------------------
#pragma mark - Customize the Audio Plot
//------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];

    //
    // Customizing the audio plot's look
    //
    // Background color
    [self loadAudioPlot:self.audioPlot1 number:1];
    [self loadAudioPlot:self.audioPlot2 number:2];
    [self loadAudioPlot:self.audioPlot3 number:3];
    [self loadAudioPlot:self.audioPlot4 number:4];
    
    
    
    
    
    
}

-(void)loadAudioPlot:(EZAudioPlot*)audioPlot number:(NSInteger)number{
    audioPlot = [[EZAudioPlot alloc] initWithFrame:CGRectMake(30, 90*number, self.view.frame.size.width-30, 60)];
    
    
    audioPlot.backgroundColor = [UIColor colorWithRed: 0.169 green: 0.643 blue: 0.675 alpha: 1];
    // Waveform color
    audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    audioPlot.plotType        = EZPlotTypeBuffer;
    // Fill
    audioPlot.shouldFill      = YES;
    // Mirror
    audioPlot.shouldMirror    = YES;
    // No need to optimze for realtime
    audioPlot.shouldOptimizeForRealtimePlot = NO;
    // Customize the layer with a shadow for fun
    audioPlot.waveformLayer.shadowOffset = CGSizeMake(0.0, 1.0);
    audioPlot.waveformLayer.shadowRadius = 0.0;
    audioPlot.waveformLayer.shadowColor = [UIColor colorWithRed: 0.069 green: 0.543 blue: 0.575 alpha: 1].CGColor;
    audioPlot.waveformLayer.shadowOpacity = 1.0;
    
    //
    // Load in the sample file
    //
    switch (number){
        case 1:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile1] audioPlot:audioPlot number:1] ;
            break;
        case 2:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile2] audioPlot:audioPlot number:2];
            break;
        case 3:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile3] audioPlot:audioPlot number:3];
            break;
        case 4:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile4] audioPlot:audioPlot number:4];
            break;

    }
    
    [self.view addSubview:audioPlot];


}

//------------------------------------------------------------------------------
#pragma mark - Action Extensions
//------------------------------------------------------------------------------

- (void)openFileWithFilePathURL:(NSURL*)filePathURL audioPlot:(EZAudioPlot*)audioPlot number:(NSInteger)number
{
    self.eof                = NO;
    self.filePathLabel.text = filePathURL.lastPathComponent;
    
    // Plot the whole waveform
    audioPlot.plotType     = EZPlotTypeBuffer;
    audioPlot.shouldFill   = YES;
    audioPlot.shouldMirror = YES;
    switch(number){
        case 1:{self.audioFile1         = [EZAudioFile audioFileWithURL:filePathURL];
            [self.audioFile1 getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                                  int length)
             {
                 [audioPlot updateBuffer:waveformData[0]
                          withBufferSize:length];
             }];

            break;}
        case 2:{
            self.audioFile2         = [EZAudioFile audioFileWithURL:filePathURL];
            [self.audioFile2 getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                                  int length)
             {
                 [audioPlot updateBuffer:waveformData[0]
                          withBufferSize:length];
             }];

            break;}

        case 3:{
            self.audioFile3         = [EZAudioFile audioFileWithURL:filePathURL];
            [self.audioFile3 getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                                  int length)
             {
                 [audioPlot updateBuffer:waveformData[0]
                          withBufferSize:length];
             }];
            
            break;}

        case 4:{
            self.audioFile4         = [EZAudioFile audioFileWithURL:filePathURL];
            [self.audioFile4 getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                                  int length)
             {
                 [audioPlot updateBuffer:waveformData[0]
                          withBufferSize:length];
             }];
            
            break;}
}
    
}

//------------------------------------------------------------------------------

@end