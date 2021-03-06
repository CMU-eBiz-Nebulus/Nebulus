/*
 File: APLMoveMeView.m
 Abstract: Contains a (placard) view that can be moved by touch. Illustrates
 handling touch events and two styles of animation.
 
 Version: 3.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "APLMoveMeView.h"

// Import QuartzCore for animations.
#import <QuartzCore/QuartzCore.h>


@interface APLMoveMeView ()

@property (nonatomic) NSUInteger nextDisplayStringIndex;

@end


@implementation APLMoveMeView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // We only support single touches, so anyObject retrieves just that touch from touches.
    UITouch *touch = [touches anyObject];
    
    // Only move the placard view if the touch was in the placard view.
//    if ([touch view] != self.placardView) {
//        // In case of a double tap outside the placard view, update the placard's display string.
//        if ([touch tapCount] == 2) {
//            [self setupNextDisplayString];
//        }
//        return;
//    }
//    
    // Animate the first touch.
//    CGPoint touchPoint = [touch locationInView:self];
//    [self animateFirstTouchAtPoint:touchPoint];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
     //If the touch was in the placardView, move the placardView to its location.
   
    if ([touch view] == self.audioPlot1) {
        CGPoint location = [touch locationInView:self];
        location.x = MIN(MAX(self.audioPlot1.frame.size.width/2, location.x
                             ),self.superview.frame.size.width-self.audioPlot1.frame.size.width/2);
        location.y = MIN(MAX(location.y, 90),270);
        if ((int)(location.y -90) % 60 < 10){
            location.y = (int)floor((location.y -90) / 60) * 60 + 90;
        }
        else if ((int)(location.y-90)%60>50){
            location.y = (int)floor((location.y-90)/60)*60+150;
        }
        if ((int)(location.x - self.audioPlot1.frame.size.width/2) % 30 <10){
            location.x =(int)floor((location.x - self.audioPlot1.frame.size.width/2) / 30)*30+self.audioPlot1.frame.size.width/2;
        }
        else if ((int)(location.x - self.audioPlot1.frame.size.width/2) % 30 >20){
            location.x =(int)floor((location.x - self.audioPlot1.frame.size.width/2) / 30)*30+30+self.audioPlot1.frame.size.width/2;
        }
        self.audioPlot1.center = location;
        return;
    }
    if ([touch view] == self.audioPlot2) {
        CGPoint location = [touch locationInView:self];
        location.x = MIN(MAX(self.audioPlot2.frame.size.width/2, location.x),self.superview.frame.size.width-self.audioPlot2.frame.size.width/2);
        location.y = MIN(MAX(location.y, 90),270);
        if ((int)(location.y -90) % 60 < 10){
            location.y = (int)floor((location.y -90) / 60) * 60 + 90;
        }
        else if ((int)(location.y-90)%60>50){
            location.y = (int)floor((location.y-90)/60)*60+150;
        }
        if ((int)(location.x - self.audioPlot2.frame.size.width/2) % 30 <10){
            location.x =(int)floor((location.x - self.audioPlot2.frame.size.width/2) / 30)*30+self.audioPlot2.frame.size.width/2;
        }
        else if ((int)(location.x - self.audioPlot2.frame.size.width/2) % 30 >20){
            location.x =(int)floor((location.x - self.audioPlot2.frame.size.width/2) / 30)*30+30+self.audioPlot2.frame.size.width/2;
        }
        self.audioPlot2.center = location;
        return;
    }
    if ([touch view] == self.audioPlot3) {
        CGPoint location = [touch locationInView:self];
        location.x = MIN(MAX(self.audioPlot3.frame.size.width/2, location.x),self.superview.frame.size.width-self.audioPlot3.frame.size.width/2);
        location.y = MIN(MAX(location.y, 90),270);
        if ((int)(location.y -90) % 60 < 10){
            location.y = (int)floor((location.y -90) / 60) * 60 + 90;
        }
        else if ((int)(location.y-90)%60>50){
            location.y = (int)floor((location.y-90)/60)*60+150;
        }
        if ((int)(location.x - self.audioPlot3.frame.size.width/2) % 30 <10){
            location.x =(int)floor((location.x - self.audioPlot3.frame.size.width/2) / 30)*30+self.audioPlot3.frame.size.width/2;
        }
        else if ((int)(location.x - self.audioPlot3.frame.size.width/2) % 30 >20){
            location.x =(int)floor((location.x - self.audioPlot3.frame.size.width/2) / 30)*30+30+self.audioPlot3.frame.size.width/2;
        }

        self.audioPlot3.center = location;
        return;
    }
    if ([touch view] == self.audioPlot4) {
        CGPoint location = [touch locationInView:self];
        location.x = MIN(MAX(self.audioPlot4.frame.size.width/2, location.x),self.superview.frame.size.width-self.audioPlot4.frame.size.width/2);
        location.y = MIN(MAX(location.y, 90),270);
        if ((int)(location.y -90) % 60 < 10){
            location.y = (int)floor((location.y -90) / 60) * 60 + 90;
        }
        else if ((int)(location.y-90)%60>50){
            location.y = (int)floor((location.y-90)/60)*60+150;
        }
        if ((int)(location.x - self.audioPlot4.frame.size.width/2) % 30 <10){
            location.x =(int)floor((location.x - self.audioPlot4.frame.size.width/2) / 30)*30+self.audioPlot4.frame.size.width/2;
        }
        else if ((int)(location.x - self.audioPlot4.frame.size.width/2) % 30 >20){
            location.x =(int)floor((location.x - self.audioPlot4.frame.size.width/2) / 30)*30+30+self.audioPlot4.frame.size.width/2;
        }

        self.audioPlot4.center = location;
        return;
    }
    
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];
//    
//    // If the touch was in the placardView, bounce it back to the center.
//    
//    for (EZAudioPlot v : _views){
//    if ([touch view] == v) {
//        /*
//         Disable user interaction so subsequent touches don't interfere with animation until the placard has returned to the center. Interaction is reenabled in animationDidStop:finished:.
//         */
//        //		self.userInteractionEnabled = NO;
//        ////		[self animatePlacardViewToCenter];
//        return;
//    }
//    }
//    
//}


//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    /*
//     To impose as little impact on the device as possible, simply set the placard view's center and transformation to the original values.
//     */
//    //	self.placardView.center = self.center;
//    //	self.placardView.transform = CGAffineTransformIdentity;
//    
//    // If the touch was in the placardView, move the placardView to its location.
//    UITouch *touch = [touches anyObject];
//    if ([touch view] == self.placardView) {
//        CGPoint location = [touch locationInView:self];
//        self.placardView.center = location;
//        return;
//    }
//    
//}


/*
 First of two possible implementations of animateFirstTouchAtPoint: illustrating different behaviors.
 To choose the second, replace '1' with '0' below.
 */

#define GROW_FACTOR 1.2f
#define SHRINK_FACTOR 1.1f

#if 1

/**
 "Pulse" the placard view by scaling up then down, then move the placard to under the finger.
 */
//- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
//    /*
//     This illustrates using UIView's built-in animation.  We want, though, to animate the same property (transform) twice -- first to scale up, then to shrink.  You can't animate the same property more than once using the built-in animation -- the last one wins.  So we'll set a delegate action to be invoked after the first animation has finished.  It will complete the sequence.
//     
//     The touch point is passed in an NSValue object as the context to beginAnimations:. To make sure the object survives until the delegate method, pass the reference as retained.
//     */
//    
//#define GROW_ANIMATION_DURATION_SECONDS 0.15
//    
//    NSValue *touchPointValue = [NSValue valueWithCGPoint:touchPoint];
//    [UIView beginAnimations:nil context:(__bridge_retained void *)touchPointValue];
//    [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
//    CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
//    self.placardView.transform = transform;
//    [UIView commitAnimations];
//}


//- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//    
//#define MOVE_ANIMATION_DURATION_SECONDS 0.15
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
//    self.placardView.transform = CGAffineTransformMakeScale(SHRINK_FACTOR, SHRINK_FACTOR);
//    /*
//     Move the placardView to under the touch.
//     We passed the location wrapped in an NSValue as the context. Get the point from the value, and transfer ownership to ARC to balance the bridge retain in touchesBegan:withEvent:.
//     */
//    NSValue *touchPointValue = (__bridge_transfer NSValue *)context;
//    self.placardView.center = [touchPointValue CGPointValue];
//    [UIView commitAnimations];
//}

#else

/*
 Alternate behavior.
 The preceding implementation grows the placard in place then moves it to the new location and shrinks it at the same time.  An alternative is to move the placard for the total duration of the grow and shrink operations; this gives a smoother effect.
 
 */


/**
 Create two separate animations. The first animation is for the grow and partial shrink. The grow animation is performed in a block. The method uses a completion block that itself includes an animation block to perform the shrink. The second animation lasts for the total duration of the grow and shrink animations and contains a block responsible for performing the move.
 */

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
    
#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
    
    [UIView animateWithDuration:GROW_ANIMATION_DURATION_SECONDS animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
        self.placardView.transform = transform;
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:(NSTimeInterval)SHRINK_ANIMATION_DURATION_SECONDS animations:^{
                             self.placardView.transform = CGAffineTransformMakeScale(SHRINK_FACTOR, SHRINK_FACTOR);
                         }];
                         
                     }];
    
    [UIView animateWithDuration:(NSTimeInterval)GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS animations:^{
        self.placardView.center = touchPoint;
    }];
    
}


/*
 
 Equivalent implementation using delegate-based method.
 
 - (void)animateFirstTouchAtPointOld:(CGPoint)touchPoint {
	
 #define GROW_ANIMATION_DURATION_SECONDS 0.15
 #define SHRINK_ANIMATION_DURATION_SECONDS 0.15
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	self.placardView.transform = transform;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS];
	self.placardView.center = touchPoint;
	[UIView commitAnimations];
 }
 
 
 - (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
 
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	self.placardView.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];
 }
 */


#endif


///**
// Bounce the placard back to the center.
// */
//- (void)animatePlacardViewToCenter {
//    
//    EZAudioPlot *placardView = self.placardView;
//    CALayer *welcomeLayer = placardView.layer;
//    
//    // Create a keyframe animation to follow a path back to the center.
//    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    bounceAnimation.removedOnCompletion = NO;
//    
//    CGFloat animationDuration = 1.5f;
//    
//    
//    // Create the path for the bounces.
//    UIBezierPath *bouncePath = [[UIBezierPath alloc] init];
//    
//    CGPoint centerPoint = self.center;
//    CGFloat midX = centerPoint.x;
//    CGFloat midY = centerPoint.y;
//    CGFloat originalOffsetX = placardView.center.x - midX;
//    CGFloat originalOffsetY = placardView.center.y - midY;
//    CGFloat offsetDivider = 4.0f;
//    
//    BOOL stopBouncing = NO;
//    
//    // Start the path at the placard's current location.
//    [bouncePath moveToPoint:CGPointMake(placardView.center.x, placardView.center.y)];
//    [bouncePath addLineToPoint:CGPointMake(midX, midY)];
//    
//    // Add to the bounce path in decreasing excursions from the center.
//    while (stopBouncing != YES) {
//        
//        CGPoint excursion = CGPointMake(midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
//        [bouncePath addLineToPoint:excursion];
//        [bouncePath addLineToPoint:centerPoint];
//        
//        offsetDivider += 4;
//        animationDuration += 1/offsetDivider;
//        if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
//            stopBouncing = YES;
//        }
//    }
//    
//    bounceAnimation.path = [bouncePath CGPath];
//    bounceAnimation.duration = animationDuration;
//    
//    // Create a basic animation to restore the size of the placard.
//    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    transformAnimation.removedOnCompletion = YES;
//    transformAnimation.duration = animationDuration;
//    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    
//    
//    // Create an animation group to combine the keyframe and basic animations.
//    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
//    
//    // Set self as the delegate to allow for a callback to reenable user interaction.
//    theGroup.delegate = self;
//    theGroup.duration = animationDuration;
//    theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    theGroup.animations = @[bounceAnimation, transformAnimation];
//    
//    
//    // Add the animation group to the layer.
//    [welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
//    
//    // Set the placard view's center and transformation to the original values in preparation for the end of the animation.
//    placardView.center = centerPoint;
//    placardView.transform = CGAffineTransformIdentity;
//}


/**
 Animation delegate method called when the animation's finished: restore the transform and reenable user interaction.
 */
//- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
//    
//    self.placardView.transform = CGAffineTransformIdentity;
//    self.userInteractionEnabled = YES;
//}

- (void)setupNextDisplayString{
    //[self listFileAtPath];
    if ([_directoryContent count]>0)
        [self setupNextDisplayStringAudioPlot:self.audioPlot1 number:1];
    if ([_directoryContent count]>1)
        [self setupNextDisplayStringAudioPlot:self.audioPlot2 number:2];
    if ([_directoryContent count]>2)
        [self setupNextDisplayStringAudioPlot:self.audioPlot3 number:3];
    if ([_directoryContent count]>3)
        [self setupNextDisplayStringAudioPlot:self.audioPlot4 number:4];
}
- (NSArray*) getLocation{
    NSNumber *lo1 = [NSNumber numberWithInteger:self.audioPlot1.frame.origin.x];
    NSNumber *lo2 = [NSNumber numberWithInteger:self.audioPlot2.frame.origin.x];
    NSNumber *lo3 = [NSNumber numberWithInteger:self.audioPlot3.frame.origin.x];
    NSNumber *lo4 = [NSNumber numberWithInteger:self.audioPlot4.frame.origin.x];
    NSMutableArray *r = [[NSMutableArray alloc] initWithObjects:lo1,lo2,lo3,lo4, nil];
    return r;
    
}
- (void)setupNextDisplayStringAudioPlot:(EZAudioPlot*)placardView number:(NSInteger)number{


    
    
    
    NSString *fileName =[_directoryContent objectAtIndex:(number-1)];
    
    NSURL *assetURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], fileName]];
    
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);

    placardView = [[EZAudioPlot alloc] initWithFrame:CGRectMake(0, 60*number, audioDurationSeconds*15, 60)];
    UILabel *fileNameLabel;
    CGRect myFrame = CGRectMake(0,-10,50,50);
    fileNameLabel = [[UILabel alloc] initWithFrame:myFrame];
    fileNameLabel.font = [UIFont boldSystemFontOfSize:10.0];
    //fileNameLabel.backgroundColor = [UIColor clearColor];
    fileNameLabel.text =[NSString stringWithFormat:@"Track%ld", (long)number] ;
    [placardView addSubview:fileNameLabel];

    //
    // Customizing the audio plot's look
    //
    // Background color
 //   placardView.backgroundColor = [UIColor colorWithRed: 0.169 green: 0.643 blue: 0.675 alpha: 1];
    // Waveform color
    placardView.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    placardView.plotType        = EZPlotTypeBuffer;
    // Fill
    placardView.shouldFill      = YES;
    // Mirror
    placardView.shouldMirror    = YES;
    // No need to optimze for realtime
    placardView.shouldOptimizeForRealtimePlot = NO;
    // Customize the layer with a shadow for fun
    placardView.waveformLayer.shadowOffset = CGSizeMake(0.0, 1.0);
    placardView.waveformLayer.shadowRadius = 0.0;
    placardView.waveformLayer.shadowColor = [UIColor colorWithRed: 0.069 green: 0.543 blue: 0.575 alpha: 1].CGColor;
    placardView.waveformLayer.shadowOpacity = 1.0;
    [self addSubview:placardView];
//    
//    //
//    // Load in the sample file
//    //
//    [self openFileWithFilePathURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
//                                                          [self applicationDocumentsDirectory],
//                                                         [_directoryContent objectAtIndex:0]]]];
    [self openFileWithFilePathURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                          [self applicationDocumentsDirectory],
                                                          [_directoryContent objectAtIndex:(number-1)]]] audioPlot:placardView number:number] ;
    
    switch(number){
        case 1:
            self.audioPlot1 = placardView;
             self.audioPlot1.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1];
            break;
        case 2:
            self.audioPlot2 = placardView;
            self.audioPlot2.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1];
            break;
        case 3:
            self.audioPlot3 = placardView;
            self.audioPlot3.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:160.0/255.0 blue:221.0/255.0 alpha:1];
            break;
        case 4:
            self.audioPlot4 = placardView;
            self.audioPlot4.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:224.0/255.0 blue:208.0/255.0 alpha:1];
            break;
        }
        NSUInteger nextIndex = self.nextDisplayStringIndex;
    NSString *displayString = self.displayStrings[nextIndex];
    //    [self.placardView setDisplayString:displayString];
    //
    nextIndex++;
    if (nextIndex >= [self.displayStrings count]) {
        nextIndex = 0;
    }
    self.nextDisplayStringIndex = nextIndex;
    
//    self.placardView.center = self.center;
    
}


//------------------------------------------------------------------------------
#pragma mark - Action Extensions
//------------------------------------------------------------------------------
- (void)openFileWithFilePathURL:(NSURL*)filePathURL audioPlot:(EZAudioPlot*)audioPlot number:(NSInteger)number
{
    self.eof                = NO;
    self.filePathLabel.text = filePathURL.lastPathComponent;
    
    // Plot the whole waveformxr
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
//- (void)openFileWithFilePathURL:(NSURL*)filePathURL
//{
//    self.audioFile          = [EZAudioFile audioFileWithURL:filePathURL];
//    self.eof                = NO;
//    self.filePathLabel.text = filePathURL.lastPathComponent;
//    
//    // Plot the whole waveform
//    self.placardView.plotType     = EZPlotTypeBuffer;
//    self.placardView.shouldFill   = YES;
//    self.placardView.shouldMirror = YES;
//    
//    __weak typeof (self) weakSelf = self;
//    [self.audioFile getWaveformDataWithCompletionBlock:^(float **waveformData,
//                                                         int length)
//     {
//         [weakSelf.placardView updateBuffer:waveformData[0]
//                           withBufferSize:length];
//     }];
//}

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
