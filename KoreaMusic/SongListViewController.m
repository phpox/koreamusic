//
//  SongListViewController.m
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-1.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import "SongListViewController.h"

@interface SongListViewController ()

@end

@implementation SongListViewController
@synthesize hpClient;
@synthesize songarr;
@synthesize playerController;
@synthesize loading;
@synthesize tbSongList;

-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}

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
    id client = [HproseHttpClient client:@"http://pma.sutoo.com/koreamusic/hprose.php"];
    hpClient = [[client useService:@protocol(Phpox)] retain];
}

- (void)viewDidUnload
{
    [self setHpClient:nil];
    self.playerController = nil;
    [self setLoading:nil];
    [self setTbSongList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Data Source Methods
//返回行数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [songarr count];
}

//新建某一行并返回
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    //static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"%@",[[songarr objectAtIndex:row] objectForKey:@"id"]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[songarr objectAtIndex:row] objectForKey:@"name"]];
    NSLog(@"test %@",[NSString stringWithFormat:@"%@",[[songarr objectAtIndex:row] objectForKey:@"name"]]);
    
    UIImage *image = [UIImage imageNamed:@"blue.png"];
    cell.imageView.image = image;
    UIImage *highLightedImage = [UIImage imageNamed:@"yellow.png"];
    cell.imageView.highlightedImage = highLightedImage;
    
	return cell;
}

-(void)initSongList
{
    [tbSongList reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [loading startAnimating];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *str = [[NSString alloc] initWithFormat:@"%@",[cell reuseIdentifier]];
    NSUInteger row = [str intValue];
    NSLog(@"%d",row);
    [hpClient getSongInfo:row selector:@selector(playSong:) delegate:self];
}

-(void)playSong:(NSMutableDictionary *)result
{
    //MPMoviePlayerController *moviePlayer = [ [ MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url]];
    //[moviePlayer play];
    if (playerController == nil) {
        playerController = [[PlayerViewController alloc]
                           initWithNibName:@"PlayerViewController" bundle:nil];
    }
    [playerController.songarr removeAllObjects];
    playerController.songarr = result;
    [playerController initSong];
    [loading stopAnimating];
    [self.view addSubview:playerController.view];
}

- (IBAction)showPlayer:(id)sender
{
    if (playerController == nil) {
        playerController = [[PlayerViewController alloc]
                            initWithNibName:@"PlayerViewController" bundle:nil];
    }
    [self.view addSubview:playerController.view];
}

- (IBAction)bkMain:(id)sender
{
    [self.view removeFromSuperview];
}


- (void)dealloc {
    [hpClient release];
    //[songarr release];
    [loading release];
    [tbSongList release];
    [super dealloc];
}

@end
