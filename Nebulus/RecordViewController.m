//
//  RecordViewController.m
//  EZAudioRecordExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2015 Syed Haris Ali. All rights reserved.
//

#import "RecordViewController.h"

#define COUNTRY_TAG 100
#import "Clip.h"
#import "UserHttpClient.h"
#import "RecordingHttpClient.h"

@implementation RecordViewController

//------------------------------------------------------------------------------
#pragma mark - Dealloc
//------------------------------------------------------------------------------

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//------------------------------------------------------------------------------
#pragma mark - Status Bar Style
//------------------------------------------------------------------------------

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//------------------------------------------------------------------------------
#pragma mark - Setup
//------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Setup the AVAudioSession. EZMicrophone will not work properly on iOS
    // if you don't do this!
    //
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    //
    // Customizing the audio plot that'll show the current microphone input/recording
    //
    self.recordingAudioPlot.backgroundColor = [UIColor colorWithRed: 0.984 green: 0.71 blue: 0.365 alpha: 1];
    self.recordingAudioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.recordingAudioPlot.plotType        = EZPlotTypeRolling;
    self.recordingAudioPlot.shouldFill      = YES;
    self.recordingAudioPlot.shouldMirror    = YES;
    
    //
    // Customizing the audio plot that'll show the playback
    //
    self.playingAudioPlot.color = [UIColor whiteColor];
    self.playingAudioPlot.plotType = EZPlotTypeRolling;
    self.playingAudioPlot.shouldFill = YES;
    self.playingAudioPlot.shouldMirror = YES;
    self.playingAudioPlot.gain = 2.5f;
    
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];
    
    //
    // Initialize UI components
    //
    self.microphoneStateLabel.text = @"Microphone On";
    self.recordingStateLabel.text = @"Not Recording";
    self.playingStateLabel.text = @"Not Playing";
    self.playButton.enabled = NO;
    
    //
    // Setup notifications
    //
    [self setupNotifications];
    
    //
    // Log out where the file is being written to within the app's documents directory
    //
    NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
    
    self.secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 200)];
    self.secondTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.secondTableView.delegate = self;
    self.secondTableView.dataSource = self;
    
    
    
    //
    // Start the microphone
    //
    [self.microphone startFetchingAudio];
    
    [self listFileAtPath];
    [self.secondTableView reloadData];
    
    [self.view addSubview:self.secondTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_directoryContent count]; // or other number, that you want
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UILabel *countryLabel;
    UIButton *detailInfoButton, *uploadButton;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
        
        //create custom labels and button inside the cell view
        CGRect myFrame = CGRectMake(10.0, 5.0, 200, 25.0);
        countryLabel = [[UILabel alloc] initWithFrame:myFrame];
        countryLabel.tag = COUNTRY_TAG;
        countryLabel.font = [UIFont boldSystemFontOfSize:17.0];
        countryLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:countryLabel];
        
        detailInfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        detailInfoButton.frame = CGRectMake(200.0, 5.0, 50, 25.0);
        [detailInfoButton setTitle:@"Play"
                          forState:UIControlStateNormal];
        detailInfoButton.tag = indexPath.row;
        [detailInfoButton addTarget:self
                             action:@selector(playFile:)
                   forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:detailInfoButton];
        
        
        uploadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        uploadButton.frame = CGRectMake(250.0, 5.0, 90, 25.0);
        [uploadButton setTitle:@"Upload"
                      forState:UIControlStateNormal];
        uploadButton.tag = indexPath.row;
        [uploadButton addTarget:self
                         action:@selector(upload:)
               forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:uploadButton];
        
    }
    else {
        countryLabel = (UILabel *)[cell.contentView viewWithTag:COUNTRY_TAG];
    }
    
    
    //populate data from your country object to table view cell
    countryLabel.text = [NSString stringWithFormat:@"New Recording %d: %@", indexPath.row +1, [_directoryContent objectAtIndex:indexPath.row]];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeImage:[_directoryContent objectAtIndex:indexPath.row]];
    [_directoryContent removeObjectAtIndex:indexPath.row];
    [_secondTableView reloadData];
    
}

- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath =[self applicationDocumentsDirectory];
    //    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    //    if (success) {
    //        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    //        [removeSuccessFulAlert show];
    //    }
    //    else
    //    {
    //        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    //    }
}
//------------------------------------------------------------------------------

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEndOfFile:)
                                                 name:EZAudioPlayerDidReachEndOfFileNotification
                                               object:self.player];
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)playerDidChangePlayState:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    BOOL isPlaying = [player isPlaying];
    if (isPlaying)
    {
        self.recorder.delegate = nil;
    }
    self.playingStateLabel.text = isPlaying ? @"Playing" : @"Not Playing";
    self.playingAudioPlot.hidden = !isPlaying;
}

//------------------------------------------------------------------------------

- (void)playerDidReachEndOfFile:(NSNotification *)notification
{
    [self.playingAudioPlot clear];
}

//------------------------------------------------------------------------------
#pragma mark - Actions
//------------------------------------------------------------------------------

- (void)playFile:(id)sender
{
    //
    // Update microphone state
    //
    [self.microphone stopFetchingAudio];
    
    //
    // Update recording state
    //
    self.isRecording = NO;
    self.recordingStateLabel.text = @"Not Recording";
    self.recordSwitch.on = NO;
    
    //
    // Close the audio file
    //
    if (self.recorder)
    {
        [self.recorder closeAudioFile];
    }
    
    //EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:[self testFilePathURL]];
    
    NSString *fileName = [_directoryContent objectAtIndex: [(UIButton*)sender tag]];
    
    EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                                                   [self applicationDocumentsDirectory],
                                                                                   fileName]]];
    [self.player playAudioFile:audioFile];
    
    
}


- (void)upload:(id)sender
{
    //
    // Update microphone state
    //
    NSInteger i = [(UIButton*)sender tag];
    
    Clip *clip = [[Clip alloc] init];
    NSLog(@"123");
    clip.name = [_directoryContent objectAtIndex:i];
    NSLog(@"312");
    
    
    clip.creator = [UserHttpClient getCurrentUser];
    
    NSString *fileName = [_directoryContent objectAtIndex: [(UIButton*)sender tag]];
    
    NSURL *assetURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], fileName]];
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    clip.duration =[NSNumber numberWithFloat: audioDurationSeconds];
    
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    const uint32_t sampleRate = 16000; // 16k sample/sec
    const uint16_t bitDepth = 16; // 16 bit/sample/channel
    const uint16_t channels = 2; // 2 channel/sample (stereo)
    
    NSDictionary *opts = [NSDictionary dictionary];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:assetURL options:opts];
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:NULL];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithFloat:(float)sampleRate], AVSampleRateKey,
                              [NSNumber numberWithInt:bitDepth], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey, nil];
    
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack:[[asset tracks] objectAtIndex:0] outputSettings:settings];
    //    [asset release];
    [reader addOutput:output];
    [reader startReading];
    
    // read the samples from the asset and append them subsequently
    while ([reader status] != AVAssetReaderStatusCompleted) {
        CMSampleBufferRef buffer = [output copyNextSampleBuffer];
        if (buffer == NULL) continue;
        
        CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(buffer);
        size_t size = CMBlockBufferGetDataLength(blockBuffer);
        uint8_t *outBytes = malloc(size);
        CMBlockBufferCopyDataBytes(blockBuffer, 0, size, outBytes);
        CMSampleBufferInvalidate(buffer);
        CFRelease(buffer);
        [data appendBytes:outBytes length:size];
        free(outBytes);
    }
    NSLog(@"length: ", data.length);
    clip = [RecordingHttpClient createClip:clip recording:data];
    
    
}


//------------------------------------------------------------------------------

- (void)toggleMicrophone:(id)sender
{
    [self.player pause];
    
    BOOL isOn = [(UISwitch*)sender isOn];
    if (!isOn)
    {
        [self.microphone stopFetchingAudio];
    }
    else
    {
        [self.microphone startFetchingAudio];
    }
}

//------------------------------------------------------------------------------

- (void)toggleRecording:(id)sender
{
    [self.player pause];
    if ([sender isOn])
    {
        
        //
        // Create the recorder
        //
        [self.recordingAudioPlot clear];
        [self.microphone startFetchingAudio];
        self.recorder = [EZRecorder recorderWithURL:[self testFilePathURL]
                                       clientFormat:[self.microphone audioStreamBasicDescription]
                                           fileType:EZRecorderFileTypeM4A
                                           delegate:self];
        self.playButton.enabled = YES;
        [self listFileAtPath];
        [self.secondTableView reloadData];
    }
    self.isRecording = (BOOL)[sender isOn];
    self.recordingStateLabel.text = self.isRecording ? @"Recording" : @"Not Recording";
}

//------------------------------------------------------------------------------
#pragma mark - EZMicrophoneDelegate
//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone changedPlayingState:(BOOL)isPlaying
{
    self.microphoneStateLabel.text = isPlaying ? @"Microphone On" : @"Microphone Off";
    self.microphoneSwitch.on = isPlaying;
}

//------------------------------------------------------------------------------

#warning Thread Safety
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    
    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [weakSelf.recordingAudioPlot updateBuffer:buffer[0]
                                   withBufferSize:bufferSize];
    });
}

//------------------------------------------------------------------------------

- (void)   microphone:(EZMicrophone *)microphone
        hasBufferList:(AudioBufferList *)bufferList
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if (self.isRecording)
    {
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
}

//------------------------------------------------------------------------------
#pragma mark - EZRecorderDelegate
//------------------------------------------------------------------------------

- (void)recorderDidClose:(EZRecorder *)recorder
{
    recorder.delegate = nil;
}

//------------------------------------------------------------------------------

- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder
{
    __weak typeof (self) weakSelf = self;
    NSString *formattedCurrentTime = [recorder formattedCurrentTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentTimeLabel.text = formattedCurrentTime;
    });
}

//------------------------------------------------------------------------------
#pragma mark - EZAudioPlayerDelegate
//------------------------------------------------------------------------------

- (void) audioPlayer:(EZAudioPlayer *)audioPlayer
         playedAudio:(float **)buffer
      withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
         inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.playingAudioPlot updateBuffer:buffer[0]
                                 withBufferSize:bufferSize];
    });
}

//------------------------------------------------------------------------------

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentTimeLabel.text = [audioPlayer formattedCurrentTime];
    });
}

//------------------------------------------------------------------------------
#pragma mark - Utility
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

//------------------------------------------------------------------------------

- (NSURL *)testFilePathURL
{
    NSString *extensionString = @".m4a";
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MM-yyyy-hh-mm-ss"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"File-%@%@", timeString, extensionString];
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                   [self applicationDocumentsDirectory],
                                   fileName]];
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



//
//  SecondViewController.m
//  Nebulus
//
//  Created by Jike on 7/20/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//
//#import "RecordViewController.h"
//
//@interface RecordViewController () {
//    AVAudioRecorder *recorder;
//    AVAudioPlayer *player;
//}
//
//@end

//@implementation RecordViewController
//@synthesize stopButton, playButton, recordPauseButton, sampleratelabel, bitratelabel, sampleratecontrol, bitratecontrol;
//float samplerate, bitdepth;
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    samplerate = 44100;
//    bitdepth= 32;
//    // Disable Stop/Play button when application launches
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:NO];
//
//    // Set the audio file
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"MyAudioMemo.m4a",
//                               nil];
//    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//
//    // Setup audio session
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//
//    // Define the recorder setting
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:samplerate] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//    [recordSetting setObject:[NSNumber numberWithInt:bitdepth] forKey:AVEncoderBitDepthHintKey];
//
//    // Initiate and prepare the recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
//    recorder.delegate = self;
//    recorder.meteringEnabled = YES;
//    [recorder prepareToRecord];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)recordPauseTapped:(id)sender {
//    // Stop the audio player before recording
//    if (player.playing) {
//        [player stop];
//    }
//
//    if (!recorder.recording) {
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        [session setActive:YES error:nil];
//
//        // Start recording
//        [recorder record];
//        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
//
//    } else {
//
//        // Pause recording
//        [recorder pause];
//        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    }
//
//    [stopButton setEnabled:YES];
//    [playButton setEnabled:NO];
//}
//
//- (IBAction)stopTapped:(id)sender {
//    [recorder stop];
//
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
//}
//
//- (IBAction)playTapped:(id)sender {
//    if (!recorder.recording){
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
//        [player setDelegate:self];
//        [player play];
//        [playButton setEnabled:NO];
//        [recordPauseButton setEnabled:NO];
//    }
//}
//
//#pragma mark - AVAudioRecorderDelegate
//
//- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:YES];
//}
//
//- (IBAction)sampleratechange:(id)sender {
//    switch (sampleratecontrol.selectedSegmentIndex)
//    {
//        case 0:
//            sampleratelabel.text = @"Sample Rate: 22050";
//            samplerate = 22050;
//            break;
//        case 1:
//            sampleratelabel.text = @"Sample Rate: 32000";
//            samplerate = 32000;
//            break;
//        case 2:
//            sampleratelabel.text = @"Sample Rate: 44100";
//            samplerate = 44100;
//            break;
//
//        default:
//            break;
//    }
//}
//- (IBAction)bitratechange:(id)sender {
//    switch (bitratecontrol.selectedSegmentIndex)
//    {
//        case 0:
//            bitratelabel.text = @"Bit Depth: 8";
//            bitdepth = 8;
//            break;
//        case 1:
//            bitratelabel.text = @"Bit Depth: 16";
//            bitdepth = 16;
//            break;
//        case 2:
//            bitratelabel.text = @"Bit Depth: 32";
//            bitdepth = 32;
//            break;
//        default:
//            break;
//    }
//}
//#pragma mark - AVAudioPlayerDelegate
//
//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//    [playButton setEnabled:YES];
//    [recordPauseButton setEnabled:YES];
//}
//- (IBAction)back:(UIStoryboardSegue *)segue {
//    // Optional place to read data from closing controller
//}
//
//@end
