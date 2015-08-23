//
//  RecordViewController.m
//  EZAudioRecordExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2015 Syed Haris Ali. All rights reserved.
//

#import "RecordViewController.h"

#define COUNTRY_TAG 1000
#import "Clip.h"
#import "UserHttpClient.h"
#import "RecordingHttpClient.h"
#import "RecordSettingViewController.h"
#import "EZAudioUtilities.h"
#import "WaveformFromFileViewController.h"

@implementation RecordViewController
@synthesize quality;



//------------------------------------------------------------------------------
#pragma mark - Dealloc
//------------------------------------------------------------------------------

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
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
    
    quality = 2;
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
    self.secondTableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    
    //
    // Start the microphone
    //
    //[self.microphone startFetchingAudio];
    
    [self listFileAtPath];
    [self.secondTableView reloadData];
    
    [self.view addSubview:self.secondTableView];
    
    // make our view consistent
    [self updateButtonsToMatchTableState];
    
}
-(void) viewWillAppear:(BOOL)animated
{ [super viewWillAppear:animated];
    
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
    self.recordingAudioPlot.backgroundColor = [UIColor colorWithRed: 0.816 green: 0.349 blue: 0.255 alpha: 1];
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
    
    [self listFileAtPath];
    [self.secondTableView reloadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_directoryContent count]; // or other number, that you want
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UILabel *fileNameLabel, *dateLabel, *startTimeLabel, *endTimeLabel;
    UIButton *detailInfoButton, *uploadButton;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //if (cell == nil){
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:cellIdentifier];
    
    //create custom labels and button inside the cell view
    CGRect myFrame = CGRectMake(10.0, 5.0, 250, 25.0);
    fileNameLabel = [[UILabel alloc] initWithFrame:myFrame];
    fileNameLabel.tag = COUNTRY_TAG;
    fileNameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    fileNameLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:fileNameLabel];
    
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 20.0, 250, 25.0)];
    dateLabel.font = [UIFont boldSystemFontOfSize:12.0];
    dateLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:dateLabel];
    
    
    detailInfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //        detailInfoButton.frame = CGRectMake(5, 40.0, 50, 25.0);
    detailInfoButton.frame = CGRectMake(18.0, 42.0, 25.0, 25.0);
    //        [detailInfoButton setTitle:@"Play"
    //                          forState:UIControlStateNormal];
    [detailInfoButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    detailInfoButton.tag = indexPath.row;
    [detailInfoButton addTarget:self
                         action:@selector(playFile:)
               forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:detailInfoButton];
    
    
    uploadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    uploadButton.frame = CGRectMake(self.view.frame.size.width-50, 5.0, 30.0, 30.0);
    [uploadButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    //        uploadButton.frame = CGRectMake(250.0, 5.0, 90, 25.0);
    //        [uploadButton setTitle:@"Upload"
    //                      forState:UIControlStateNormal];
    uploadButton.tag = indexPath.row;
    [uploadButton addTarget:self
                     action:@selector(upload:)
           forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:uploadButton];
    
    
    startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 44, 30, 15)];
    startTimeLabel.tag = 200+indexPath.row;;
    startTimeLabel.font = [UIFont systemFontOfSize:15.0];
    startTimeLabel.textColor = [UIColor grayColor];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:startTimeLabel];
    
    endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(290, 44, 30, 15)];
    endTimeLabel.tag = 300+indexPath.row;;
    endTimeLabel.font = [UIFont systemFontOfSize:15.0];
    endTimeLabel.textColor = [UIColor grayColor];
    endTimeLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:endTimeLabel];
    
    UIProgressView *pv = [[UIProgressView alloc] init];
    pv.frame = CGRectMake(80, 50, 200, 15);
    pv.tag =100+indexPath.row;
    [cell.contentView addSubview:pv];
    
    cell.clipsToBounds = YES;
    cell.contentView.clipsToBounds = YES;
    
    
    //}
    //    else {
    //        fileNameLabel = (UILabel *)[cell.contentView viewWithTag:COUNTRY_TAG];
    //    }
    
    NSString *fileName =[_directoryContent objectAtIndex:indexPath.row];
    
    NSURL *assetURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], fileName]];
    
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    if ([[fileName substringToIndex:1] isEqualToString:@"File"]){
        NSRange range = NSMakeRange(5, 19);
        //populate data from your country object to table view cell
//        fileNameLabel.text = [NSString stringWithFormat:@"New Recording %ld", (long)indexPath.row+1];
//        dateLabel.text = [NSString stringWithFormat:@"%@", [fileName substringWithRange:range]];
        
    }
    else {
        //Where the bug is!!!!
        //        int start = [fileName rangeOfString:@"-"].location;
        //        NSRange range = NSMakeRange(start+1, 10);
        //        fileNameLabel.text = [NSString stringWithFormat:@"%@", [fileName substringToIndex:start]];
        //        dateLabel.text = [NSString stringWithFormat:@"%@", [fileName substringWithRange:range]];
        fileNameLabel.text = fileName;
        dateLabel.text = fileName;
    }
    startTimeLabel.text = [NSString stringWithFormat:@"%.1f", 0.0];
    endTimeLabel.text =[NSString stringWithFormat:@"-%.1f", audioDurationSeconds];
    
    
    
    
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


- (IBAction)editAction:(id)sender
{
    [self.secondTableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
    
}

- (IBAction)cancelAction:(id)sender
{
    [self.secondTableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)mixAction:(id)sender
{
}

#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (self.secondTableView.editing)
    {
        // Show the option to cancel the edit.
        self.navigationItem.leftBarButtonItem = self.cancelButton;
        
        [self updateDeleteButtonTitle];
        
        // Show the delete button.
        self.navigationItem.rightBarButtonItem = self.mixButton;
    }
    else
    {
        // Not in editing mode.
        self.navigationItem.leftBarButtonItem = self.settingButton;
        
        // Show the edit button, but disable the edit button if there's nothing to edit.
        if (_directoryContent.count > 0)
        {
            self.editButton.enabled = YES;
        }
        else
        {
            self.editButton.enabled = NO;
        }
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
}

- (void)updateDeleteButtonTitle
{
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [self.secondTableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == _directoryContent.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
        self.mixButton.title = NSLocalizedString(@"Mix All", @"");
    }
    else
    {
        NSString *titleFormatString =
        NSLocalizedString(@"Mix (%d)", @"Title for delete button with placeholder for number");
        self.mixButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Compares the index path for the current cell to the index path stored in the expanded
    // index path variable. If the two match, return a height of 100 points, otherwise return
    // a height of 44 points.
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return 80.0; // Expanded height
    }
    return 44.0; // Normal height
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates]; // tell the table you're about to start making changes
    
    // If the index path of the currently expanded cell is the same as the index that
    // has just been tapped set the expanded index to nil so that there aren't any
    // expanded cells, otherwise, set the expanded index to the index that has just
    // been selected.
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
        [self.secondTableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        self.expandedIndexPath = indexPath;
    }
    //    NSString *fileName = [_directoryContent objectAtIndex: indexPath.row];
    //
    //    EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
    //                                                                                   [self applicationDocumentsDirectory],
    //                                                                                   fileName]]];
    //
    //    [((UILabel*)[self.secondTableView viewWithTag:(200+_expandedIndexPath.row)]) setText:[NSString stringWithFormat:@"%.1f",0.0]];
    //    [((UILabel*)[self.secondTableView viewWithTag:(300+_expandedIndexPath.row)]) setText:[NSString stringWithFormat:@"-%.1f",[audioFile duration]]];
    
    [tableView endUpdates]; // tell the table you're done making your changes
    
    // Update the delete button's title based on how many items are selected.
    [self updateButtonsToMatchTableState];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeOutputDevice:)
                                                 name:EZAudioPlayerDidChangeOutputDeviceNotification
                                               object:self.player];
    
    
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

- (void)audioPlayerDidChangeOutputDevice:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed output device: %@", [player device]);
}
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
    if ([self.player isPlaying]){
        [self.player pause];
        return;
    }
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
    clip.name = [_directoryContent objectAtIndex:i];
    
    
    clip.creator = [UserHttpClient getCurrentUser];
    
    NSString *fileName = [_directoryContent objectAtIndex: [(UIButton*)sender tag]];
    
    NSURL *assetURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], fileName]];
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    clip.duration =[NSNumber numberWithFloat: audioDurationSeconds];
    
    
    //    NSMutableData *data = [[NSMutableData alloc] init];
    //
    //    const uint32_t sampleRate = 16000; // 16k sample/sec
    //    const uint16_t bitDepth = 16; // 16 bit/sample/channel
    //    const uint16_t channels = 2; // 2 channel/sample (stereo)
    //
    //    NSDictionary *opts = [NSDictionary dictionary];
    //    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:assetURL options:opts];
    //    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:NULL];
    //    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
    //                              [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
    //                              [NSNumber numberWithFloat:(float)sampleRate], AVSampleRateKey,
    //                              [NSNumber numberWithInt:bitDepth], AVLinearPCMBitDepthKey,
    //                              [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
    //                              [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
    //                              [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey, nil];
    //
    //    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack:[[asset tracks] objectAtIndex:0] outputSettings:settings];
    //    //    [asset release];
    //    [reader addOutput:output];
    //    [reader startReading];
    //
    //    // read the samples from the asset and append them subsequently
    //    while ([reader status] != AVAssetReaderStatusCompleted) {
    //        CMSampleBufferRef buffer = [output copyNextSampleBuffer];
    //        if (buffer == NULL) continue;
    //
    //        CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(buffer);
    //        size_t size = CMBlockBufferGetDataLength(blockBuffer);
    //        uint8_t *outBytes = malloc(size);
    //        CMBlockBufferCopyDataBytes(blockBuffer, 0, size, outBytes);
    //        CMSampleBufferInvalidate(buffer);
    //        CFRelease(buffer);
    //        [data appendBytes:outBytes length:size];
    //        free(outBytes);
    //    }
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                                         [self applicationDocumentsDirectory],
                                                                         fileName]]];
    
    //NSLog([self applicationDocumentsDirectory]);
    clip = [RecordingHttpClient createClip:clip recording:data];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"You have successfully uploaded the clip!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

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

- (IBAction)toggleRecording:(id)sender
{
    [self.secondTableView beginUpdates];
    if (self.expandedIndexPath!=nil){
        [self.secondTableView deselectRowAtIndexPath:self.expandedIndexPath animated:YES];
        self.expandedIndexPath = nil;
        
    }
    [self.secondTableView endUpdates];
    [self.microphone stopFetchingAudio];
    [self.player pause];
    if (!self.isRecording)
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
        self.isRecording = YES;
        self.recordingStateLabel.text = @"Recording";
    }
    else {
        [self.recorder closeAudioFile];
        self.isRecording = NO;
        self.recordingStateLabel.text = @"Not Recording";
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Save clip" message:@"Please enter the name of the music" delegate:self cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeAlphabet;
        alertTextField.text = self.tempFilename;
        [alert show];
        UITextRange *textRange = [alertTextField textRangeFromPosition:alertTextField.beginningOfDocument
                                                       toPosition:alertTextField.endOfDocument];
        [alertTextField setSelectedTextRange:textRange];
        
        [self.secondTableView reloadData];
        
    }
    
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
        [((UIProgressView*)[weakSelf.secondTableView viewWithTag:(100+_expandedIndexPath.row)]) setProgress:([audioPlayer currentTime]/[audioPlayer duration])];
        [((UILabel*)[weakSelf.secondTableView viewWithTag:(200+_expandedIndexPath.row)]) setText:[NSString stringWithFormat:@"%.1f",[audioPlayer currentTime]]];
        [((UILabel*)[weakSelf.secondTableView viewWithTag:(300+_expandedIndexPath.row)]) setText:[NSString stringWithFormat:@"-%.1f",[audioPlayer duration]-[audioPlayer currentTime]]];
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
    NSURL *tempUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                             [self applicationDocumentsDirectory],
                                             fileName]];
    self.tempFilename = fileName;
    self.tempUrl = tempUrl;
    return tempUrl;
}

-(void)listFileAtPath
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    _directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self applicationDocumentsDirectory] error:NULL];
    
    
    NSString *dataFilePath = [[self applicationDocumentsDirectory]
                              stringByAppendingPathComponent:@".DS_Store"];
    
    
    for (count = 0; count < (int)[_directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [_directoryContent objectAtIndex:count]);
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:dataFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:dataFilePath error:nil];
        }
    }
    return;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_player pause];
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"setting"])
    {
        // Get reference to the destination view controller
        RecordSettingViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setQualityValue:quality];
    }
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"mix"])
    {
        // Get reference to the destination view controller
        WaveformFromFileViewController *vc = [segue destinationViewController];
        
        
        NSArray *selectedRows = [self.secondTableView indexPathsForSelectedRows];
        BOOL deleteSpecificRows = selectedRows.count > 0;
        if (deleteSpecificRows)
        {
            NSMutableArray *selected = [[NSMutableArray alloc] init];
            for (NSIndexPath *selectionIndex in selectedRows) {
                [selected addObject:[_directoryContent objectAtIndex:selectionIndex.row]];
            }
            vc.directoryContent = selected;
        }
        else
        {
            vc.directoryContent = self.directoryContent;
        }
        
        // Exit editing mode after the deletion.
        [self.secondTableView setEditing:NO animated:NO];
        [self updateButtonsToMatchTableState];
        if (self.expandedIndexPath!=nil){
            [self.secondTableView deselectRowAtIndexPath:self.expandedIndexPath animated:NO];
            self.expandedIndexPath = nil;
            
        }
    }
}
- (IBAction)back:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[RecordSettingViewController class]]) {
        RecordSettingViewController *sc = segue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        quality = sc.Quality.selectedSegmentIndex;
        NSLog(@"quality:%ld", quality);
        
    }
    
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    
    NSLog(@"Button Index =%ld",buttonIndex);
    
    if (buttonIndex == 0)
        
    {
        
        NSLog(@"You have clicked Cancel");
        
        [[NSFileManager defaultManager] removeItemAtURL:self.tempUrl error:nil];
        
        
        
    }
    
    else if(buttonIndex == 1)
        
    {
        
        NSLog(@"You have clicked Save");
        
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        
        NSString *newName = [[NSString alloc]initWithFormat :@"%@.m4a", alertTextField.text];
        
        NSURL *newPath = [[self.tempUrl URLByDeletingLastPathComponent] URLByAppendingPathComponent:newName];
        
        
        
        [[NSFileManager defaultManager] moveItemAtURL:self.tempUrl toURL:newPath error:nil];
        
    }
    
    [self listFileAtPath];
    
    [self.secondTableView reloadData];
    
}

@end
