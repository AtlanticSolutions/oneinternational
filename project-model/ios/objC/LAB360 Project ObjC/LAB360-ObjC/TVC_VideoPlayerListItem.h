//
//  TVC_VideoPlayerListItem.h
//  CozinhaTudo
//
//  Created by lucas on 13/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewVideoPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "ToolBox.h"
#import "AppDelegate.h"

@protocol VideoCellDelegate <NSObject>
@required
- (void)cellVideoDelegateNeedEnterFullScreenWithIndex:(long)cellIndex;
@end

@interface TVC_VideoPlayerListItem : UITableViewCell<UIViewVideoPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imvThumb;
@property (nonatomic, weak) IBOutlet UIButton *btnPlay;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIViewVideoPlayer *viewVideo;
@property (nonatomic, weak) IBOutlet UIView *viewVideoControls;
@property (nonatomic, weak) IBOutlet UIView *viewVideoContainer;
@property (nonatomic, weak) IBOutlet UIView *viewVideoTimerBar;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoMute;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoPlay;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoFullScreen;
@property (nonatomic, weak) IBOutlet UILabel *lblVideoTime;
@property (nonatomic, weak) IBOutlet UIProgressView *progressVideo;
@property (nonatomic, assign) BOOL isShowingVideoControls;
//
@property (nonatomic, weak) id<VideoCellDelegate> videoDelegate;

//methods
- (void)playVideoWithURL:(NSString*)videoURL;
- (void)stopVideo;
-(void) updateLayout;
//
- (void)showOrHideVideoControls;

@end
