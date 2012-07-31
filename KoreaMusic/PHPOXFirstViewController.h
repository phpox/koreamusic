//
//  PHPOXFirstViewController.h
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-7-30.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hprose.h"
#import "SongListViewController.h"

@protocol Phpox
-(oneway void) getSongList:(int)id selector:(SEL)selector delegate:(id)delegate;
-(oneway void) getSongUrl:(int)id selector:(SEL)selector delegate:(id)delegate;
@end


@interface PHPOXFirstViewController : UIViewController
{
    UIToolbar *barView;
    UITableView *newView;
}

@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSArray *listDataIntro;
@property (retain, nonatomic) IBOutlet HproseClient *hpClient;
@property (strong, nonatomic) SongListViewController *childController;
@property (retain, nonatomic) NSArray *songarr;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loading;

-(void)bkOnlineList;

@end
