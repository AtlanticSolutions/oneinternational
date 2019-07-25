//
//  AudioViewController.m
//  AdAlive
//
//  Created by macbook on 15/12/15.
//  Copyright © 2015 Lab360. All rights reserved.
//

#import "AudioViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AudioViewController ()

@property(nonatomic, weak) IBOutlet UIButton *btnPlay;
@property(nonatomic, weak) IBOutlet UISlider *slider;
@property(nonatomic, weak) IBOutlet UILabel *lblTime;
@property(nonatomic, weak) IBOutlet UILabel *lbAudioTimeFinish;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, weak) IBOutlet UIView *viewAudio;
@property(nonatomic, weak) IBOutlet UIView *closeView;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property (strong) id playerObserver;
@property (strong) NSString *current;
@property (nonatomic)  BOOL isAudioAvailable;
@property BOOL isAudioReady;
@property BOOL isLoadedView;

@end

@implementation AudioViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *thumbImage = [UIImage imageNamed:@"slider_audio_control"];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_buttonCloseTapped:)];
    [self.closeView addGestureRecognizer:tapGesture];
    
    self.viewAudio.layer.cornerRadius = 5.0;
    self.viewAudio.layer.borderWidth = 1.0;
    //self.viewAudio.layer.borderColor = [[UIColor colorWithRed:0.0352 green:0.3058 blue:0.5019 alpha:1.0] CGColor];
    
    self.btnPlay.hidden = YES;
    self.activityIndicator.hidden = NO;
    self.isAudioReady = NO;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.audioURL]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.isAudioAvailable = YES;
    [self loadAudioFile];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isAudioAvailable)
    {
        @try{
            [self.player removeObserver:self forKeyPath:@"status"];
            self.player = nil;
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
    }
}

-(void)setIsAudioAvailable:(BOOL)isAudioAvailable
{
    _isAudioAvailable = isAudioAvailable;
    
    if (isAudioAvailable)
    {
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    }
}

-(NSString *)formatMinutesLabelWithSeconds:(int64_t) seconds
{
    if (seconds < 60)
    {
        return [NSString stringWithFormat:@"00:%02lld", seconds];
    }
    else
    {
        int64_t minutes = seconds/60;
        int64_t restSeconds = seconds%60;
        
        return [NSString stringWithFormat:@"%02lld:%02lld", minutes, restSeconds];
    }
}

#pragma mark - Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context {
    
    if (self.player)
    {
        if (object == self.player && [keyPath isEqualToString:@"status"])
        {
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                self.isAudioReady = YES;
                self.btnPlay.hidden = NO;
                [self.player play];
                self.btnPlay.selected = YES;
                self.activityIndicator.hidden = YES;
                
                CMTime duration = [self.playerItem duration];
                NSString *audioTime = [self formatMinutesLabelWithSeconds: duration.value/ duration.timescale];
                self.lblTime.text = audioTime;
                self.lbAudioTimeFinish.text = audioTime;
                
            }
            if (self.player.status == AVPlayerStatusFailed) {
                self.isAudioReady = NO;
            }
        }
    }
}

-(void)loadAudioFile
{
    self.lblTime.text = @"00:00";
    self.lbAudioTimeFinish.text = @"00:00";
    
    self.slider.value = 0.0;
    
    CMTime interval = CMTimeMake(33, 1000);  // 30fps
    self.playerObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        CMTime endTime = CMTimeConvertScale (_player.currentItem.asset.duration, _player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            double normalizedTime = (double) self.player.currentTime.value / (double) endTime.value;
            _slider.value = normalizedTime;
            _lblTime.text = [self formatMinutesLabelWithSeconds:self.player.currentTime.value/self.player.currentTime.timescale];
            CMTime duration = [[self.player currentItem] duration];
            NSString *audioTime = [self formatMinutesLabelWithSeconds: duration.value/ duration.timescale];
            _lbAudioTimeFinish.text = audioTime;
        }
    }];
}

-(IBAction)_buttonPlayAudioTapped:(id)sender
{
    CMTime duration = [self.playerItem duration];
    NSString *audioTime = [self formatMinutesLabelWithSeconds: duration.value/ duration.timescale];
    
    self.lbAudioTimeFinish.text = audioTime;
    
    if (self.isAudioReady && !self.btnPlay.selected)
    {
        [self.player play];
        self.btnPlay.selected = YES;
    }
    else if(self.btnPlay.selected)
    {
        [self.player pause];
        self.btnPlay.selected = NO;
    }
    else if(!self.isAudioReady)
    {
        //Definir comportamento
    }
}

-(IBAction)_didStartEditing:(id)sender
{
    [self.player pause];
}

-(IBAction)_didEndEditingSlider:(id)sender
{
    self.btnPlay.selected = YES;
    double currentValue = self.slider.value * self.playerItem.duration.value;
    
    CMTime duration = [self.playerItem duration];
    self.lblTime.text = [self formatMinutesLabelWithSeconds: duration.value/ duration.timescale];
    
    self.lbAudioTimeFinish.text = [self formatMinutesLabelWithSeconds: duration.value/ duration.timescale];
    
    CMTime time = CMTimeMake(currentValue, self.playerItem.duration.timescale);
    [self.playerItem seekToTime:time];
    [self.player play];
}

- (IBAction)_buttonCloseTapped:(id)sender
{
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
    [UIView animateWithDuration:0.3 animations:^{
        self.btnPlay.selected = NO;
    }];
    
    [self.player removeTimeObserver:self.playerObserver];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
