//
//  PHPOXFirstViewController.m
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-7-30.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import "PHPOXFirstViewController.h"
#import "Hprose.h"

@interface PHPOXFirstViewController ()

@end

@implementation PHPOXFirstViewController

@synthesize listData;
@synthesize listDataIntro;
@synthesize hpClient;
@synthesize childController;
@synthesize songarr;
@synthesize loading;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *array = [[NSArray alloc] initWithObjects:@"新歌首发", @"热歌榜单",
                      @"精选推荐", @"随便听听" , @"影视金曲" ,nil];
    self.listData = array;
    
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"按歌曲发行时间排序", @"按歌曲点播率排序",
                      @"小编推荐的歌曲", @"随机选出一些歌曲",@"韩国影视经典OST", nil];
    self.listDataIntro = array1;
    
    id client = [HproseHttpClient client:@"http://pma.sutoo.com/koreamusic/hprose.php"];
    hpClient = [[client useService:@protocol(Phpox)] retain];
    
}

- (void)viewDidUnload
{
    self.listData = nil;
    self.listDataIntro = nil;
    self.childController = nil;
    [self setHpClient:nil];
    [self setLoading:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 
#pragma mark Table View Data Source Methods 
//返回行数
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section { 
    return [self.listData count]; 
}

//新建某一行并返回
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
                             TableSampleIdentifier]; 
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier]; 
    } 
    
    NSUInteger row = [indexPath row]; 
    cell.textLabel.text = [listData objectAtIndex:row];
    
    UIImage *image = [UIImage imageNamed:@"blue.png"]; 
    cell.imageView.image = image; 
    UIImage *highLightedImage = [UIImage imageNamed:@"yellow.png"]; 
    cell.imageView.highlightedImage = highLightedImage;
    
    cell.detailTextLabel.text = [listDataIntro objectAtIndex:row];
	return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [loading startAnimating];
    [hpClient getSongList:1 selector:@selector(getUserListCallback:) delegate:self];
}

-(void)bkOnlineList
{
    [barView removeFromSuperview];
    [newView removeFromSuperview];
}

-(void) getUserListCallback:(NSArray *)result {
    
    if (childController == nil) {
        childController = [[SongListViewController alloc]
                           initWithNibName:@"SongListViewController" bundle:nil];
        childController.songarr = result;
    }
    [self.view addSubview:childController.view];
    if([result count] > 0)
    {
        for (NSDictionary * row in result)
        {
            NSLog(@"%@",[row objectForKey:@"name"]);
            //NSString *ids = [NSString stringWithFormat:@"%@",[row objectForKey:@"id"]];
        }
        songarr = result;
    }
    [loading stopAnimating];
    //[[[UIAlertView alloc] initWithTitle:@"提示信息" message:[result description] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)dealloc {
    [hpClient release];
    //[songarr release];
    [loading release];
    [super dealloc];
}
@end
