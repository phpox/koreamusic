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
    [hpClient getSongList:1 selector:@selector(getUserListCallback:) delegate:self];
}

-(void) getUserListCallback:(NSArray *)result
{
    songarr = result;
    [songarr retain];
    if([result count] > 0)
    {
        for (NSDictionary * row in result)
        {
            NSLog(@"%@",[row objectForKey:@"name"]);
            //NSString *ids = [NSString stringWithFormat:@"%@",[row objectForKey:@"id"]];
        }
    }
}

- (void)viewDidUnload
{
    [self setHpClient:nil];
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
    return 4;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * myURL = [NSString stringWithFormat:@"http://pma.sutoo.com/koreamusic/music/1.mp3"];
    MPMoviePlayerController *moviePlayer = [ [ MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:myURL]];
    [moviePlayer play];
}


- (void)dealloc {
    [hpClient release];
    [super dealloc];
}
@end
