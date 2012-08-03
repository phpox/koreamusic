//
//  SongListViewController.h
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-1.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>  
#import "Hprose.h"
#import "PlayerViewController.h"

@protocol Phpox
-(oneway void) getSongList:(int)id selector:(SEL)selector delegate:(id)delegate;
-(oneway void) getSongUrl:(int)id selector:(SEL)selector delegate:(id)delegate;
-(oneway void) getSongInfo:(int)id selector:(SEL)selector delegate:(id)delegate;
@end

@interface SongListViewController : UIViewController
{
    
}
@property (retain, nonatomic) IBOutlet HproseClient *hpClient;
@property (retain, nonatomic) IBOutlet NSArray *songarr;
@property (strong, nonatomic) PlayerViewController *playerController;
- (IBAction)bkMain:(id)sender;

@end
