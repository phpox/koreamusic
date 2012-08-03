//
//  PlayerViewController.m
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-4.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize songarr;
@synthesize lblSongName;
@synthesize lblSingerName;
@synthesize txtLrc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"view did %@",[songarr objectForKey:@"name"]);
    lblSongName.text = [songarr objectForKey:@"name"];
    lblSingerName.text = [songarr objectForKey:@"singer"];
    txtLrc.text = [songarr objectForKey:@"lrc"];
}


- (void)viewDidUnload
{
    [self setLblSongName:nil];
    [self setLblSingerName:nil];
    [self setTxtLrc:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [lblSongName release];
    [lblSingerName release];
    [txtLrc release];
    [super dealloc];
}
- (IBAction)bkSongList:(id)sender
{
    [self.view removeFromSuperview];
}
@end
