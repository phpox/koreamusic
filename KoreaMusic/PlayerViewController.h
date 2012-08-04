//
//  PlayerViewController.h
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-4.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRCLayer.h"
@class AudioStreamer;

@interface PlayerViewController : UIViewController
{
    //AVAudioPlayer *player;
    AudioStreamer *streamer;
    NSTimer *progressUpdateTimer;
    NSString *currentImageName;
    LRCView *lecLayer;
    BOOL islrc;
}

@property (retain, nonatomic) IBOutlet NSMutableDictionary *songarr;
@property (retain, nonatomic) IBOutlet UILabel *lblSongName;
@property (retain, nonatomic) IBOutlet UILabel *lblSingerName;
@property (retain, nonatomic) IBOutlet UITextField *downloadSourceField;
@property (retain, nonatomic) IBOutlet UILabel *positionLabel;
@property (retain, nonatomic) IBOutlet UISlider *progressSlider;
@property (retain, nonatomic) IBOutlet UIView *volumeSlider;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) IBOutlet UIView *lrcView;
- (IBAction)bkSongList:(id)sender;
- (void)initSong;

@end
