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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
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
    //    [self loadAudioPlot:self.audioPlot1 number:1];
    //    [self loadAudioPlot:self.audioPlot2 number:2];
    //    [self loadAudioPlot:self.audioPlot3 number:3];
    //    [self loadAudioPlot:self.audioPlot4 number:4];
    
    
    
    self.moveMeView = [[APLMoveMeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)];
    self.moveMeView.directoryContent = self.directoryContent;
    [self.moveMeView setupNextDisplayString];
    [self.view addSubview:self.moveMeView];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake(0, self.view.frame.size.height - 130, 100, 100);
//    [playButton setTitle:@"Play"
//                forState:UIControlStateNormal];
    
    [playButton setImage:[UIImage imageNamed:@"record_play"] forState:UIControlStateNormal];
    [playButton setTintColor:[UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1]];
    
    [playButton addTarget:self
                   action:@selector(playButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    UIButton *exportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exportButton.frame = CGRectMake(200, self.view.frame.size.height - 130, 100, 100);
//    [exportButton setTitle:@"Merge"
//                  forState:UIControlStateNormal];
    
    [exportButton setImage:[UIImage imageNamed:@"merge"] forState:UIControlStateNormal];
    [exportButton setTintColor:[UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1]];
    
    [exportButton addTarget:self
                     action:@selector(export:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exportButton];
    
    int numberOfLine = 6;
    int heightofImage = 60;
    
    for(int i=0;i<numberOfLine*heightofImage;i+=heightofImage) {
        UIView *horizontalLine=[[UIView alloc]initWithFrame:CGRectMake(0, i, self.view.frame.size.width, 1)];
        horizontalLine.backgroundColor = [UIColor grayColor];
        [self.view addSubview:horizontalLine];
    }
    int numberOfLine1 = 12;
    int heightofImage1 = 30;
    for(int i=0;i<numberOfLine1*heightofImage1;i+=heightofImage1) {
        UIView *verticalLine=[[UIView alloc]initWithFrame:CGRectMake(i, 0, 1, 300)];
    //    verticalLine.backgroundColor = [UIColor grayColor];
        verticalLine.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        [self.view addSubview:verticalLine];
        [self.view sendSubviewToBack:verticalLine];

        
    }
    self.timeLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 320)];
    self.timeLine.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.timeLine];
    
    //[self listFileAtPath];
    _slider4 = [[UISlider alloc] initWithFrame:CGRectMake(100, 440, 200, 20)];
     _slider4.tintColor = [UIColor colorWithRed:64.0/255.0 green:224.0/255.0 blue:208.0/255.0 alpha:1];
    _slider4.tag = 3;
    _slider4.minimumValue = 0;
    _slider4.maximumValue = 1;
    _slider4.value = 1;
    
    [_slider4 addTarget:self action:@selector(mix:) forControlEvents:UIControlEventValueChanged];
    
    _slider3 = [[UISlider alloc] initWithFrame:CGRectMake(100, 400, 200, 20)];
    _slider3.tintColor = [UIColor colorWithRed:221.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1];
    _slider3.tag = 2;
    _slider3.minimumValue = 0;
    _slider3.maximumValue = 1;
    _slider3.value = 1;
    
    [_slider3 addTarget:self action:@selector(mix:) forControlEvents:UIControlEventValueChanged];
    
    _slider2 = [[UISlider alloc] initWithFrame:CGRectMake(100, 360, 200, 20)];
    _slider2.tintColor = [UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1];
    _slider2.tag = 1;
    _slider2.minimumValue = 0;
    _slider2.maximumValue = 1;
    _slider2.value = 1;
    
    [_slider2 addTarget:self action:@selector(mix:) forControlEvents:UIControlEventValueChanged];
    
    _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(100, 320, 200, 20)];
     _slider1.tintColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1];
    _slider1.tag = 0;
    _slider1.minimumValue = 0;
    _slider1.maximumValue = 1;
    _slider1.value = 1;
    
    [_slider1 addTarget:self action:@selector(mix:) forControlEvents:UIControlEventValueChanged];
    
    switch ([_directoryContent count]){
        case 4:{
            UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 440, 200, 20)];
            trackLabel.font = [UIFont boldSystemFontOfSize:10.0];
            //fileNameLabel.backgroundColor = [UIColor clearColor];
            trackLabel.text =[NSString stringWithFormat:@"Track%d Volume", 4] ;
            [self.view addSubview:trackLabel];
            
            
            [self.view addSubview:_slider4];
            
        }
        case 3:{
            UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, 200, 20)];
            trackLabel.font = [UIFont boldSystemFontOfSize:10.0];
            //fileNameLabel.backgroundColor = [UIColor clearColor];
            trackLabel.text =[NSString stringWithFormat:@"Track%d Volume", 3] ;
            [self.view addSubview:trackLabel];
            
            [self.view addSubview:_slider3];
            
        }
        case 2:{
            UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 200, 20)];
            trackLabel.font = [UIFont boldSystemFontOfSize:10.0];
            //fileNameLabel.backgroundColor = [UIColor clearColor];
            trackLabel.text =[NSString stringWithFormat:@"Track%d Volume", 2] ;
            [self.view addSubview:trackLabel];
            [self.view addSubview:_slider2];
            
        }
        case 1:{
            UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, 200, 20)];
            trackLabel.font = [UIFont boldSystemFontOfSize:10.0];
            //fileNameLabel.backgroundColor = [UIColor clearColor];
            trackLabel.text =[NSString stringWithFormat:@"Track%d Volume", 1] ;
            [self.view addSubview:trackLabel];
            
            [self.view addSubview:_slider1];
            
        }
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    [_player seekToTime:kCMTimeZero];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    [_player pause];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if ([self isMovingFromParentViewController]) {
        
        //specific stuff for being popped off stack
        if (_player != nil && [_player currentItem] != nil)
            @try{
                [[_player currentItem] removeObserver:self forKeyPath:@"status"];
                
            }@catch(id anException){
                //do nothing, obviously it wasn't attached because an exception was thrown
            }
        
    }
}


-(void)loadAudioPlot:(EZAudioPlot*)audioPlot number:(NSInteger)number{
    //    audioPlot = [[EZAudioPlot alloc] initWithFrame:CGRectMake(30, 90*number, self.view.frame.size.width-30, 60)];
    audioPlot = [[EZAudioPlot alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, 60)];
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(30, 90*number, self.view.frame.size.width-30, 60)];
    
    
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
    [coverView addSubview:audioPlot];
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [coverView addGestureRecognizer:singleFingerTap];
    
    
    
    [self.view addSubview:coverView];
    
    //    [self.view addSubview:audioPlot];
    
    
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
    
    
    NSArray *l = [self.moveMeView getLocation];
    
    //[self applyAudioMix];
    if (_player != nil && [_player currentItem] != nil)
        [[_player currentItem] removeObserver:self forKeyPath:@"status"];
    //Setup
    _composition = [AVMutableComposition composition];
    
    _audioMixValues = [[NSMutableDictionary alloc] initWithCapacity:0];
    _audioMixTrackIDs = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // Insert the audio tracks into our composition
    //NSArray* tracks = [NSArray arrayWithObjects:@"track1", @"track2", @"track3", @"track4", nil];
    //NSString* audioFileType = @"wav";
    //[self listFileAtPath];
    for (int i=0; i<[_directoryContent count]; i++)
        
    {
        NSString* trackName = [_directoryContent objectAtIndex:i];
        //        AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:trackName ofType:audioFileType]]
        //                                                        options:nil];
        
        AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                                                         [self applicationDocumentsDirectory],
                                                                                         trackName]]  options:nil];
        AVMutableCompositionTrack* audioTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                          preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSError* error;
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                             atTime:CMTimeMakeWithSeconds([(NSNumber*)[l objectAtIndex:i] floatValue]/5, 600)
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 100) queue:nil
                                     usingBlock:^(CMTime time){
                                         //                                         NSLog(@"%lld %d ",_player.currentTime.value,_player.currentTime.timescale);
                                         self.timeLine.frame=CGRectMake(_player.currentTime.value/_player.currentTime.timescale*5, 0, 1, 300);
                                         [self.timeLine setNeedsDisplay];
                                     }];
    
    switch ([_directoryContent count]){
        case 4:{
            [self mix:_slider4];
            
        }
        case 3:{
            [self mix:_slider3];
            
        }
        case 2:{
            
            [self mix:_slider2];
            
        }
        case 1:{
            [self mix:_slider1];
            
        }
    }
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        
        NSArray *l = [self.moveMeView getLocation];
        
        //[self applyAudioMix];
        if (_player != nil && [_player currentItem] != nil)
            [[_player currentItem] removeObserver:self forKeyPath:@"status"];
        //Setup
        _composition = [AVMutableComposition composition];
        
        _audioMixValues = [[NSMutableDictionary alloc] initWithCapacity:0];
        _audioMixTrackIDs = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        // Insert the audio tracks into our composition
        //NSArray* tracks = [NSArray arrayWithObjects:@"track1", @"track2", @"track3", @"track4", nil];
        //NSString* audioFileType = @"wav";
        //[self listFileAtPath];
        for (int i=0; i<[_directoryContent count]; i++)
            
        {
            NSString* trackName = [_directoryContent objectAtIndex:i];
            //        AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:trackName ofType:audioFileType]]
            //                                                        options:nil];
            
            AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                                                             [self applicationDocumentsDirectory],
                                                                                             trackName]]  options:nil];
            AVMutableCompositionTrack* audioTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                              preferredTrackID:kCMPersistentTrackID_Invalid];
            
            NSError* error;
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                                 atTime:CMTimeMakeWithSeconds([(NSNumber*)[l objectAtIndex:i] floatValue]/5, 600)
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 100) queue:nil
                                         usingBlock:^(CMTime time){
                                             //                                         NSLog(@"%lld %d ",_player.currentTime.value,_player.currentTime.timescale);
                                             self.timeLine.frame=CGRectMake(_player.currentTime.value/_player.currentTime.timescale*5, 0, 1, 300);
                                             [self.timeLine setNeedsDisplay];
                                         }];
        
        switch ([_directoryContent count]){
            case 4:{
                [self mix:_slider4];
                
            }
            case 3:{
                [self mix:_slider3];
                
            }
            case 2:{
                
                [self mix:_slider2];
                
            }
            case 1:{
                [self mix:_slider1];
                
            }
        }
        
        
        
        AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:_composition
                                                                              presetName:AVAssetExportPresetAppleM4A];
        
        NSDate *time = [NSDate date];
        NSDateFormatter* df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MM-yyyy-hh-mm-ss"];
        NSString *timeString = [df stringFromDate:time];
        
        NSString* videoName = [NSString stringWithFormat:@"%@-%@.m4a", [[alertView textFieldAtIndex:0] text], timeString] ;
        
        NSString *exportPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:videoName];
        NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
        }
        
        _assetExport.outputFileType = AVFileTypeAppleM4A;
        _assetExport.outputURL = exportUrl;
        _assetExport.shouldOptimizeForNetworkUse = YES;
        
        [_assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
             NSLog(@"export finished");
         }
         
         ];
        
        [self.navigationController popViewControllerAnimated:YES];    }
}


- (IBAction)export:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Merge" message:@"Please enter the name of the music" delegate:self cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeAlphabet;
    alertTextField.placeholder = @"Enter the name of the music";
    [alert show];
    }

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (AVPlayerItemStatusReadyToPlay == _player.currentItem.status)
        {
            [_player play];
        }
    }
}
// Action for our 4 sliders
- (IBAction)mix:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    
    [self setVolume:slider.value
           forTrack:[_directoryContent objectAtIndex:slider.tag]];
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
- (NSArray *)applicationDocuments
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

//------------------------------------------------------------------------------
- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
-(void)listFileAtPath
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    _directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self applicationDocumentsDirectory] error:NULL];
    for (count = 0; count < (int)[_directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [_directoryContent objectAtIndex:count]);
    }
    return;
}

@end