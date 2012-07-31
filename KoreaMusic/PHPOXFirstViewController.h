//
//  PHPOXFirstViewController.h
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-7-30.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Phpox
-(oneway void) getSongList:(int)id selector:(SEL)selector delegate:(id)delegate;
@end


@interface PHPOXFirstViewController : UIViewController
{
    id helloClient;
    UIToolbar *barView;
    UITableView *newView;
}

@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSArray *listDataIntro;

-(void) helloCallback:(NSString *)result;
-(void)bkOnlineList;

@end
