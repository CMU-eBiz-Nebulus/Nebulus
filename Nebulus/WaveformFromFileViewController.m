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
    
    // Setup
    _composition = [AVMutableComposition composition];
    
    _audioMixValues = [[NSMutableDictionary alloc] initWithCapacity:0];
    _audioMixTrackIDs = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // Insert the audio tracks into our composition
    NSArray* tracks = [NSArray arrayWithObjects:@"track1", @"track2", @"track3", @"track4", nil];
    NSString* audioFileType = @"wav";
    
    for (NSString* trackName in tracks)
    {
        AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:trackName ofType:audioFileType]]
                                                        options:nil];
        
        AVMutableCompositionTrack* audioTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                          preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSError* error;
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:&error];
        
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        // Store the track IDs as track name -> track ID
        [_audioMixTrackIDs setValue:[NSNumber numberWithInteger:audioTrack.trackID]
                             forKey:trackName];
        
        // Set the volume to 1.0 (max) for the track
        [self setVolume:1.0f forTrack:trackName];
    }
    
    // Create a player for our composition of audio tracks. We observe the status so
    // we know when the player is ready to play
    AVPlayerItem* playerItem = [[AVPlayerItem alloc] initWithAsset:[_composition copy]];
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:0
                    context:NULL];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];

    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        //specific stuff for being popped off stack
        if (_player != nil && [_player currentItem] != nil)
            [[_player currentItem] removeObserver:self forKeyPath:@"status"];
    }
}


-(void)loadAudioPlot:(EZAudioPlot*)audioPlot number:(NSInteger)number{
    audioPlot = [[EZAudioPlot alloc] initWithFrame:CGRectMake(30, 90*number, self.view.frame.size.width-30, 60)];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 90*number+60, self.view.frame.size.width-30, 30)];
    slider.tag = number;
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.value = 1;
    
    [slider addTarget:self action:@selector(mix:) forControlEvents:UIControlEventValueChanged];
    
    
    
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
            audioPlot.backgroundColor = [UIColor colorWithRed: 0.169 green: 0.643 blue: 0.675 alpha: 1];
            break;
        case 2:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile2] audioPlot:audioPlot number:2];
            audioPlot.backgroundColor = [UIColor colorWithRed: 0.643 green: 0.169 blue: 0.675 alpha: 1];
            break;
        case 3:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile3] audioPlot:audioPlot number:3];
            audioPlot.backgroundColor = [UIColor colorWithRed: 0.169 green: 0.675 blue: 0.169 alpha: 1];
            break;
        case 4:[self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFile4] audioPlot:audioPlot number:4];
            audioPlot.backgroundColor = [UIColor colorWithRed: 0.675 green: 0.643 blue: 0.169 alpha: 1];
            break;

    }
    [self.view addSubview:slider];
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
- (IBAction)playButtonClicked:(id)sender {
   if (AVPlayerItemStatusReadyToPlay == _player.currentItem.status) [_player play];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (AVPlayerItemStatusReadyToPlay == _player.currentItem.status)
        {
//            [_player play];
        }
    }
}
// Action for our 4 sliders
- (IBAction)mix:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    
    [self setVolume:slider.value
           forTrack:[NSString stringWithFormat:@"track%d", slider.tag]];
    [self applyAudioMix];
}

#pragma mark -
#pragma mark Audio Mixing
// Set the volumne (0.0 - 1.0) for the given track
- (void)setVolume:(float)volume forTrack:(NSString*)audioTrackName
{
    [_audioMixValues setValue:[NSNumber numberWithFloat:volume] forKey:audioTrackName];
}

// Build and apply an audio mix using our volume values
- (void)applyAudioMix
{
    AVMutableAudioMix* mix = [AVMutableAudioMix audioMix];
    
    NSMutableArray* inputParameters = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_audioMixTrackIDs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL*stop) {
        AVAssetTrack* track = [self trackWithId:(CMPersistentTrackID)[(NSNumber*)obj integerValue]];
        
        AVMutableAudioMixInputParameters* params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        
        [params setVolume:[[_audioMixValues valueForKey:key] floatValue]
                   atTime:kCMTimeZero];
        
        [inputParameters addObject:params];
    }];
    
    mix.inputParameters = inputParameters;
    
    _player.currentItem.audioMix = mix;
}

// Find the AVAssetTrack with the given track ID
- (AVAssetTrack*)trackWithId:(CMPersistentTrackID)trackId
{
    NSInteger index = [_composition.tracks indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL* stop) {
        AVCompositionTrack* track = (AVCompositionTrack*)obj;
        
        return (BOOL)(trackId == track.trackID);
    }];
    
    if (index != NSNotFound)
    {
        return [_composition.tracks objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

//------------------------------------------------------------------------------

@end