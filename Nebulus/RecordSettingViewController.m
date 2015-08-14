//
//  RecordSettingViewController.m
//  Nebulus
//
//  Created by jiayi on 8/13/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "RecordSettingViewController.h"

@interface RecordSettingViewController ()

@end



@implementation RecordSettingViewController


@synthesize Quality;
@synthesize Title;
@synthesize Value;

- (void)viewDidLoad {
    [super viewDidLoad];
    Title.text = @"Sample Rate\n\nBit Depth\n\nBit Rate\n\nEstimate Size";
    Value.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%.1fMB/Minute\n\n",[[NSNumber numberWithInt:SAMPLERATE_MEDIUM] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITDEPTH_MEDIUM] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITRATE_MEDIUM] descriptionWithLocale:[NSLocale currentLocale]], ESTIMATEDSIZE_MEDIUM];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)QualityChanged:(id)sender {
    switch (Quality.selectedSegmentIndex)
        {
            case 0:
                Value.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%.1fMB/Minute\n\n",[[NSNumber numberWithInt:SAMPLERATE_LOW] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITDEPTH_LOW] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITRATE_LOW] descriptionWithLocale:[NSLocale currentLocale]], ESTIMATEDSIZE_LOW];
                break;
            case 1:
                Value.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%.1fMB/Minute\n\n",[[NSNumber numberWithInt:SAMPLERATE_MEDIUM] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITDEPTH_MEDIUM] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITRATE_MEDIUM] descriptionWithLocale:[NSLocale currentLocale]], ESTIMATEDSIZE_MEDIUM];
                break;
            case 2:
                Value.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%.1fMB/Minute\n\n",[[NSNumber numberWithInt:SAMPLERATE_HIGH] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITDEPTH_HIGH] descriptionWithLocale:[NSLocale currentLocale]],[[NSNumber numberWithInt:BITRATE_HIGH] descriptionWithLocale:[NSLocale currentLocale]], ESTIMATEDSIZE_HIGH];
                break;
            default:
                break;
        }

}
@end
