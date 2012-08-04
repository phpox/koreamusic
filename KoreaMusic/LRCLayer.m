//
//  LRCView.m
//  AudioTest
//
//  Created by hv on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LRCLayer.h"
#import <CoreText/CoreText.h>
@implementation LRCLineLayer
@synthesize startTime;

- (id)init
{
    self = [super init];
    if (self) {
        self.font = @"Verdana";
        self.fontSize = FONT_SIZE-6;
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.shadowColor = [UIColor clearColor].CGColor;
        self.shadowOffset = CGSizeMake(1, 1);
        self.shadowOpacity = 1.0;
        self.alignmentMode = kCAAlignmentCenter;
        self.shadowRadius =10.0;
        self.foregroundColor = [UIColor whiteColor].CGColor;
        self.startTime = 0;
        self.string = NULL;
        
    }
    return self;
}

- (void)setContentString:(NSString *)text{
    
    tempString = text;
    self.string = tempString;
}

- (void)hilightcolortimer
{
    if (TT>=tempString.length) {
        if (maskTime!=nil) {
            [maskTime invalidate];
            maskTime = nil;
        }
        return;
    }
    NSRange range = NSMakeRange(TT, 1);
    NSString *hilightChar = [tempString substringWithRange:range];
    NSMutableAttributedString *hilightString = [[[NSMutableAttributedString alloc] initWithString:hilightChar] autorelease];
    [hilightString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                       value:(id)hilightcolor
                       range:NSMakeRange(0, 1)];
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)self.font, 
                                             self.fontSize,
                                             NULL);
    [hilightString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(id)ctFont2 
                       range:NSMakeRange(0, 1)];
    
    CFRelease(ctFont2);
    
    [mutaString replaceCharactersInRange:range withAttributedString:hilightString];
    TT++;
    self.string = NULL;
    self.string = mutaString;
}

- (void)setContentsColor:(CGColorRef)c
{
    if (c==nil) {
        c = [UIColor orangeColor].CGColor;
    }
    //self.shadowColor = c;
    hilightcolor = c;
    
    int len = [tempString length];
    
    if (mutaString==NULL) {
        mutaString = [[NSMutableAttributedString alloc] initWithString:tempString];
    }
    
    
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                       value:(id)[UIColor whiteColor].CGColor
                       range:NSMakeRange(0, len)];
    int nNumType = 0;
    
    if (cfNum==NULL) {
        cfNum = CFNumberCreate(NULL, kCFNumberIntType, &nNumType);
    }
    
    [mutaString addAttribute:(NSString *)kCTLigatureAttributeName
                       value:(id)cfNum
                       range:NSMakeRange(0, len)];
    
    
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)self.font, 
                                             self.fontSize,
                                             NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(id)ctFont2 
                       range:NSMakeRange(0, len)];
    CFRelease(ctFont2);
    
    if (maskTime==nil) {
        TT= 0;
        maskTime = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hilightcolortimer) userInfo:nil repeats:YES] retain];
    }
}

- (void)clearColor
{
    self.shadowColor = [UIColor clearColor].CGColor;
    [mutaString release];
    mutaString = nil;
    hilightcolor = NULL;
    self.string = tempString;
    self.foregroundColor = [UIColor whiteColor].CGColor;

    if (maskTime!=nil) {
        [maskTime invalidate];
        maskTime = nil;
    }
}



@end

@implementation LRCView
@synthesize lineLayers;
@synthesize currentLine;
@synthesize totalLine;
@synthesize hilightcolor;
@synthesize endTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Initialization code
        self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.position = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
        self.backgroundColor = [UIColor clearColor].CGColor;
        lineLayers = [[NSMutableArray alloc] initWithCapacity:0];
        totalLine = 0;
        currentLine = 0;
        margin = self.frame.origin.y;
    }
    return self;
}
- (void)setLineLayers:(NSMutableArray *)lineLayers_
{
    totalLine = lineLayers_.count;
    for (int i =0; i<lineLayers_.count; i++) {
        
        LRCLineObject *lineObject = (LRCLineObject*)[lineLayers_ objectAtIndex:i];
        LRCLineLayer *lineLayer = [[LRCLineLayer alloc] init];
        //lineLayer.string = lineObject.lrc;
        [lineLayer setContentString:lineObject.lrc];
        lineLayer.startTime = lineObject.startTime;
        lineLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, FONT_SIZE);
        lineLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2+FONT_SIZE*i);
        [self addSublayer:lineLayer];
        [lineLayers addObject:lineLayer];
    }
    
    endTime = ((LRCLineObject*)[lineLayers_ lastObject]).startTime;
}
//显示更新
- (void)updateLRCLineLayer:(NSInteger)TimeRecord
{
    LRCLineLayer *next = (LRCLineLayer*)[lineLayers objectAtIndex:currentLine];
    LRCLineLayer *last = nil;
    if (currentLine>0) {
        last = (LRCLineLayer*)[lineLayers objectAtIndex:currentLine-1];
    }
    //NSLog(@"TimeRecord:%d next.startTime:%d",TimeRecord,next.startTime);
    if (TimeRecord==next.startTime/1000) {
        [self scrollRectToVisible:CGRectMake(self.frame.origin.x, margin+FONT_SIZE*currentLine, self.frame.size.width, self.frame.size.height)];
        [next setContentsColor:hilightcolor];
        [last clearColor];
        currentLine++;
    }
    
    if (TimeRecord>=endTime/1000){
        [self scrollRectToVisible:CGRectMake(self.frame.origin.x, margin, self.frame.size.width, self.frame.size.height)];
        [next clearColor];
        currentLine = 0;
    }
}

//动态播放
- (void)search:(NSInteger)timestap
{
    int i = 0;
    for(LRCLineLayer *line in lineLayers)
    {
        if(line.startTime >= timestap){
            currentLine = i;
            break;
        }
        ++i;
    }
    LRCLineLayer *currrntLayer = (LRCLineLayer*)[lineLayers objectAtIndex:8];
    LRCLineLayer* nextLayer=nil;
    LRCLineLayer* lastLayer=nil;
    
    if (currentLine>0) {
        nextLayer = (LRCLineLayer*)[lineLayers objectAtIndex:currentLine-1];
        [nextLayer clearColor];
    }
    [currrntLayer clearColor];
    
    NSInteger currentTime = currrntLayer.startTime;
    NSInteger next=0;
    NSInteger last=0;
    
    if (timestap==currentTime/1000) {
        
        for (int i =currentLine; i<totalLine-1; i++) {
            nextLayer = (LRCLineLayer*)[lineLayers objectAtIndex:i+1];
            next = timestap - nextLayer.startTime/1000;

            if (next<0) {
               lastLayer = (LRCLineLayer*)[lineLayers objectAtIndex:i];
               last = lastLayer.startTime/1000-timestap;
                if (next>last) {
                    currentLine = i+1;
                    [self updateLRCLineLayer:nextLayer.startTime/1000];
                    break;
                }else{
                    currentLine = i;
                    [self updateLRCLineLayer:lastLayer.startTime/1000];
                    break;
                }
            }
        }
    }
    else
    {
        for (int i =currentLine; i>0; i--) {
            nextLayer = (LRCLineLayer*)[lineLayers objectAtIndex:i];
            next = timestap - nextLayer.startTime/1000;
            
            if (next<0) {
                lastLayer = (LRCLineLayer*)[lineLayers objectAtIndex:i-1];
                last = lastLayer.startTime/1000-timestap;
                if (next<last) {
                    currentLine = i-1;
                    [self updateLRCLineLayer:nextLayer.startTime/1000];
                    break;
                }else{
                    currentLine = i;
                    
                    [self updateLRCLineLayer:lastLayer.startTime/1000];
                    break;
                }
            }
        }
        [self scrollRectToVisible:CGRectMake(self.frame.origin.x, margin+FONT_SIZE*currentLine-1, self.frame.size.width, self.frame.size.height)];
    }
}

- (void)dealloc{
	[lineLayers release];
}


@end
