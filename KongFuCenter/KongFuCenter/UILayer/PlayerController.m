//
//  PlayerController.m
//  Vitamio-Demo
//
//  Created by erlz nuo(nuoerlz@gmail.com) on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import "Utilities.h"
#import "PlayerController.h"
#import "VSegmentSlider.h"



@interface PlayerController ()
{
    
    long               mDuration;
    long               mCurPostion;
    NSTimer            *mSyncSeekTimer;
    
    CGRect             _backViewOldFrame;
}

@property (nonatomic, assign) IBOutlet UIButton *startPause;
@property (nonatomic, assign) IBOutlet UIButton *prevBtn;
@property (nonatomic, assign) IBOutlet UIButton *nextBtn;

@property (nonatomic, assign) IBOutlet UIButton *reset;
@property (nonatomic, assign) IBOutlet VSegmentSlider *progressSld;
@property (nonatomic, assign) IBOutlet UILabel  *curPosLbl;
@property (nonatomic, assign) IBOutlet UILabel  *durationLbl;
@property (nonatomic, assign) IBOutlet UILabel  *bubbleMsgLbl;
@property (nonatomic, assign) IBOutlet UILabel  *downloadRate;
@property (nonatomic, assign) IBOutlet UIView  	*activityCarrier;



@property (nonatomic, copy)   NSURL *videoURL;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) BOOL progressDragging;

@end



@implementation PlayerController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//	self.view.bounds = [[UIScreen mainScreen] bounds];
	self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge] ;
	[self.activityCarrier addSubview:self.activityView];

	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]
								   initWithTarget:self 
								   action:@selector(progressSliderTapped:)] ;
    [self.progressSld addGestureRecognizer:gr];
    [self.progressSld setThumbImage:[UIImage imageNamed:@"pb-seek-bar-btn"] forState:UIControlStateNormal];
    [self.progressSld setMinimumTrackImage:[UIImage imageNamed:@"pb-seek-bar-fr"] forState:UIControlStateNormal];
    [self.progressSld setMaximumTrackImage:[UIImage imageNamed:@"pb-seek-bar-bg"] forState:UIControlStateNormal];

	if (!_mMPayer) {
		_mMPayer = [VMediaPlayer sharedInstance];
        
		[_mMPayer setupPlayerWithCarrierView:self.carrier withDelegate:self];
        
		[self setupObservers];
        
	}
    _backViewOldFrame=_backView.frame;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];

	[self currButtonAction:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[self unSetupObservers];
	[_mMPayer unSetupPlayer];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)to duration:(NSTimeInterval)duration
{
	
    self.backView.frame = self.view.bounds;
	
	NSLog(@"NAL 1HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.carrier.frame));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"NAL 2HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.carrier.frame));
}


#pragma mark - Respond to the Remote Control Events

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			if ([_mMPayer isPlaying]) {
				[_mMPayer pause];
			} else {
				[_mMPayer start];
			}
			break;
		case UIEventSubtypeRemoteControlPlay:
			[_mMPayer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[_mMPayer pause];
			break;
		case UIEventSubtypeRemoteControlPreviousTrack:
			[self prevButtonAction:nil];
			break;
		case UIEventSubtypeRemoteControlNextTrack:
			[self nextButtonAction:nil];
			break;
		default:
			break;
	}
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
	[_mMPayer setVideoShown:YES];
    if (![_mMPayer isPlaying]) {
		[_mMPayer start];
		[self.startPause setTitle:@"Pause" forState:UIControlStateNormal];
	}
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([_mMPayer isPlaying]) {
		[_mMPayer pause];
		[_mMPayer setVideoShown:NO];
    }
}


#pragma mark - VMediaPlayerDelegate Implement

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
//    [player setVideoFillMode:VMVideoFillModeStretch];

	mDuration = [player getDuration];
    [player start];

	[self setBtnEnableStatus:YES];
	[self stopActivity];
    mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3
                                                      target:self
                                                    selector:@selector(syncUIStatus)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
//	[self goBackButtonAction:nil];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
	[self stopActivity];
//	[self showVideoLoadingError];
	[self setBtnEnableStatus:YES];
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
	player.decodingSchemeHint = VMDecodingSchemeSoftware;
	player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
	// Set buffer size, default is 1024KB(1*1024*1024).
//	[player setBufferSize:256*1024];
	[player setBufferSize:512*1024];
	[player setAdaptiveStream:YES];

	[player setVideoQuality:VMVideoQualityHigh];

	player.useCache = YES;
	[player setCacheDirectory:[self getCacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
	self.progressDragging = NO;
	NSLog(@"NAL 1HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
	self.progressDragging = YES;
	NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
	if (![Utilities isLocalMedia:self.videoURL]) {
		[player pause];
		[self.startPause setTitle:@"Start" forState:UIControlStateNormal];
		[self startActivityWithMsg:@"加载... 0%"];
	}
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
	if (!self.bubbleMsgLbl.hidden) {
		self.bubbleMsgLbl.text = [NSString stringWithFormat:@"加载... %d%%",
								  [((NSNumber *)arg) intValue]];
	}
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
	if (![Utilities isLocalMedia:self.videoURL]) {
		[player start];
		[self.startPause setTitle:@"Pause" forState:UIControlStateNormal];
		[self stopActivity];
	}
	self.progressDragging = NO;
	NSLog(@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
//	if (![Utilities isLocalMedia:self.videoURL]) {
//		self.downloadRate.text = [NSString stringWithFormat:@"%dKB/s", [arg intValue]];
//	} else {
//		self.downloadRate.text = nil;
//	}
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
//	NSLog(@"NAL 1BGR video lagging....");
}
//
//#pragma mark VMediaPlayerDelegate Implement / Cache
//
- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
	NSLog(@"NAL .... media can't cache.");
	self.progressSld.segments = nil;
}
//
//- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg
//{
//	NSLog(@"NAL 1GFC .... media caches index : %@", arg);
//}
//
//- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg
//{
////	NSArray *segs = (NSArray *)arg;
//////	NSLog(@"NAL .... media cacheUpdate, %d, %@", segs.count, segs);
////	if (mDuration > 0) {
////		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
////		for (int i = 0; i < segs.count; i++) {
////			float val = (float)[segs[i] longLongValue] / mDuration;
////			[arr addObject:[NSNumber numberWithFloat:val]];
////		}
////		self.progressSld.segments = arr;
////	}
//}
//
//- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg
//{
////	NSLog(@"NAL .... media cacheSpeed: %dKB/s", [(NSNumber *)arg intValue]);
//}
//
//- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg
//{
////	NSLog(@"NAL .... media cacheComplete");
////	self.progressSld.segments = @[@(0.0), @(1.0)];
//}


#pragma mark - Convention Methods

#define TEST_Common					1
#define TEST_setOptionsWithKeys		0
#define TEST_setDataSegmentsSource	0

-(void)quicklyPlayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
	[UIApplication sharedApplication].idleTimerDisabled = YES;
//	[self setBtnEnableStatus:NO];

	NSString *docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSLog(@"NAL &&& Doc: %@", docDir);


//	fileURL = [NSURL URLWithString:@"http://v.17173.com/api/5981245-4.m3u8"];



#if TEST_Common // Test Common
	NSString *abs = [fileURL absoluteString];
	if ([abs rangeOfString:@"://"].length == 0) {
		NSString *docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
		NSString *videoUrl = [NSString stringWithFormat:@"%@/%@", docDir, abs];
		self.videoURL = [NSURL fileURLWithPath:videoUrl];
	} else {
		self.videoURL = fileURL;
	}
//    [_mMPayer setDataSource:self.videoURL header:nil];
    [_mMPayer setDataSource:self.videoURL];
#endif

    [_mMPayer prepareAsync];
	[self startActivityWithMsg:@"正在寻找视频并解码...0％"];
}

-(void)quicklyReplayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
    [self quicklyStopMovie];
    [self quicklyPlayMovie:fileURL title:title seekToPos:pos];
}

-(void)quicklyStopMovie
{
	[_mMPayer reset];
	[mSyncSeekTimer invalidate];
	mSyncSeekTimer = nil;
	self.progressSld.value = 0.0;
	self.progressSld.segments = nil;
	self.curPosLbl.text = @"00:00:00";
	self.durationLbl.text = @"00:00:00";
	self.downloadRate.text = nil;
	mDuration = 0;
	mCurPostion = 0;
	[self stopActivity];
	[self setBtnEnableStatus:YES];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}


#pragma mark - UI Actions

#define DELEGATE_IS_READY(x) (self.delegate && [self.delegate respondsToSelector:@selector(x)])

-(void)goBackButtonAction
{
	[self quicklyStopMovie];
//	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)startPauseButtonAction:(id)sender
{
	BOOL isPlaying = [_mMPayer isPlaying];
	if (isPlaying) {
		[_mMPayer pause];
		[self.playandpuase setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
	} else {
		[_mMPayer start];
		[self.playandpuase setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
	}
}

-(void)currButtonAction:(id)sender
{
	NSURL *url = nil;
	NSString *title = nil;
    
	long lastPos = 0;
	if (DELEGATE_IS_READY(playCtrlGetPrevMediaTitle:lastPlayPos:)) {
		url = [self.delegate playCtrlGetCurrMediaTitle:&title lastPlayPos:&lastPos];
	}
	if (url) {
		[self quicklyPlayMovie:url title:title seekToPos:lastPos];
	} else {
		NSLog(@"WARN: No previous media url found!");
	}
}

-(IBAction)prevButtonAction:(id)sender
{
	NSURL *url = nil;
	NSString *title = nil;
	long lastPos = 0;
	if (DELEGATE_IS_READY(playCtrlGetPrevMediaTitle:lastPlayPos:)) {
		url = [self.delegate playCtrlGetPrevMediaTitle:&title lastPlayPos:&lastPos];
	}
	if (url) {
		[self quicklyReplayMovie:url title:title seekToPos:lastPos];
	} else {
		NSLog(@"WARN: No previous media url found!");
	}
}

-(IBAction)nextButtonAction:(id)sender
{
	NSURL *url = nil;
	NSString *title = nil;
	long lastPos = 0;
	if (DELEGATE_IS_READY(playCtrlGetPrevMediaTitle:lastPlayPos:)) {
		url = [self.delegate playCtrlGetNextMediaTitle:&title lastPlayPos:&lastPos];
	}
	if (url) {
		[self quicklyReplayMovie:url title:title seekToPos:lastPos];
	} else {
		NSLog(@"WARN: No previous media url found!");
	}
}

-(void)nextVideo:(NSURL *)url andTitle:(NSString *)title
{
    long lastPos = 0;
    if (url) {
        [self quicklyReplayMovie:url title:title seekToPos:lastPos];
    }

}


-(IBAction)switchVideoViewModeButtonAction:(UIButton *)sender
{
    if (sender.tag==1) {
        sender.tag=0;
        
        
    }
    else
    {
        sender.tag=1;
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * M_PI/180.0);
        [self.view setTransform:transform];
        
        self.view.frame=_backViewOldFrame;
    }
//	static emVMVideoFillMode modes[] = {
//		VMVideoFillModeFit,
//		VMVideoFillMode100,
//		VMVideoFillModeCrop,
//		VMVideoFillModeStretch,
//	};
//	static int curModeIdx = 0;
//
//	curModeIdx = (curModeIdx + 1) % (int)(sizeof(modes)/sizeof(modes[0]));
//	[_mMPayer setVideoFillMode:modes[curModeIdx]];
    
    
    
}

-(IBAction)resetButtonAction:(id)sender
{
	static int bigView = 0;

	[UIView animateWithDuration:0.3 animations:^{
		if (bigView) {
			self.backView.frame = self.view.bounds;
			bigView = 0;
		} else {
			self.backView.frame = self.view.bounds;
			bigView = 1;
		}
		NSLog(@"NAL 1NBV &&&& backview.frame=%@", NSStringFromCGRect(self.backView.frame));
	}];


//	[self quicklyStopMovie];
}

-(IBAction)progressSliderDownAction:(id)sender
{
	self.progressDragging = YES;
	NSLog(@"NAL 4HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
	NSLog(@"NAL 1DOW &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Touch Down");
}

-(IBAction)progressSliderUpAction:(id)sender
{
	UISlider *sld = (UISlider *)sender;
	NSLog(@"NAL 1BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", (long)(sld.value * mDuration));
	[self startActivityWithMsg:@"加载中"];
	[_mMPayer seekTo:(long)(sld.value * mDuration)];
}

-(IBAction)dragProgressSliderAction:(id)sender
{
	UISlider *sld = (UISlider *)sender;
	self.curPosLbl.text = [Utilities timeToHumanString:(long)(sld.value * mDuration)];
}

-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    long seek = percentage * mDuration;
	self.curPosLbl.text = [Utilities timeToHumanString:seek];
	NSLog(@"NAL 2BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", seek);
	[self startActivityWithMsg:@"加载"];
    [_mMPayer seekTo:seek];
}


#pragma mark - Sync UI Status

-(void)syncUIStatus
{
	if (!self.progressDragging) {
		mCurPostion  = [_mMPayer getCurrentPosition];
		[self.progressSld setValue:(float)mCurPostion/mDuration];
		self.curPosLbl.text = [Utilities timeToHumanString:mCurPostion];
		self.durationLbl.text = [Utilities timeToHumanString:mDuration];
	}
}


#pragma mark Others

-(void)startActivityWithMsg:(NSString *)msg
{
	self.bubbleMsgLbl.hidden = NO;
	self.bubbleMsgLbl.text = msg;
	[self.activityView startAnimating];
}

-(void)stopActivity
{
	self.bubbleMsgLbl.hidden = YES;
	self.bubbleMsgLbl.text = nil;
	[self.activityView stopAnimating];
}

-(void)setBtnEnableStatus:(BOOL)enable
{
	self.startPause.enabled = enable;
	self.prevBtn.enabled = enable;
	self.nextBtn.enabled = enable;
	self.modeBtn.enabled = enable;
}

- (void)setupObservers
{
	NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
			selector:@selector(applicationDidEnterForeground:)
				name:UIApplicationDidBecomeActiveNotification
			  object:[UIApplication sharedApplication]];
    [def addObserver:self
			selector:@selector(applicationDidEnterBackground:)
				name:UIApplicationWillResignActiveNotification
			  object:[UIApplication sharedApplication]];
}

- (void)unSetupObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)showVideoLoadingError
{
	NSString *sError = NSLocalizedString(@"Video cannot be played", @"description");
	NSString *sReason = NSLocalizedString(@"Video cannot be loaded.", @"reason");
	NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
							   sError, NSLocalizedDescriptionKey,
							   sReason, NSLocalizedFailureReasonErrorKey,
							   nil];
	NSError *error = [NSError errorWithDomain:@"Vitamio" code:0 userInfo:errorDict];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

- (NSString *)getCacheRootDirectory
{
	NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
    }
	return cache;
}

@end