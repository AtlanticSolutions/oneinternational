/*===============================================================================
 Copyright (c) 2012-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.
 
 Vuforia is a trademark of PTC Inc., registered in the United States and other
 countries.
 ===============================================================================*/

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class CloudRecoViewController;

// Media states
typedef enum tagMEDIA_STATE {
    REACHED_END,
    PAUSED,
    STOPPED,
    PLAYING,
    READY,
    PLAYING_FULLSCREEN,
    NOT_READY,
    ERROR,
} MEDIA_STATE;

typedef enum {
    VideoRenderCompositionTypeNormal                = 0,
    VideoRenderCompositionTypeTransparentMask       = 1,
    VideoRenderCompositionTypeTransparentChromaKey  = 2
} VideoRenderCompositionType;

// Used to specify that playback should start from the current position when
// calling the load and play methods
static const float VIDEO_PLAYBACK_CURRENT_POSITION = -1.0f;

@protocol VideoHelperDelegate <NSObject>

-(void)willFinishVideoAR;
-(void)didChangeStateVideoAR:(MEDIA_STATE)newState; //ericogt

@end

@interface VideoPlayerHelper : NSObject {
@private
    // AVPlayer
    CMTime playerCursorStartPosition;
    
    // Native playback
    BOOL resumeOnTexturePlayback;
    
    // Timing
    CFTimeInterval mediaStartTime;
    CFTimeInterval playerCursorPosition;
    BOOL stopFrameTimer;
    
    // Asset
    BOOL seekRequested;
    float requestedCursorPosition;
    BOOL localFile;
    BOOL playImmediately;
    
    // Playback status
    //MEDIA_STATE mediaState; (see property below)
    
    // Sample and pixel buffers for video frames
    CMSampleBufferRef latestSampleBuffer;
    CMSampleBufferRef currentSampleBuffer;
    
    // Video properties
    CGSize videoSize;
    Float64 videoLengthSeconds;
    float videoFrameRate;
    BOOL playVideo;
    
    // Audio properties
    float currentVolume;
    BOOL playAudio;
    
    // OpenGL data
    GLuint videoTextureHandle;
    
    // Audio/video synchronisation state
    enum tagSyncState {
        SYNC_DEFAULT,
        SYNC_READY,
        SYNC_AHEAD,
        SYNC_BEHIND
    } syncStatus;
    
    // Media player type
    enum tagPLAYER_TYPE {
        PLAYER_TYPE_ON_TEXTURE,
        PLAYER_TYPE_NATIVE
    } playerType;
}

@property(nonatomic, assign) id<VideoHelperDelegate> delegate;
@property(nonatomic, assign) MEDIA_STATE mediaState;

- (id)initWithRootViewController:(UIViewController *) rootViewController;
- (BOOL)load:(NSString*)filename playImmediately:(BOOL)playOnTextureImmediately fromPosition:(float)seekPosition usingComposition:(VideoRenderCompositionType)videoComposition;
- (BOOL)unload;
- (BOOL)isPlayableOnTexture;
- (BOOL)isPlayableFullscreen;
- (MEDIA_STATE)getStatus;
- (int)getVideoHeight;
- (int)getVideoWidth;
- (float)getLength;
- (BOOL)pause;
- (BOOL)stop;
- (GLuint)updateVideoData;
- (BOOL)seekTo:(float)position;
- (float)getCurrentPosition;
- (void)resetData;
//
- (AVPlayer*)currentPlayer;
- (BOOL)setVolume:(float)volume;
- (float)getVolume;

@end
