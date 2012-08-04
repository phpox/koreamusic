//
//  LRCParser.m
//  EasyChinese
//
//  Created by wcrane on 11-7-21.
//  Copyright 2011 SGP. All rights reserved.
//

#import "LRCParser.h"

@implementation LRCLineObject

@synthesize lrc;
@synthesize startTime;

- (id)init{
	if (self = [super init]) {
		self.lrc = nil;
		self.startTime = 0;
	}
	
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
		self.lrc = [dict objectForKey:@"lrc"];
		self.startTime = [[dict objectForKey:@"startTime"] intValue];
	}
	
	return self;
}

- (void)dealloc{
	[lrc release];
	[super dealloc];
}

- (NSComparisonResult)timeSort:(LRCLineObject*)lineObject{
	if (self.startTime > lineObject.startTime) {
		return NSOrderedDescending;
	}else if (self.startTime == lineObject.startTime) {
		return NSOrderedSame;
	}else {
		return NSOrderedAscending;
	}
}

@end


@implementation LRCParser
@synthesize author;
@synthesize title;
@synthesize album;
@synthesize byWorker;
@synthesize offset;
@synthesize lrcArray;
@synthesize currentLine;
@synthesize totalLine;
@synthesize endTime;

- (id)init{
	if (self = [super init]) {
		self.author = nil;
		self.title = nil;
		self.album = nil;
		self.byWorker = nil;
		self.offset = 0;
		self.lrcArray = nil;
		self.currentLine = 0;
		self.totalLine = 0;
        self.endTime = 0;
	}
	
	return self;
}

- (void)dealloc{
	[author release];
	[title release];
	[album release];
	[byWorker release];
	[lrcArray release];
	
	[super dealloc];
}

- (void)parserLRCLine:(NSArray*)lrcLines{
	for(NSString *lrcLine in lrcLines){
		NSArray *tmpArray = [lrcLine componentsSeparatedByString:@"]"];
		if ([[tmpArray objectAtIndex:1] length] != 0) {
			int count = [tmpArray count] - 1;
			int i=0;
			for (; i<count; i++) {
				NSString *timeString = [tmpArray objectAtIndex:i];
				LRCLineObject *lineObject = [[LRCLineObject alloc] init];
				lineObject.lrc = [tmpArray lastObject];
				lineObject.startTime = [[timeString substringWithRange:NSMakeRange(1,2)] intValue];
				lineObject.startTime = lineObject.startTime*60+[[timeString substringWithRange:NSMakeRange(4,2)] intValue];
				lineObject.startTime = lineObject.startTime*1000+[[timeString substringWithRange:NSMakeRange(7,2)] intValue];
				
				if (self.lrcArray == nil) {
					NSMutableArray *lrcTmpArray = [[NSMutableArray alloc] init];
					self.lrcArray = lrcTmpArray;
					[lrcTmpArray release];
				}
				//NSLog(@"startTime: %d, lrc: %@", lineObject.startTime, lineObject.lrc);
				[self.lrcArray addObject:lineObject];
			}
		}
	}
	
	[self.lrcArray sortUsingSelector:@selector(timeSort:)];

	self.totalLine = [self.lrcArray count];
    
    self.endTime = ((LRCLineObject*)[self.lrcArray lastObject]).startTime;
}

- (void)parserProperties:(NSString*)propertyString{
	propertyString = [propertyString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSArray *properties = [propertyString componentsSeparatedByString:@"\n"];
	for(NSString *propertyLine in properties){
		if([propertyLine length] > 0){
			NSArray *tmpArray = [propertyLine componentsSeparatedByString:@":"];
			NSString *propertyName = [tmpArray objectAtIndex:0];
			if([propertyName isEqualToString:@"[ar"]){
				self.author = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
			}else if([propertyName isEqualToString:@"[ti"]){
				self.title = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
			}else if([propertyName isEqualToString:@"[al"]){
				self.album = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
			}else if([propertyName isEqualToString:@"[by"]){
				self.byWorker = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
			}else if([propertyName isEqualToString:@"[offset"]){
				NSString *offsetStr = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
				self.offset = [offsetStr intValue];
			}
		}
	}
}

//split lrc into a array
- (bool)parseLRC:(NSString*)lrcContent{
    @try {
        NSString *propertyLines = [lrcContent substringToIndex:[lrcContent rangeOfString:@"[00:"].location];
        [self parserProperties:propertyLines];

    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
		//NSLog(@"property-->%@-->property", propertyLines);
	
	lrcContent = [lrcContent substringFromIndex:[lrcContent rangeOfString:@"[00:"].location];
	lrcContent = [lrcContent stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSArray *retArray = [lrcContent componentsSeparatedByString:@"\n"];
	[self parserLRCLine:retArray];
    return YES;
}

@end
