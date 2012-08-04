//
//  LRCView.h
//  AudioTest
//
//  Created by hv on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LRCParser.h"

#define FONT_SIZE  20
@interface LRCLineLayer:CATextLayer
{
    NSInteger startTime;
    NSMutableAttributedString *mutaString;
    NSString *tempString;
    NSTimer *maskTime;
    CFNumberRef cfNum;
    CGColorRef hilightcolor;
    NSInteger TT;
}
@property(nonatomic,assign)NSInteger startTime;
- (id)init;
- (void)clearColor;
- (void)setContentsColor:(CGColorRef)c;
- (void)setContentString:(NSString *)text;
@end

@interface LRCView : CAScrollLayer
{
    NSMutableArray *lineLayers;
    NSInteger totalLine;
    NSInteger currentLine;
    float  margin;
}
- (id)initWithFrame:(CGRect)frame;
- (void)setLineLayers:(NSMutableArray *)lineLayers_;
- (void)updateLRCLineLayer:(NSInteger)TimeRecord;
- (void)search:(NSInteger)timestap;
@property (nonatomic,retain)NSMutableArray *lineLayers;
@property (nonatomic,assign) NSInteger endTime;
@property (nonatomic,assign) NSInteger	currentLine;
@property (nonatomic,assign) NSInteger	totalLine;
@property (nonatomic,assign) CGColorRef hilightcolor;
@end
