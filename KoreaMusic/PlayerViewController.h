//
//  PlayerViewController.h
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-4.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController

@property (retain, nonatomic) IBOutlet NSMutableDictionary *songarr;
@property (retain, nonatomic) IBOutlet UILabel *lblSongName;
@property (retain, nonatomic) IBOutlet UILabel *lblSingerName;
@property (retain, nonatomic) IBOutlet UITextView *txtLrc;
- (IBAction)bkSongList:(id)sender;

@end
