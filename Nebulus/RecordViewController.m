//
//  SecondViewController.m
//  Nebulus
//
//  Created by Jike on 7/20/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation RecordViewController
@synthesize stopButton, playButton, recordPauseButton, sampleratelabel, bitratelabel, sampleratecontrol, bitratecontrol;
float samplerate, bitrate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    samplerate = 44100;
    bitrate = 128000;
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:samplerate] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setObject:[NSNumber numberWithInt:bitrate] forKey:AVEncoderBitRateKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        [playButton setEnabled:NO];
        [recordPauseButton setEnabled:NO];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

- (IBAction)sampleratechange:(id)sender {
    switch (sampleratecontrol.selectedSegmentIndex)
    {
        case 0:
            sampleratelabel.text = @"Sample Rate: 22050";
            samplerate = 22050;
            break;
        case 1:
            sampleratelabel.text = @"Sample Rate: 32000";
            samplerate = 32000;
            break;
        case 2:
            sampleratelabel.text = @"Sample Rate: 44100";
            samplerate = 44100;
            break;

        default:
            break; 
    }
}
- (IBAction)bitratechange:(id)sender {
        switch (bitratecontrol.selectedSegmentIndex)
        {
            case 0:
                bitratelabel.text = @"Bit Rate: 48000";
                bitrate = 48000;
                break;
            case 1:
                bitratelabel.text = @"Bit Rate: 96000";
                bitrate = 96000;
                break;
            case 2:
                bitratelabel.text = @"Bit Rate: 128000";
                bitrate = 128000;
                break;
            default:
                break; 
        }
}
#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [playButton setEnabled:YES];
    [recordPauseButton setEnabled:YES];
}
- (IBAction)back:(UIStoryboardSegue *)segue {
    // Optional place to read data from closing controller
}

@end
