//
//  PlayerViewController.m
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-4.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import "PlayerViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize songarr;
@synthesize lblSongName;
@synthesize lblSingerName;
@synthesize downloadSourceField;
@synthesize positionLabel;
@synthesize progressSlider;
@synthesize button;
@synthesize lrcView;
@synthesize volumeSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
// setButtonImageNamed:
//
// Used to change the image on the playbutton. This method exists for
// the purpose of inter-thread invocation because
// the observeValueForKeyPath:ofObject:change:context: method is invoked
// from secondary threads and UI updates are only permitted on the main thread.
//
// Parameters:
//    imageNamed - the name of the image to set on the play button.
//
- (void)setButtonImageNamed:(NSString *)imageName
{
	if (!imageName)
	{
		imageName = @"btn_play";
	}
	[currentImageName autorelease];
	currentImageName = [imageName retain];
	
	UIImage *image = [UIImage imageNamed:imageName];
	
	[button.layer removeAllAnimations];
	[button setImage:image forState:0];
    
	if ([imageName isEqual:@"btn_loading.png"])
	{
		[self spinButton];
	}
}

-(void)initSong
{
    if([songarr objectForKey:@"name"] == NULL){
        return;
    }
    NSLog(@"view did %@",[songarr objectForKey:@"name"]);
    
    lblSongName.text = [songarr objectForKey:@"name"];
    lblSingerName.text = [songarr objectForKey:@"singer"];
    
    MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
	[volumeSlider addSubview:volumeView];
	[volumeView sizeToFit];
	
	[self setButtonImageNamed:@"btn_play.png"];
    [streamer stop];
    [self createStreamer];
    [self setButtonImageNamed:@"btn_loading"];
    islrc = NO;
    LRCParser *tmpParser = [[LRCParser alloc] init];
	islrc = [tmpParser parseLRC:[songarr objectForKey:@"lrc"]];
    if(islrc == YES)
    {
        lecLayer = [[LRCView alloc] initWithFrame:CGRectMake(0, 0, 320, 270)];
        [lecLayer setLineLayers:tmpParser.lrcArray];
        [self.lrcView.layer addSublayer:lecLayer];
    }
    [streamer start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSong];
}


- (void)viewDidUnload
{
    [self setLblSongName:nil];
    [self setLblSingerName:nil];
    [self setDownloadSourceField:nil];
    [self setPositionLabel:nil];
    [self setProgressSlider:nil];
    [self setButton:nil];
    [self setVolumeSlider:nil];
    [self setButton:nil];
    [self setLrcView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	[self destroyStreamer];
	
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)[songarr objectForKey:@"url"],NULL,NULL,kCFStringEncodingUTF8) autorelease];
    NSLog([songarr objectForKey:@"url"]);
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}


//
// textFieldShouldReturn:
//
// Dismiss the text field when done is pressed
//
// Parameters:
//    sender - the text field
//
// returns YES
//
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
	[sender resignFirstResponder];
	[self createStreamer];
	return YES;
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{    
	if (streamer.bitRate != 0.0)
	{
		double progress = streamer.progress;
		double duration = streamer.duration;
		
		if (duration > 0)
		{
			[positionLabel setText:
             [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",
              (int)floor(progress/60),(int)progress % 60,
              (int)floor(duration/60),(int)duration % 60]];
			[progressSlider setEnabled:YES];
			[progressSlider setValue:100 * progress / duration];
            if(islrc == YES)
            {
                [lecLayer updateLRCLineLayer:(int)(progress)];
            }
		}
		else
		{
			[progressSlider setEnabled:NO];
		}
	}
	else
	{
		positionLabel.text = @"00:00/00:00";
	}
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(UISlider *)aSlider
{
	if (streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * streamer.duration;
		[streamer seekToTime:newSeekTime];
	}
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[self setButtonImageNamed:@"btn_loading.png"];
	}
	else if ([streamer isPlaying])
	{
		[self setButtonImageNamed:@"btn_pause.png"];
	}
    else if ([streamer isPaused]) {
            
        [self setButtonImageNamed:@"btn_play.png"];
    }
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[self setButtonImageNamed:@"btn_play.png"];
	}
}

//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];
    
	[CATransaction commit];
}

//
// animationDidStop:finished:
//
// Restarts the spin animation on the button when it ends. Again, this is
// largely irrelevant now that the audio is loaded from a local file.
//
// Parameters:
//    theAnimation - the animation that rotated the button.
//    finished - is the animation finised?
//
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/stop button.
//
- (IBAction)buttonPressed:(id)sender
{
	if ([currentImageName isEqual:@"btn_play.png"])
	{
		[streamer start];
	}
	else
	{
		[streamer pause];
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [lblSongName release];
    [lblSingerName release];
    [downloadSourceField release];
    [self destroyStreamer];
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
    [positionLabel release];
    [progressSlider release];
    [button release];
    [volumeSlider release];
    [button release];
    [lrcView release];
    [super dealloc];
}
- (IBAction)bkSongList:(id)sender
{
    [lecLayer removeFromSuperlayer];
    [self.view removeFromSuperview];
}
@end
