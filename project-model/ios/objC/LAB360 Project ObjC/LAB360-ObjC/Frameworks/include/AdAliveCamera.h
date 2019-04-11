//
//  AdAliveCamera.h
//  AdAlive
//
//  Created by Lab360 on 27/10/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Error code
 */
#define E_INITIALIZING_QCAR         100
#define E_INITIALIZING_CAMERA       110
#define E_STARTING_CAMERA           111
#define E_STOPPING_CAMERA           112
#define E_DEINIT_CAMERA             113
#define E_INIT_TRACKERS             120
#define E_LOADING_TRACKERS_DATA     121
#define E_STARTING_TRACKERS         122
#define E_STOPPING_TRACKERS         123
#define E_UNLOADING_TRACKERS_DATA   124
#define E_DEINIT_TRACKERS           125
#define E_CAMERA_NOT_STARTED        150
#define E_INTERNAL_ERROR             -1
#define E_NULL_URLSERVER            301

/**!
 Camera type
 */
typedef enum
{
    /**
     * Default camera device.  Usually BACK
     */
    CAMERA_DEFAULT = 0,
    /**
     * Rear facing camera
     */
    CAMERA_BACK,
    /**
     * Front facing camera
     */
    CAMERA_FRONT
}CAMERA;


/** An AR application must implement this protocol in order to be notified of
 * the init event of camera.
 */
@protocol AdAliveDelegate

@required

/**
 *  This method is called to notify the application that the initialization (initAR) is complete. 
 * Usually the application then starts the AR through a call to startAR. This method can be used to 
 * control a loading view or error handling.
 *
 *  \param error The error that occurred.
 */
- (void) onInitARDone:(NSError *)error;

/**
 * When called, update your object 'AdAliveView'.
 */
- (void) updateRenderingPrimitives;

@end

@class SampleApplicationSession;

/**
 * Main class image recognition API. It contains all the methods required to start , enable, 
 * disable the scanning functionality.
 */
@interface AdAliveCamera : NSObject

@property(nonatomic, strong) NSString *lastTargetName;
/**
 *  Returns the AdAlive object for the process.
 *
 *  \param accessKey User authentication key.
 *  \param secretKey Password authentication key;
 *  \param licenseKey License account key;
 *  \param urlServer Base url from log server;
 *  \param delegate A object that implements the AdAliveDelegate;
 *  \param error A object that return the error if exixts;
 *  \return The AdAlive object.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey licenseKey:(NSString *)licenseKey urlServer:(NSString *)urlServer userEmail:(NSString *)userEmail andDelegate:(id)delegate error:(NSError **)error;

/**
 *  Register the app identifier for user.
 */
- (void) registerAppID:(NSString*)appID;

/**
 *  Adjust auto focus in Camera.
 *
 *  \return YES if the auto-focus is activate, otherwise NO.
 */
- (BOOL)adjustAutoFocus;

/**
 *  Verify if the display is retina or not.
 *
 *  \return YES if is retina display, otherwise NO.
 */
- (BOOL)isRetinaDisplay;

/**
 *  Pause the AR session.
 *
 *  \param error The error that occurred.
 *
 *  \return YES if the requested operation was successful, otherwise NO.
 */
- (BOOL)pauseAR:(NSError **)error;

/**
 *  Resume the AR session
 *
 *  \param error The error that occurred.
 *
 *  \return YES if the requested operation was successful, otherwise NO.
 */
- (BOOL)resumeAR:(NSError **)error;

/**
 *  Initialize the AR session.
 */
- (void)initAR;

/**
 *  Stop the AR session
 *
 *  \param error The error that occurred.
 *
 *  \return YES if the requested operation was successful, otherwise NO.
 */
- (BOOL)stopAR:(NSError **)error;

/**
 *  Restart the AR session.
 *
 *  \param error The error that occurred.
 *
 *  \return YES if the requested operation was successful, otherwise NO.
 */
- (BOOL)startAR:(CAMERA)option error:(NSError **)error;

/**
 *  Stop the camera.
 *
 *  \param error The error that occurred.
 *
 *  \return YES if the requested operation was successful, otherwise NO.
 */
- (BOOL)stopCamera:(NSError **)error;

/**
 *  Verify if the visual search is visible.
 *
 *  \return YES if the Visual search is visible, otherwise NO.
 */
- (BOOL)isVisualSearchOn;

/**
 *  Verify if the camera device is ready to use.
 *
 *  \return YES if the camera is ready do use, otherwise NO.
 */
- (BOOL)checkCameraStarted;

/**
 *  Switch the visual search mode.
 */
- (void)toggleVisualSearch;

/**
 *  Enable/disable torch mode if the device supports it.
 *
 *  \param isOn YES to set the flash as on, NO to set it as off. The default is NO.
 *
 *  \return YES if the requested operation was successful, otherwise NO.
 */
- (BOOL)setFlashMode:(BOOL)isOn;

/**
 *  Verify if the used camera is frontal or not.
 *
 *  \return YES if is frontal, otherwise NO.
 */
- (BOOL)isFrontalCamera;

/**
 *  Initialize the capture of images in frame.
 */
- (void)initRenderFrame;

/**
 *  Returns the trackable results.
 *
 *  \return A string with de product code.
 */
- (NSString *)getTrackableResults;

/**
 *  Verify if trackable results exists.
 *
 *  \return YES if the trackable results is greater than 0, otherwise NO.
 */
- (BOOL)hasTrackableResult;

-(int) viewPositionX;
-(int) viewPositionY;
-(int) viewPositionSizeX;
-(int) viewPositionSizeY;

@end
