//
//  PHPOXFirstViewController.m
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-7-30.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import "PHPOXFirstViewController.h"

@interface PHPOXFirstViewController ()

@end

@implementation PHPOXFirstViewController

@synthesize listData;
@synthesize listDataIntro;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.listData = nil;
    self.listDataIntro = nil;
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

@end
