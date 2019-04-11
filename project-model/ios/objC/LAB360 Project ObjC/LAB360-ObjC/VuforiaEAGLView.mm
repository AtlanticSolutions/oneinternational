//
//  VuforiaEAGLView.m
//  VuforiaSampleSwift
//
//  Created by Yoshihiro Kato on 2016/07/02.
//  Copyright © 2016年 Yoshihiro Kato. All rights reserved.
//

#import "VuforiaEAGLView.h"

#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <sys/time.h>

#import <Vuforia/UIGLViewProtocol.h>
#import <Vuforia/Renderer.h>
#import <Vuforia/CameraDevice.h>
#import <Vuforia/Vuforia.h>
#import <Vuforia/TrackerManager.h>
#import <Vuforia/Tool.h>
#import <Vuforia/ObjectTracker.h>
#import <Vuforia/State.h>
#import <Vuforia/Tool.h>
#import <Vuforia/ObjectTracker.h>
#import <Vuforia/RotationalDeviceTracker.h>
#import <Vuforia/StateUpdater.h>
#import <Vuforia/GLRenderer.h>
#import <Vuforia/VideoBackgroundConfig.h>
#import <Vuforia/View.h>
#import <Vuforia/RenderingPrimitives.h>
#import <Vuforia/Device.h>
#import <Vuforia/TrackableResult.h>

#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <Vuforia/Matrices.h>
#import <Vuforia/Image.h>
#import <Vuforia/Vectors.h>

#import "VuforiaShaderUtils.h"

namespace VuforiaEAGLViewUtils
{
    // Print a 4x4 matrix
    void printMatrix(const float* matrix);
    
    // Print GL error information
    void checkGlError(const char* operation);
    
    // Set identity matrix
    void setIdentityMatrix(float *matrix);
    
    // Make matrices functions
    Vuforia::Matrix44F Matrix44FIdentity();
    Vuforia::Matrix34F Matrix34FIdentity();
    Vuforia::Matrix44F copyMatrix(const Vuforia::Matrix44F& m);
    Vuforia::Matrix34F copyMatrix(const Vuforia::Matrix34F& m);
    void makeRotationMatrix(float angle, const Vuforia::Vec3F& axis, Vuforia::Matrix44F& m);
    void makeTranslationMatrix(const Vuforia::Vec3F& trans, Vuforia::Matrix44F& m);
    void makeScalingMatrix(const Vuforia::Vec3F& scale, Vuforia::Matrix44F& m);
    
    // Set the rotation components of a 4x4 matrix
    void setRotationMatrix(float angle, float x, float y, float z,
                           float *nMatrix);
    
    // Set the translation components of a 4x4 matrix
    void translatePoseMatrix(float x, float y, float z,
                             float* nMatrix);
    void translatePoseMatrix(float x, float y, float z, Vuforia::Matrix44F& m);
    
    // Apply a rotation
    void rotatePoseMatrix(float angle, float x, float y, float z,
                          float* nMatrix);
    void rotatePoseMatrix(float angle, float x, float y, float z, Vuforia::Matrix44F& m);
    
    // Apply a scaling transformation
    void scalePoseMatrix(float x, float y, float z, float* nMatrix);
    void scalePoseMatrix(float x, float y, float z, Vuforia::Matrix44F& m);
    
    // Multiply the two matrices A and B and write the result to C
    void multiplyMatrix(float *matrixA, float *matrixB,
                        float *matrixC);
    void multiplyMatrix(const Vuforia::Matrix44F& matrixA, const Vuforia::Matrix44F& matrixB, Vuforia::Matrix44F& matrixC);
    
    // Transpose and inverse functions for 4x4 matrices
    Vuforia::Matrix44F Matrix44FTranspose(const Vuforia::Matrix44F& m);
    float Matrix44FDeterminate(const Vuforia::Matrix44F& m);
    Vuforia::Matrix44F Matrix44FInverse(const Vuforia::Matrix44F& m);
    
    // Transform pose from World Coordinate System to Camera Coordinate System (180 degree rotation between both CS)
    void convertPoseBetweenWorldAndCamera(const Vuforia::Matrix44F& matrixIn, Vuforia::Matrix44F& matrixOut);
    
    // Initialise a shader
    int initShader(GLenum nShaderType, const char* pszSource, const char* pszDefs = NULL);
    
    // Create a shader program
    //    int createProgramFromBuffer(const char* pszVertexSource,
    //                                const char* pszFragmentSource,
    //                                const char* pszVertexShaderDefs = NULL,
    //                                const char* pszFragmentShaderDefs = NULL);
    
    void setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop,
                        float nNear, float nFar, float *nProjMatrix);
    void setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop,
                        float nNear, float nFar, Vuforia::Matrix44F& nProjMatrix);
    
    void screenCoordToCameraCoord(int screenX, int screenY, int screenDX, int screenDY,
                                  int screenWidth, int screenHeight, int cameraWidth, int cameraHeight,
                                  int * cameraX, int* cameraY, int * cameraDX, int * cameraDY);
    
}


//******************************************************************************
// *** OpenGL ES thread safety ***
//
// OpenGL ES on iOS is not thread safe.  We ensure thread safety by following
// this procedure:
// 1) Create the OpenGL ES context on the main thread.
// 2) Start the Vuforia camera, which causes Vuforia to locate our EAGLView and start
//    the render thread.
// 3) Vuforia calls our renderFrameVuforia method periodically on the render thread.
//    The first time this happens, the defaultFramebuffer does not exist, so it
//    is created with a call to createFramebuffer.  createFramebuffer is called
//    on the main thread in order to safely allocate the OpenGL ES storage,
//    which is shared with the drawable layer.  The render (background) thread
//    is blocked during the call to createFramebuffer, thus ensuring no
//    concurrent use of the OpenGL ES context.
//
//******************************************************************************

@interface VuforiaEAGLView (PrivateMethods)

- (void)initShaders;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end


@implementation VuforiaEAGLView {
    __weak VuforiaManager* _manager;
    
    // OpenGL ES context
    EAGLContext* _context;
    
    // The OpenGL ES names for the framebuffer and renderbuffers used to render
    // to this view
    GLuint _defaultFramebuffer;
    GLuint _colorRenderbuffer;
    GLuint _depthRenderbuffer;
    
    
    BOOL _offTargetTrackingEnabled;
    
    SCNRenderer* _renderer; // Renderer
    SCNNode* _cameraNode; // Camera Node
    CFAbsoluteTime _startTime; // Start Time
    
    SCNNode* _currentTouchNode;
    
    SCNMatrix4 _projectionTransform;
    
    CGFloat _nearPlane;
    CGFloat _farPlane;
    
    GLuint _vbShaderProgramID;
    GLint _vbVertexHandle;
    GLint _vbTexCoordHandle;
    GLint _vbTexSampler2DHandle;
    GLint _vbProjectionMatrixHandle;
    Vuforia::VIEW _currentView;
    Vuforia::RenderingPrimitives* _currentRenderingPrimitives;
}

// You must implement this method, which ensures the view's underlying layer is
// of type CAEAGLLayer
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


//------------------------------------------------------------------------------
#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame manager:(VuforiaManager *)manager
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _manager = manager;
        // Enable retina mode if available on this device
        if (YES == [_manager isRetinaDisplay]) {
            [self setContentScaleFactor:[UIScreen mainScreen].nativeScale];
        }
        
        // Create the OpenGL ES context
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        // The EAGLContext must be set for each thread that wishes to use it.
        // Set it the first time this method is called (on the main thread)
        if (_context != [EAGLContext currentContext]) {
            [EAGLContext setCurrentContext:_context];
        }
        
        _offTargetTrackingEnabled = YES;
        _objectScale = 1.0;  //0.03175f;
        _nearPlane = 0.5;
        _farPlane = 10000.0;
        
        [self initRendering];
    }
    
    return self;
}

- (void) initRendering {
    // Video background rendering
    _vbShaderProgramID = [VuforiaShaderUtils createProgramWithVertexShaderFileName:@"VuforiaBackground.vertsh"
                                                            fragmentShaderFileName:@"VuforiaBackground.fragsh"];
    
    if (0 < _vbShaderProgramID) {
        _vbVertexHandle = glGetAttribLocation(_vbShaderProgramID, "vertexPosition");
        _vbTexCoordHandle = glGetAttribLocation(_vbShaderProgramID, "vertexTexCoord");
        _vbProjectionMatrixHandle = glGetUniformLocation(_vbShaderProgramID, "projectionMatrix");
        _vbTexSampler2DHandle = glGetUniformLocation(_vbShaderProgramID, "texSampler2D");
    }
    else {
        NSLog(@"Could not initialise video background shader");
    }
    
}


- (void)dealloc
{
    [self deleteFramebuffer];
    
    // Tear down context
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void) setNearPlane:(CGFloat) near farPlane:(CGFloat) far {
    _nearPlane = near;
    _farPlane = far;
}

- (void)setupRenderer {
    _startTime = CFAbsoluteTimeGetCurrent();
    _renderer = [SCNRenderer rendererWithContext:_context options:nil];
    _renderer.autoenablesDefaultLighting = YES;
    _renderer.playing = YES;
    
    if (_sceneSource != nil) {
        [self setNeedsChangeSceneWithUserInfo:nil];
    }
    
}

- (void)setNeedsChangeSceneWithUserInfo: (NSDictionary*)userInfo {
    SCNScene* scene = [self.sceneSource sceneForEAGLView:self userInfo:userInfo];
    if (scene == nil) {
        return;
    }
    
    SCNCamera* camera = [SCNCamera camera];
    _cameraNode = [SCNNode node];
    _cameraNode.camera = camera;
    _cameraNode.camera.projectionTransform = _projectionTransform;
    [scene.rootNode addChildNode:_cameraNode];
    
    _renderer.scene = scene;
    _renderer.pointOfView = _cameraNode;
}


- (void)finishOpenGLESCommands
{
    // Called in response to applicationWillResignActive.  The render loop has
    // been stopped, so we now make sure all OpenGL ES commands complete before
    // we (potentially) go into the background
    if (_context) {
        [EAGLContext setCurrentContext:_context];
        glFinish();
    }
}


- (void)freeOpenGLESResources
{
    // Called in response to applicationDidEnterBackground.  Free easily
    // recreated OpenGL ES resources
    [self deleteFramebuffer];
    glFinish();
}

- (void) setOffTargetTrackingMode:(BOOL) enabled {
    _offTargetTrackingEnabled = enabled;
}

// Convert Vuforia's matrix to SceneKit's matrix
- (SCNMatrix4)SCNMatrix4FromVuforiaMatrix44:(Vuforia::Matrix44F)matrix {
    GLKMatrix4 glkMatrix;
    
    for(int i=0; i<16; i++) {
        glkMatrix.m[i] = matrix.data[i];
    }
    
    return SCNMatrix4FromGLKMatrix4(glkMatrix);
    
}

// Set camera node matrix
- (void)setCameraMatrix:(Vuforia::Matrix44F)matrix {
    SCNMatrix4 extrinsic = [self SCNMatrix4FromVuforiaMatrix44:matrix];
    SCNMatrix4 inverted = SCNMatrix4Invert(extrinsic);
    _cameraNode.transform = inverted;
    
    //NSLog(@"position = %lf, %lf, %lf", _cameraNode.position.x, _cameraNode.position.y, _cameraNode.position.z); // デバッグ用
}

- (void)setProjectionMatrix:(Vuforia::Matrix44F)matrix {
    _projectionTransform = [self SCNMatrix4FromVuforiaMatrix44:matrix];
    _cameraNode.camera.projectionTransform = _projectionTransform;
}

//------------------------------------------------------------------------------
#pragma mark - UIGLViewProtocol methods

// Draw the current frame using OpenGL
//
// This method is called by Vuforia when it wishes to render the current frame to
// the screen.
//
// *** Vuforia will call this method periodically on a background thread ***
- (void)renderFrameVuforia
{
    if(!_manager.isCameraStarted) {
        return;
    }
    
    // Render video background and retrieve tracking state
    const Vuforia::State state = Vuforia::TrackerManager::getInstance().getStateUpdater().updateState();
    Vuforia::Renderer::getInstance().begin(state);
    
//    if(Vuforia::Renderer::getInstance().getVideoBackgroundConfig().mReflection == Vuforia::VIDEO_BACKGROUND_REFLECTION_ON)
//        glFrontFace(GL_CW);  //Front camera
//    else
//        glFrontFace(GL_CCW);   //Back camera
    
    if(_currentRenderingPrimitives == nullptr)
        [self updateRenderingPrimitives];
    
    Vuforia::ViewList& viewList = _currentRenderingPrimitives->getRenderingViews();
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_DEPTH_TEST);
    if (_offTargetTrackingEnabled) {
        glDisable(GL_CULL_FACE);
    } else {
        glEnable(GL_CULL_FACE);
    }
    glCullFace(GL_BACK);
    
    // Iterate over the ViewList
    for (int viewIdx = 0; viewIdx < viewList.getNumViews(); viewIdx++) {
        Vuforia::VIEW vw = viewList.getView(viewIdx);
        _currentView = vw;
        
        // Set up the viewport
        Vuforia::Vec4I viewport;
        // We're writing directly to the screen, so the viewport is relative to the screen
        viewport = _currentRenderingPrimitives->getViewport(vw);
        
        // Set viewport for current view
        glViewport(viewport.data[0], viewport.data[1], viewport.data[2], viewport.data[3]);
        
        //set scissor
        glScissor(viewport.data[0], viewport.data[1], viewport.data[2], viewport.data[3]);
        
        Vuforia::Matrix34F projMatrix = _currentRenderingPrimitives->getProjectionMatrix(vw, state.getCameraCalibration());
        
        Vuforia::Matrix44F rawProjectionMatrixGL = Vuforia::Tool::convertPerspectiveProjection2GLMatrix(projMatrix, _nearPlane, _farPlane);
        
        // Apply the appropriate eye adjustment to the raw projection matrix, and assign to the global variable
        Vuforia::Matrix44F eyeAdjustmentGL = Vuforia::Tool::convert2GLMatrix(_currentRenderingPrimitives->getEyeDisplayAdjustmentMatrix(vw));
        
        Vuforia::Matrix44F projectionMatrix;
        VuforiaEAGLViewUtils::multiplyMatrix(&rawProjectionMatrixGL.data[0], &eyeAdjustmentGL.data[0], &projectionMatrix.data[0]);
        
        if (_currentView != Vuforia::VIEW_POSTPROCESS) {
            [self renderFrameWithState:state projectMatrix:projectionMatrix];
        }
        
        glDisable(GL_SCISSOR_TEST);
        
    }
    
    Vuforia::Renderer::getInstance().end();
}

- (void)updateRenderingPrimitives
{
    delete _currentRenderingPrimitives;
    _currentRenderingPrimitives = new Vuforia::RenderingPrimitives(Vuforia::Device::getInstance().getRenderingPrimitives());
}

- (void) renderFrameWithState:(const Vuforia::State&) state projectMatrix:(Vuforia::Matrix44F&) projectionMatrix
{
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render video background and retrieve tracking state
    [self renderVideoBackground];
    
    glEnable(GL_DEPTH_TEST);
    // We must detect if background reflection is active and adjust the culling direction.
    // If the reflection is active, this means the pose matrix has been reflected as well,
    // therefore standard counter clockwise face culling will result in "inside out" models.
    
    if (_offTargetTrackingEnabled) {
        glDisable(GL_CULL_FACE);
    } else {
        glEnable(GL_CULL_FACE);
    }
    
    glCullFace(GL_BACK);
    
    if( state.getNumTrackableResults() == 0 ) {
        VuforiaEAGLViewUtils::checkGlError("Render Frame, no trackables");
    }
    else {
        
        // Set the viewport
        glViewport((GLint)_manager.viewport.origin.x, (GLint)_manager.viewport.origin.y, (GLsizei)_manager.viewport.size.width, (GLsizei)_manager.viewport.size.height);
        
        for (int i = 0; i < state.getNumTrackableResults(); ++i) {
            // Get the trackable
            const Vuforia::TrackableResult* result = state.getTrackableResult(i);
            
            Vuforia::Matrix44F modelViewMatrix = Vuforia::Tool::convertPose2GLMatrix(result->getPose());
            
            if (_offTargetTrackingEnabled) {
                //VuforiaEAGLViewUtils::rotatePoseMatrix(90.0, 1.0, 0.0, 0.0, &modelViewMatrix.data[0]);
                VuforiaEAGLViewUtils::scalePoseMatrix(_objectScale,  _objectScale,  _objectScale, &modelViewMatrix.data[0]);
            }else{
                VuforiaEAGLViewUtils::translatePoseMatrix(0.0f, 0.0f, _objectScale, &modelViewMatrix.data[0]);
                VuforiaEAGLViewUtils::scalePoseMatrix(_objectScale,  _objectScale,  _objectScale, &modelViewMatrix.data[0]);
            }
            
            VuforiaEAGLViewUtils::convertPoseBetweenWorldAndCamera(modelViewMatrix, modelViewMatrix);
            [self setCameraMatrix:modelViewMatrix]; // SCNCameraにセット
            
            [SCNTransaction flush];
            
            CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent() - _startTime;
            [_renderer renderAtTime: currentTime];
            
            VuforiaEAGLViewUtils::checkGlError("EAGLView renderFrameVuforia");
        }
        
    }
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    [self presentFramebuffer];
    
}

- (void) renderVideoBackground {
    if (_currentView == Vuforia::VIEW_POSTPROCESS) {
        return;
    }
    
    // Use texture unit 0 for the video background - this will hold the camera frame and we want to reuse for all views
    // So need to use a different texture unit for the augmentation
    int vbVideoTextureUnit = 0;
    
    // Bind the video bg texture and get the Texture ID from Vuforia
    Vuforia::GLTextureUnit tex;
    tex.mTextureUnit = vbVideoTextureUnit;
    
    if (! Vuforia::Renderer::getInstance().updateVideoBackgroundTexture(&tex))
    {
        NSLog(@"Unable to bind video background texture!!");
        return;
    }
    
    Vuforia::Matrix44F vbProjectionMatrix = Vuforia::Tool::convert2GLMatrix(_currentRenderingPrimitives->getVideoBackgroundProjectionMatrix(_currentView));
    
    // Apply the scene scale on video see-through eyewear, to scale the video background and augmentation
    // so that the display lines up with the real world
    // This should not be applied on optical see-through devices, as there is no video background,
    // and the calibration ensures that the augmentation matches the real world
    if (Vuforia::Device::getInstance().isViewerActive())
    {
        float sceneScaleFactor = [self getSceneScaleFactorWithViewId:_currentView];
        VuforiaEAGLViewUtils::scalePoseMatrix(sceneScaleFactor, sceneScaleFactor, 1.0f, vbProjectionMatrix.data);
    }
    
    glDisable(GL_DEPTH_TEST);
    if (_offTargetTrackingEnabled) {
        glDisable(GL_CULL_FACE);
    } else {
        glEnable(GL_CULL_FACE);
    }
    glDisable(GL_SCISSOR_TEST);
    
    const Vuforia::Mesh& vbMesh = _currentRenderingPrimitives->getVideoBackgroundMesh(_currentView);
    // Load the shader and upload the vertex/texcoord/index data
    glUseProgram(_vbShaderProgramID);
    glVertexAttribPointer(_vbVertexHandle, 3, GL_FLOAT, false, 0, vbMesh.getPositionCoordinates());
    glVertexAttribPointer(_vbTexCoordHandle, 2, GL_FLOAT, false, 0, vbMesh.getUVCoordinates());
    
    glUniform1i(_vbTexSampler2DHandle, vbVideoTextureUnit);
    
    // Render the video background with the custom shader
    // First, we enable the vertex arrays
    glEnableVertexAttribArray(_vbVertexHandle);
    glEnableVertexAttribArray(_vbTexCoordHandle);
    
    // Pass the projection matrix to OpenGL
    glUniformMatrix4fv(_vbProjectionMatrixHandle, 1, GL_FALSE, vbProjectionMatrix.data);
    
    // Then, we issue the render call
    glDrawElements(GL_TRIANGLES, vbMesh.getNumTriangles() * 3, GL_UNSIGNED_SHORT, vbMesh.getTriangles());
    
    // Finally, we disable the vertex arrays
    glDisableVertexAttribArray(_vbVertexHandle);
    glDisableVertexAttribArray(_vbTexCoordHandle);
    
    VuforiaEAGLViewUtils::checkGlError("Rendering of the video background failed");
}

-(float) getSceneScaleFactorWithViewId:(Vuforia::VIEW)viewId
{
    // Get the y-dimension of the physical camera field of view
    Vuforia::Vec2F fovVector = Vuforia::CameraDevice::getInstance().getCameraCalibration().getFieldOfViewRads();
    float cameraFovYRads = fovVector.data[1];
    
    // Get the y-dimension of the virtual camera field of view
    Vuforia::Vec4F virtualFovVector = _currentRenderingPrimitives->getEffectiveFov(viewId); // {left, right, bottom, top}
    float virtualFovYRads = virtualFovVector.data[2] + virtualFovVector.data[3];
    
    // The scene-scale factor represents the proportion of the viewport that is filled by
    // the video background when projected onto the same plane.
    // In order to calculate this, let 'd' be the distance between the cameras and the plane.
    // The height of the projected image 'h' on this plane can then be calculated:
    //   tan(fov/2) = h/2d
    // which rearranges to:
    //   2d = h/tan(fov/2)
    // Since 'd' is the same for both cameras, we can combine the equations for the two cameras:
    //   hPhysical/tan(fovPhysical/2) = hVirtual/tan(fovVirtual/2)
    // Which rearranges to:
    //   hPhysical/hVirtual = tan(fovPhysical/2)/tan(fovVirtual/2)
    // ... which is the scene-scale factor
    return tan(cameraFovYRads / 2) / tan(virtualFovYRads / 2);
}

#pragma mark Touch Evnets
- (SCNNode*)touchedNodeWithLocationInView:(CGPoint)location {
    CGPoint pos = location;
    pos.x *= [[UIScreen mainScreen] nativeScale];
    pos.y *= [[UIScreen mainScreen] nativeScale];
    pos.x = pos.x - _manager.viewport.origin.x;
    pos.y = _manager.viewport.size.height + _manager.viewport.origin.y - pos.y;
    NSArray* results = [_renderer hitTest:pos options:nil];
    return [[results firstObject] node];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [touches.anyObject locationInView:self];
    SCNNode* result = [self touchedNodeWithLocationInView:pos];
    if(result){
        _currentTouchNode = result;
        [self.delegate vuforiaEAGLView:self didTouchDownNode:result];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(!_currentTouchNode) {
        return;
    }
    
    CGPoint pos = [touches.anyObject locationInView:self];
    SCNNode* result = [self touchedNodeWithLocationInView:pos];
    if(_currentTouchNode == result){
        [self.delegate vuforiaEAGLView:self didTouchUpNode:result];
    }else {
        [self.delegate vuforiaEAGLView:self didTouchCancelNode:_currentTouchNode];
    }
    _currentTouchNode = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(_currentTouchNode) {
        [self.delegate vuforiaEAGLView:self didTouchCancelNode:_currentTouchNode];
    }
    _currentTouchNode = nil;
}

//------------------------------------------------------------------------------
#pragma mark - OpenGL ES management

- (void)createFramebuffer
{
    if (_context) {
        // Create default framebuffer object
        glGenFramebuffers(1, &_defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
        
        // Create colour renderbuffer and allocate backing store
        glGenRenderbuffers(1, &_colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
        
        // Allocate the renderbuffer's storage (shared with the drawable object)
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
        GLint framebufferWidth;
        GLint framebufferHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        // Create the depth render buffer and allocate storage
        glGenRenderbuffers(1, &_depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        
        // Attach colour and depth render buffers to the frame buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderbuffer);
        
        // Leave the colour render buffer bound so future rendering operations will act on it
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    }
}


- (void)deleteFramebuffer
{
    if (_context) {
        [EAGLContext setCurrentContext:_context];
        
        if (_defaultFramebuffer) {
            glDeleteFramebuffers(1, &_defaultFramebuffer);
            _defaultFramebuffer = 0;
        }
        
        if (_colorRenderbuffer) {
            glDeleteRenderbuffers(1, &_colorRenderbuffer);
            _colorRenderbuffer = 0;
        }
        
        if (_depthRenderbuffer) {
            glDeleteRenderbuffers(1, &_depthRenderbuffer);
            _depthRenderbuffer = 0;
        }
    }
}


- (void)setFramebuffer
{
    // The EAGLContext must be set for each thread that wishes to use it.  Set
    // it the first time this method is called (on the render thread)
    if (_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_context];
    }
    
    if (!_defaultFramebuffer) {
        // Perform on the main thread to ensure safe memory allocation for the
        // shared buffer.  Block until the operation is complete to prevent
        // simultaneous access to the OpenGL context
        [self performSelectorOnMainThread:@selector(createFramebuffer) withObject:self waitUntilDone:YES];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
}


- (BOOL)presentFramebuffer
{
    // setFramebuffer must have been called before presentFramebuffer, therefore
    // we know the context is valid and has been set for this (render) thread
    
    // Bind the colour render buffer and present it
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    
    return [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (UIImage*)snapshot
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    float aWidth = self.layer.frame.size.width * self.layer.contentsScale;// self.frame.size.width * scale;
    float aHeight = self.layer.frame.size.height * self.layer.contentsScale;// self.frame.size.height * scale;
    
    NSInteger myDataLength = aWidth * aHeight * 4;
    
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, aWidth, aHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < aHeight; y++)
    {
        for(int x = 0; x < aWidth * 4; x++)
        {
            buffer2[((int)aHeight-1 - y) * (int)aWidth * 4 + x] = buffer[y * 4 * (int)aWidth + x];
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * aWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big|kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(aWidth, aHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

@end

#pragma mark - VuforiaEAGLViewUtils Implementation

namespace VuforiaEAGLViewUtils
{
    // Print a 4x4 matrix
    void
    printMatrix(const float* mat)
    {
        for (int r = 0; r < 4; r++, mat += 4) {
            printf("%7.3f %7.3f %7.3f %7.3f", mat[0], mat[1], mat[2], mat[3]);
        }
    }
    
    
    // Print GL error information
    void
    checkGlError(const char* operation)
    {
        for (GLint error = glGetError(); error; error = glGetError()) {
            printf("after %s() glError (0x%x)\n", operation, error);
        }
    }
    
    
    // Set identity 4x4 matrix
    void
    setIdentityMatrix(float *matrix)
    {
        for(int i = 0; i < 4; i++) {
            for(int j = 0; j < 4; j++) {
                if(i == j)
                    matrix[i*4 + j] = 1.0;
                else
                    matrix[i*4 + j] = 0;
            }
        }
        
    }
    
    
    Vuforia::Matrix44F
    Matrix44FIdentity()
    {
        Vuforia::Matrix44F r;
        
        for (int i = 0; i < 16; i++)
            r.data[i] = 0.0f;
        
        r.data[0] = 1.0f;
        r.data[5] = 1.0f;
        r.data[10] = 1.0f;
        r.data[15] = 1.0f;
        
        return r;
    }
    
    Vuforia::Matrix34F
    Matrix34FIdentity()
    {
        Vuforia::Matrix34F r;
        
        for (int i = 0; i < 12; i++)
            r.data[i] = 0.0f;
        
        r.data[0] = 1.0f;
        r.data[5] = 1.0f;
        r.data[10] = 1.0f;
        
        return r;
    }
    
    
    Vuforia::Matrix44F copyMatrix(const Vuforia::Matrix44F& m)
    {
        return m;
    }
    
    
    Vuforia::Matrix34F copyMatrix(const Vuforia::Matrix34F& m)
    {
        return m;
    }
    
    
    void
    makeRotationMatrix(float angle, const Vuforia::Vec3F& axis, Vuforia::Matrix44F& m)
    {
        double radians, c, s, c1, u[3], length;
        int i, j;
        
        m = Matrix44FIdentity();
        
        radians = (angle * M_PI) / 180.0;
        
        c = cos(radians);
        s = sin(radians);
        
        c1 = 1.0 - cos(radians);
        
        length = sqrt(axis.data[0] * axis.data[0] + axis.data[1] * axis.data[1] + axis.data[2] * axis.data[2]);
        
        u[0] = axis.data[0] / length;
        u[1] = axis.data[1] / length;
        u[2] = axis.data[2] / length;
        
        for (i = 0; i < 16; i++)
            m.data[i] = 0.0;
        
        m.data[15] = 1.0;
        
        for (i = 0; i < 3; i++)
        {
            m.data[i * 4 + (i + 1) % 3] = (float)(u[(i + 2) % 3] * s);
            m.data[i * 4 + (i + 2) % 3] = (float)(-u[(i + 1) % 3] * s);
        }
        
        for (i = 0; i < 3; i++)
        {
            for (j = 0; j < 3; j++)
                m.data[i * 4 + j] += (float)(c1 * u[i] * u[j] + (i == j ? c : 0.0));
        }
    }
    
    
    void
    makeTranslationMatrix(const Vuforia::Vec3F& trans, Vuforia::Matrix44F& m)
    {
        m = Matrix44FIdentity();
        
        m.data[12] = trans.data[0];
        m.data[13] = trans.data[1];
        m.data[14] = trans.data[2];
    }
    
    
    void
    makeScalingMatrix(const Vuforia::Vec3F& scale, Vuforia::Matrix44F& m)
    {
        m = Matrix44FIdentity();
        
        m.data[0] = scale.data[0];
        m.data[5] = scale.data[1];
        m.data[10] = scale.data[2];
    }
    
    
    // Set the rotation components of a 4x4 matrix
    void
    setRotationMatrix(float angle, float x, float y, float z,
                      float *matrix)
    {
        double radians, c, s, c1, u[3], length;
        int i, j;
        
        radians = (angle * M_PI) / 180.0;
        
        c = cos(radians);
        s = sin(radians);
        
        c1 = 1.0 - cos(radians);
        
        length = sqrt(x * x + y * y + z * z);
        
        u[0] = x / length;
        u[1] = y / length;
        u[2] = z / length;
        
        for (i = 0; i < 16; i++) {
            matrix[i] = 0.0;
        }
        
        matrix[15] = 1.0;
        
        for (i = 0; i < 3; i++) {
            matrix[i * 4 + (i + 1) % 3] = u[(i + 2) % 3] * s;
            matrix[i * 4 + (i + 2) % 3] = -u[(i + 1) % 3] * s;
        }
        
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 3; j++) {
                matrix[i * 4 + j] += c1 * u[i] * u[j] + (i == j ? c : 0.0);
            }
        }
    }
    
    
    // Set the translation components of a 4x4 matrix
    void
    translatePoseMatrix(float x, float y, float z, float* matrix)
    {
        if (matrix) {
            // matrix * translate_matrix
            matrix[12] += (matrix[0] * x + matrix[4] * y + matrix[8]  * z);
            matrix[13] += (matrix[1] * x + matrix[5] * y + matrix[9]  * z);
            matrix[14] += (matrix[2] * x + matrix[6] * y + matrix[10] * z);
            matrix[15] += (matrix[3] * x + matrix[7] * y + matrix[11] * z);
        }
    }
    
    
    void
    translatePoseMatrix(float x, float y, float z, Vuforia::Matrix44F& m)
    {
        // m = m * translate_m
        m.data[12] +=
        (m.data[0] * x + m.data[4] * y + m.data[8] * z);
        
        m.data[13] +=
        (m.data[1] * x + m.data[5] * y + m.data[9] * z);
        
        m.data[14] +=
        (m.data[2] * x + m.data[6] * y + m.data[10] * z);
        
        m.data[15] +=
        (m.data[3] * x + m.data[7] * y + m.data[11] * z);
    }
    
    
    // Apply a rotation
    void
    rotatePoseMatrix(float angle, float x, float y, float z,
                     float* matrix)
    {
        if (matrix) {
            float rotate_matrix[16];
            setRotationMatrix(angle, x, y, z, rotate_matrix);
            
            // matrix * scale_matrix
            multiplyMatrix(matrix, rotate_matrix, matrix);
        }
    }
    
    
    void
    rotatePoseMatrix(float angle, float x, float y, float z, Vuforia::Matrix44F& m)
    {
        Vuforia::Matrix44F rotationMatrix;
        
        // create a rotation matrix
        makeRotationMatrix(angle, Vuforia::Vec3F(x,y,z), rotationMatrix);
        
        multiplyMatrix(m, rotationMatrix, m);
    }
    
    
    // Apply a scaling transformation
    void
    scalePoseMatrix(float x, float y, float z, float* matrix)
    {
        if (matrix) {
            // matrix * scale_matrix
            matrix[0]  *= x;
            matrix[1]  *= x;
            matrix[2]  *= x;
            matrix[3]  *= x;
            
            matrix[4]  *= y;
            matrix[5]  *= y;
            matrix[6]  *= y;
            matrix[7]  *= y;
            
            matrix[8]  *= z;
            matrix[9]  *= z;
            matrix[10] *= z;
            matrix[11] *= z;
        }
    }
    
    void
    scalePoseMatrix(float x, float y, float z, Vuforia::Matrix44F& matrix)
    {
        // matrix * scale_matrix
        matrix.data[0]  *= x;
        matrix.data[1]  *= x;
        matrix.data[2]  *= x;
        matrix.data[3]  *= x;
        
        matrix.data[4]  *= y;
        matrix.data[5]  *= y;
        matrix.data[6]  *= y;
        matrix.data[7]  *= y;
        
        matrix.data[8]  *= z;
        matrix.data[9]  *= z;
        matrix.data[10] *= z;
        matrix.data[11] *= z;
    }
    
    
    // Multiply the two matrices A and B and write the result to C
    void
    multiplyMatrix(float *matrixA, float *matrixB, float *matrixC)
    {
        int i, j, k;
        float aTmp[16];
        
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                aTmp[j * 4 + i] = 0.0;
                
                for (k = 0; k < 4; k++) {
                    aTmp[j * 4 + i] += matrixA[k * 4 + i] * matrixB[j * 4 + k];
                }
            }
        }
        
        for (i = 0; i < 16; i++) {
            matrixC[i] = aTmp[i];
        }
    }
    
    
    void
    multiplyMatrix(const Vuforia::Matrix44F& matrixA, const Vuforia::Matrix44F& matrixB, Vuforia::Matrix44F& matrixC)
    {
        int i, j, k;
        Vuforia::Matrix44F aTmp;
        
        // matrixC= matrixA * matrixB
        for (i = 0; i < 4; i++)
        {
            for (j = 0; j < 4; j++)
            {
                aTmp.data[j * 4 + i] = 0.0;
                
                for (k = 0; k < 4; k++)
                    aTmp.data[j * 4 + i] += matrixA.data[k * 4 + i] * matrixB.data[j * 4 + k];
            }
        }
        
        for (i = 0; i < 16; i++)
            matrixC.data[i] = aTmp.data[i];
    }
    
    
    Vuforia::Matrix44F
    Matrix44FTranspose(const Vuforia::Matrix44F& m)
    {
        Vuforia::Matrix44F r;
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                r.data[i*4+j] = m.data[i+4*j];
        return r;
    }
    
    
    float
    Matrix44FDeterminate(const Vuforia::Matrix44F& m)
    {
        return  m.data[12] * m.data[9] * m.data[6] * m.data[3] - m.data[8] * m.data[13] * m.data[6] * m.data[3] -
        m.data[12] * m.data[5] * m.data[10] * m.data[3] + m.data[4] * m.data[13] * m.data[10] * m.data[3] +
        m.data[8] * m.data[5] * m.data[14] * m.data[3] - m.data[4] * m.data[9] * m.data[14] * m.data[3] -
        m.data[12] * m.data[9] * m.data[2] * m.data[7] + m.data[8] * m.data[13] * m.data[2] * m.data[7] +
        m.data[12] * m.data[1] * m.data[10] * m.data[7] - m.data[0] * m.data[13] * m.data[10] * m.data[7] -
        m.data[8] * m.data[1] * m.data[14] * m.data[7] + m.data[0] * m.data[9] * m.data[14] * m.data[7] +
        m.data[12] * m.data[5] * m.data[2] * m.data[11] - m.data[4] * m.data[13] * m.data[2] * m.data[11] -
        m.data[12] * m.data[1] * m.data[6] * m.data[11] + m.data[0] * m.data[13] * m.data[6] * m.data[11] +
        m.data[4] * m.data[1] * m.data[14] * m.data[11] - m.data[0] * m.data[5] * m.data[14] * m.data[11] -
        m.data[8] * m.data[5] * m.data[2] * m.data[15] + m.data[4] * m.data[9] * m.data[2] * m.data[15] +
        m.data[8] * m.data[1] * m.data[6] * m.data[15] - m.data[0] * m.data[9] * m.data[6] * m.data[15] -
        m.data[4] * m.data[1] * m.data[10] * m.data[15] + m.data[0] * m.data[5] * m.data[10] * m.data[15] ;
    }
    
    
    Vuforia::Matrix44F
    Matrix44FInverse(const Vuforia::Matrix44F& m)
    {
        Vuforia::Matrix44F r;
        
        float det = 1.0f / Matrix44FDeterminate(m);
        
        r.data[0]   = m.data[6]*m.data[11]*m.data[13] - m.data[7]*m.data[10]*m.data[13]
        + m.data[7]*m.data[9]*m.data[14] - m.data[5]*m.data[11]*m.data[14]
        - m.data[6]*m.data[9]*m.data[15] + m.data[5]*m.data[10]*m.data[15];
        
        r.data[4]   = m.data[3]*m.data[10]*m.data[13] - m.data[2]*m.data[11]*m.data[13]
        - m.data[3]*m.data[9]*m.data[14] + m.data[1]*m.data[11]*m.data[14]
        + m.data[2]*m.data[9]*m.data[15] - m.data[1]*m.data[10]*m.data[15];
        
        r.data[8]   = m.data[2]*m.data[7]*m.data[13] - m.data[3]*m.data[6]*m.data[13]
        + m.data[3]*m.data[5]*m.data[14] - m.data[1]*m.data[7]*m.data[14]
        - m.data[2]*m.data[5]*m.data[15] + m.data[1]*m.data[6]*m.data[15];
        
        r.data[12]  = m.data[3]*m.data[6]*m.data[9] - m.data[2]*m.data[7]*m.data[9]
        - m.data[3]*m.data[5]*m.data[10] + m.data[1]*m.data[7]*m.data[10]
        + m.data[2]*m.data[5]*m.data[11] - m.data[1]*m.data[6]*m.data[11];
        
        r.data[1]   = m.data[7]*m.data[10]*m.data[12] - m.data[6]*m.data[11]*m.data[12]
        - m.data[7]*m.data[8]*m.data[14] + m.data[4]*m.data[11]*m.data[14]
        + m.data[6]*m.data[8]*m.data[15] - m.data[4]*m.data[10]*m.data[15];
        
        r.data[5]   = m.data[2]*m.data[11]*m.data[12] - m.data[3]*m.data[10]*m.data[12]
        + m.data[3]*m.data[8]*m.data[14] - m.data[0]*m.data[11]*m.data[14]
        - m.data[2]*m.data[8]*m.data[15] + m.data[0]*m.data[10]*m.data[15];
        
        r.data[9]   = m.data[3]*m.data[6]*m.data[12] - m.data[2]*m.data[7]*m.data[12]
        - m.data[3]*m.data[4]*m.data[14] + m.data[0]*m.data[7]*m.data[14]
        + m.data[2]*m.data[4]*m.data[15] - m.data[0]*m.data[6]*m.data[15];
        
        r.data[13]  = m.data[2]*m.data[7]*m.data[8] - m.data[3]*m.data[6]*m.data[8]
        + m.data[3]*m.data[4]*m.data[10] - m.data[0]*m.data[7]*m.data[10]
        - m.data[2]*m.data[4]*m.data[11] + m.data[0]*m.data[6]*m.data[11];
        
        r.data[2]   = m.data[5]*m.data[11]*m.data[12] - m.data[7]*m.data[9]*m.data[12]
        + m.data[7]*m.data[8]*m.data[13] - m.data[4]*m.data[11]*m.data[13]
        - m.data[5]*m.data[8]*m.data[15] + m.data[4]*m.data[9]*m.data[15];
        
        r.data[6]   = m.data[3]*m.data[9]*m.data[12] - m.data[1]*m.data[11]*m.data[12]
        - m.data[3]*m.data[8]*m.data[13] + m.data[0]*m.data[11]*m.data[13]
        + m.data[1]*m.data[8]*m.data[15] - m.data[0]*m.data[9]*m.data[15];
        
        r.data[10]  = m.data[1]*m.data[7]*m.data[12] - m.data[3]*m.data[5]*m.data[12]
        + m.data[3]*m.data[4]*m.data[13] - m.data[0]*m.data[7]*m.data[13]
        - m.data[1]*m.data[4]*m.data[15] + m.data[0]*m.data[5]*m.data[15];
        
        r.data[14]  = m.data[3]*m.data[5]*m.data[8] - m.data[1]*m.data[7]*m.data[8]
        - m.data[3]*m.data[4]*m.data[9] + m.data[0]*m.data[7]*m.data[9]
        + m.data[1]*m.data[4]*m.data[11] - m.data[0]*m.data[5]*m.data[11];
        
        r.data[3]   = m.data[6]*m.data[9]*m.data[12] - m.data[5]*m.data[10]*m.data[12]
        - m.data[6]*m.data[8]*m.data[13] + m.data[4]*m.data[10]*m.data[13]
        + m.data[5]*m.data[8]*m.data[14] - m.data[4]*m.data[9]*m.data[14];
        
        r.data[7]  = m.data[1]*m.data[10]*m.data[12] - m.data[2]*m.data[9]*m.data[12]
        + m.data[2]*m.data[8]*m.data[13] - m.data[0]*m.data[10]*m.data[13]
        - m.data[1]*m.data[8]*m.data[14] + m.data[0]*m.data[9]*m.data[14];
        
        r.data[11]  = m.data[2]*m.data[5]*m.data[12] - m.data[1]*m.data[6]*m.data[12]
        - m.data[2]*m.data[4]*m.data[13] + m.data[0]*m.data[6]*m.data[13]
        + m.data[1]*m.data[4]*m.data[14] - m.data[0]*m.data[5]*m.data[14];
        
        r.data[15]  = m.data[1]*m.data[6]*m.data[8] - m.data[2]*m.data[5]*m.data[8]
        + m.data[2]*m.data[4]*m.data[9] - m.data[0]*m.data[6]*m.data[9]
        - m.data[1]*m.data[4]*m.data[10] + m.data[0]*m.data[5]*m.data[10];
        
        for (int i = 0; i < 16; i++)
            r.data[i] *= det;
        
        return r;
    }
    
    
    void
    convertPoseBetweenWorldAndCamera(const Vuforia::Matrix44F& matrixIn, Vuforia::Matrix44F& matrixOut)
    {
        Vuforia::Matrix44F convertCS;
        makeRotationMatrix(180.0f, Vuforia::Vec3F(1.0f, 0.0f, 0.0f), convertCS);
        
        Vuforia::Matrix44F tmp;
        multiplyMatrix(convertCS, matrixIn, tmp);
        
        for (int i = 0; i < 16; i++)
            matrixOut.data[i] = tmp.data[i];
    }
    
    
    // Initialise a shader
    int
    initShader(GLenum nShaderType, const char* pszSource, const char* pszDefs)
    {
        GLuint shader = glCreateShader(nShaderType);
        
        if (shader) {
            if(pszDefs == NULL)
            {
                glShaderSource(shader, 1, &pszSource, NULL);
            }
            else
            {
                const char* finalShader[2] = {pszDefs,pszSource};
                GLint finalShaderSizes[2] = {static_cast<GLint>(strlen(pszDefs)), static_cast<GLint>(strlen(pszSource))};
                glShaderSource(shader, 2, finalShader, finalShaderSizes);
            }
            
            glCompileShader(shader);
            GLint compiled = 0;
            glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
            
            if (!compiled) {
                GLint infoLen = 0;
                glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
                
                if (infoLen) {
                    char* buf = new char[infoLen];
                    glGetShaderInfoLog(shader, infoLen, NULL, buf);
                    printf("Could not compile shader %d: %s\n", shader, buf);
                    delete[] buf;
                }
            }
        }
        
        return shader;
    }
    
    
    // Create a shader program
    int
    createProgramFromBuffer(const char* pszVertexSource,
                            const char* pszFragmentSource,
                            const char* pszVertexShaderDefs,
                            const char* pszFragmentShaderDefs)
    
    {
        GLuint program = 0;
        GLuint vertexShader = initShader(GL_VERTEX_SHADER, pszVertexSource, pszVertexShaderDefs);
        GLuint fragmentShader = initShader(GL_FRAGMENT_SHADER, pszFragmentSource, pszFragmentShaderDefs);
        
        if (vertexShader && fragmentShader) {
            program = glCreateProgram();
            
            if (program) {
                glAttachShader(program, vertexShader);
                checkGlError("glAttachShader");
                glAttachShader(program, fragmentShader);
                checkGlError("glAttachShader");
                
                glLinkProgram(program);
                GLint linkStatus;
                glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
                
                if (GL_TRUE != linkStatus) {
                    GLint infoLen = 0;
                    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
                    
                    if (infoLen) {
                        char* buf = new char[infoLen];
                        glGetProgramInfoLog(program, infoLen, NULL, buf);
                        printf("Could not link program %d: %s\n", program, buf);
                        delete[] buf;
                    }
                }
            }
        }
        
        return program;
    }
    
    
    void
    setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop,
                   float nNear, float nFar, float *nProjMatrix)
    {
        if (!nProjMatrix)
        {
            //         arLogMessage(AR_LOG_LEVEL_ERROR, "PLShadersExample", "Orthographic projection matrix pointer is NULL");
            return;
        }
        
        for (int i = 0; i < 16; i++)
            nProjMatrix[i] = 0.0f;
        
        nProjMatrix[0] = 2.0f / (nRight - nLeft);
        nProjMatrix[5] = 2.0f / (nTop - nBottom);
        nProjMatrix[10] = 2.0f / (nNear - nFar);
        nProjMatrix[12] = -(nRight + nLeft) / (nRight - nLeft);
        nProjMatrix[13] = -(nTop + nBottom) / (nTop - nBottom);
        nProjMatrix[14] = (nFar + nNear) / (nFar - nNear);
        nProjMatrix[15] = 1.0f;
    }
    
    void
    setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop, float nNear, float nFar, Vuforia::Matrix44F& nProjMatrix)
    {
        nProjMatrix = Matrix44FIdentity();
        
        nProjMatrix.data[0] = 2.0f / (nRight - nLeft);
        nProjMatrix.data[5] = 2.0f / (nTop - nBottom);
        nProjMatrix.data[10] = 2.0f / (nNear - nFar);
        nProjMatrix.data[12] = -(nRight + nLeft) / (nRight - nLeft);
        nProjMatrix.data[13] = -(nTop + nBottom) / (nTop - nBottom);
        nProjMatrix.data[14] = (nFar + nNear) / (nFar - nNear);
        nProjMatrix.data[15] = 1.0f;
    }
    
    // Transforms a screen pixel to a pixel onto the camera image,
    // taking into account e.g. cropping of camera image to fit different aspect ratio screen.
    // for the camera dimensions, the width is always bigger than the height (always landscape orientation)
    // Top left of screen/camera is origin
    void
    screenCoordToCameraCoord(int screenX, int screenY, int screenDX, int screenDY,
                             int screenWidth, int screenHeight, int cameraWidth, int cameraHeight,
                             int * cameraX, int* cameraY, int * cameraDX, int * cameraDY)
    {
        
        printf("screenCoordToCameraCoord:%d,%d %d,%d, %d,%d, %d,%d",screenX, screenY, screenDX, screenDY,
               screenWidth, screenHeight, cameraWidth, cameraHeight );
        
        
        bool isPortraitMode = (screenWidth < screenHeight);
        float videoWidth, videoHeight;
        videoWidth = (float)cameraWidth;
        videoHeight = (float)cameraHeight;
        if (isPortraitMode)
        {
            // the width and height of the camera are always
            // based on a landscape orientation
            // videoWidth = (float)cameraHeight;
            // videoHeight = (float)cameraWidth;
            
            
            // as the camera coordinates are always in landscape
            // we convert the inputs into a landscape based coordinate system
            int tmp = screenX;
            screenX = screenY;
            screenY = screenWidth - tmp;
            
            tmp = screenDX;
            screenDX = screenDY;
            screenDY = tmp;
            
            tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
            
        }
        else
        {
            videoWidth = (float)cameraWidth;
            videoHeight = (float)cameraHeight;
        }
        
        float videoAspectRatio = videoHeight / videoWidth;
        float screenAspectRatio = (float) screenHeight / (float) screenWidth;
        
        float scaledUpX;
        float scaledUpY;
        float scaledUpVideoWidth;
        float scaledUpVideoHeight;
        
        if (videoAspectRatio < screenAspectRatio)
        {
            // the video height will fit in the screen height
            scaledUpVideoWidth = (float)screenHeight / videoAspectRatio;
            scaledUpVideoHeight = screenHeight;
            scaledUpX = (float)screenX + ((scaledUpVideoWidth - (float)screenWidth) / 2.0f);
            scaledUpY = (float)screenY;
        }
        else
        {
            // the video width will fit in the screen width
            scaledUpVideoHeight = (float)screenWidth * videoAspectRatio;
            scaledUpVideoWidth = screenWidth;
            scaledUpY = (float)screenY + ((scaledUpVideoHeight - (float)screenHeight)/2.0f);
            scaledUpX = (float)screenX;
        }
        
        if (cameraX)
        {
            *cameraX = (int)((scaledUpX / (float)scaledUpVideoWidth) * videoWidth);
        }
        
        if (cameraY)
        {
            *cameraY = (int)((scaledUpY / (float)scaledUpVideoHeight) * videoHeight);
        }
        
        if (cameraDX)
        {
            *cameraDX = (int)(((float)screenDX / (float)scaledUpVideoWidth) * videoWidth);
        }
        
        if (cameraDY)
        {
            *cameraDY = (int)(((float)screenDY / (float)scaledUpVideoHeight) * videoHeight);
        }
    }
    
    unsigned int
    createTexture(Vuforia::Image * image)
    {
        unsigned int glTextureID = -1;
        
        glGenTextures(1, &glTextureID);
        
        glBindTexture(GL_TEXTURE_2D, glTextureID);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        auto pixelFormat = image->getFormat();
        
        GLenum format;
        GLenum type;
        switch (pixelFormat)
        {
            case Vuforia::UNKNOWN_FORMAT:
            case Vuforia::YUV:
                return -1;
                
            case Vuforia::RGB565:
                type = GL_UNSIGNED_SHORT_5_6_5;
                format = GL_RGB;
                break;
            case Vuforia::RGB888:
                type = GL_UNSIGNED_BYTE;
                format = GL_RGB;
                break;
                
            case Vuforia::RGBA8888:
                type = GL_UNSIGNED_BYTE;
                format = GL_RGBA;
                break;
                
            case Vuforia::GRAYSCALE:
                type = GL_UNSIGNED_BYTE;
                format = GL_LUMINANCE;
                break;
                
            default:
                return -1;
        }
        
        glTexImage2D(GL_TEXTURE_2D, 0, format , image->getWidth(), image->getHeight(), 0,
                     format, type, image->getPixels());
        glBindTexture(GL_TEXTURE_2D, 0);
        
        return glTextureID;
    }
    
//    // Print a 4x4 matrix
//    void
//    printMatrix(const float* mat)
//    {
//        for (int r = 0; r < 4; r++, mat += 4) {
//            printf("%7.3f %7.3f %7.3f %7.3f", mat[0], mat[1], mat[2], mat[3]);
//        }
//    }
//
//
//    // Print GL error information
//    void
//    checkGlError(const char* operation)
//    {
//        for (GLint error = glGetError(); error; error = glGetError()) {
//            printf("after %s() glError (0x%x)\n", operation, error);
//        }
//    }
//
//
//    // Set the rotation components of a 4x4 matrix
//    void
//    setRotationMatrix(float angle, float x, float y, float z,
//                      float *matrix)
//    {
//        double radians, c, s, c1, u[3], length;
//        int i, j;
//
//        radians = (angle * M_PI) / 180.0;
//
//        c = cos(radians);
//        s = sin(radians);
//
//        c1 = 1.0 - cos(radians);
//
//        length = sqrt(x * x + y * y + z * z);
//
//        u[0] = x / length;
//        u[1] = y / length;
//        u[2] = z / length;
//
//        for (i = 0; i < 16; i++) {
//            matrix[i] = 0.0;
//        }
//
//        matrix[15] = 1.0;
//
//        for (i = 0; i < 3; i++) {
//            matrix[i * 4 + (i + 1) % 3] = u[(i + 2) % 3] * s;
//            matrix[i * 4 + (i + 2) % 3] = -u[(i + 1) % 3] * s;
//        }
//
//        for (i = 0; i < 3; i++) {
//            for (j = 0; j < 3; j++) {
//                matrix[i * 4 + j] += c1 * u[i] * u[j] + (i == j ? c : 0.0);
//            }
//        }
//    }
//
//
//    // Set the translation components of a 4x4 matrix
//    void
//    translatePoseMatrix(float x, float y, float z, float* matrix)
//    {
//        if (matrix) {
//            // matrix * translate_matrix
//            matrix[12] += (matrix[0] * x + matrix[4] * y + matrix[8]  * z);
//            matrix[13] += (matrix[1] * x + matrix[5] * y + matrix[9]  * z);
//            matrix[14] += (matrix[2] * x + matrix[6] * y + matrix[10] * z);
//            matrix[15] += (matrix[3] * x + matrix[7] * y + matrix[11] * z);
//        }
//    }
//
//
//    // Apply a rotation
//    void
//    rotatePoseMatrix(float angle, float x, float y, float z,
//                     float* matrix)
//    {
//        if (matrix) {
//            float rotate_matrix[16];
//            setRotationMatrix(angle, x, y, z, rotate_matrix);
//
//            // matrix * scale_matrix
//            multiplyMatrix(matrix, rotate_matrix, matrix);
//        }
//    }
//
//
//    // Apply a scaling transformation
//    void
//    scalePoseMatrix(float x, float y, float z, float* matrix)
//    {
//        if (matrix) {
//            // matrix * scale_matrix
//            matrix[0]  *= x;
//            matrix[1]  *= x;
//            matrix[2]  *= x;
//            matrix[3]  *= x;
//
//            matrix[4]  *= y;
//            matrix[5]  *= y;
//            matrix[6]  *= y;
//            matrix[7]  *= y;
//
//            matrix[8]  *= z;
//            matrix[9]  *= z;
//            matrix[10] *= z;
//            matrix[11] *= z;
//        }
//    }
//
//
//    // Multiply the two matrices A and B and write the result to C
//    void
//    multiplyMatrix(float *matrixA, float *matrixB, float *matrixC)
//    {
//        int i, j, k;
//        float aTmp[16];
//
//        for (i = 0; i < 4; i++) {
//            for (j = 0; j < 4; j++) {
//                aTmp[j * 4 + i] = 0.0;
//
//                for (k = 0; k < 4; k++) {
//                    aTmp[j * 4 + i] += matrixA[k * 4 + i] * matrixB[j * 4 + k];
//                }
//            }
//        }
//
//        for (i = 0; i < 16; i++) {
//            matrixC[i] = aTmp[i];
//        }
//    }
//
//    void
//    setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop,
//                   float nNear, float nFar, float *nProjMatrix)
//    {
//        if (!nProjMatrix)
//        {
//            //         arLogMessage(AR_LOG_LEVEL_ERROR, "PLShadersExample", "Orthographic projection matrix pointer is NULL");
//            return;
//        }
//
//        int i;
//        for (i = 0; i < 16; i++)
//            nProjMatrix[i] = 0.0f;
//
//        nProjMatrix[0] = 2.0f / (nRight - nLeft);
//        nProjMatrix[5] = 2.0f / (nTop - nBottom);
//        nProjMatrix[10] = 2.0f / (nNear - nFar);
//        nProjMatrix[12] = -(nRight + nLeft) / (nRight - nLeft);
//        nProjMatrix[13] = -(nTop + nBottom) / (nTop - nBottom);
//        nProjMatrix[14] = (nFar + nNear) / (nFar - nNear);
//        nProjMatrix[15] = 1.0f;
//    }
//
//    // Transforms a screen pixel to a pixel onto the camera image,
//    // taking into account e.g. cropping of camera image to fit different aspect ratio screen.
//    // for the camera dimensions, the width is always bigger than the height (always landscape orientation)
//    // Top left of screen/camera is origin
//    void
//    screenCoordToCameraCoord(int screenX, int screenY, int screenDX, int screenDY,
//                             int screenWidth, int screenHeight, int cameraWidth, int cameraHeight,
//                             int * cameraX, int* cameraY, int * cameraDX, int * cameraDY)
//    {
//
//        printf("screenCoordToCameraCoord:%d,%d %d,%d, %d,%d, %d,%d",screenX, screenY, screenDX, screenDY,
//               screenWidth, screenHeight, cameraWidth, cameraHeight );
//
//
//        bool isPortraitMode = (screenWidth < screenHeight);
//        float videoWidth, videoHeight;
//        videoWidth = (float)cameraWidth;
//        videoHeight = (float)cameraHeight;
//        if (isPortraitMode)
//        {
//            // the width and height of the camera are always
//            // based on a landscape orientation
//            // videoWidth = (float)cameraHeight;
//            // videoHeight = (float)cameraWidth;
//
//
//            // as the camera coordinates are always in landscape
//            // we convert the inputs into a landscape based coordinate system
//            int tmp = screenX;
//            screenX = screenY;
//            screenY = screenWidth - tmp;
//
//            tmp = screenDX;
//            screenDX = screenDY;
//            screenDY = tmp;
//
//            tmp = screenWidth;
//            screenWidth = screenHeight;
//            screenHeight = tmp;
//
//        }
//        else
//        {
//            videoWidth = (float)cameraWidth;
//            videoHeight = (float)cameraHeight;
//        }
//
//        float videoAspectRatio = videoHeight / videoWidth;
//        float screenAspectRatio = (float) screenHeight / (float) screenWidth;
//
//        float scaledUpX;
//        float scaledUpY;
//        float scaledUpVideoWidth;
//        float scaledUpVideoHeight;
//
//        if (videoAspectRatio < screenAspectRatio)
//        {
//            // the video height will fit in the screen height
//            scaledUpVideoWidth = (float)screenHeight / videoAspectRatio;
//            scaledUpVideoHeight = screenHeight;
//            scaledUpX = (float)screenX + ((scaledUpVideoWidth - (float)screenWidth) / 2.0f);
//            scaledUpY = (float)screenY;
//        }
//        else
//        {
//            // the video width will fit in the screen width
//            scaledUpVideoHeight = (float)screenWidth * videoAspectRatio;
//            scaledUpVideoWidth = screenWidth;
//            scaledUpY = (float)screenY + ((scaledUpVideoHeight - (float)screenHeight)/2.0f);
//            scaledUpX = (float)screenX;
//        }
//
//        if (cameraX)
//        {
//            *cameraX = (int)((scaledUpX / (float)scaledUpVideoWidth) * videoWidth);
//        }
//
//        if (cameraY)
//        {
//            *cameraY = (int)((scaledUpY / (float)scaledUpVideoHeight) * videoHeight);
//        }
//
//        if (cameraDX)
//        {
//            *cameraDX = (int)(((float)screenDX / (float)scaledUpVideoWidth) * videoWidth);
//        }
//
//        if (cameraDY)
//        {
//            *cameraDY = (int)(((float)screenDY / (float)scaledUpVideoHeight) * videoHeight);
//        }
//    }
//
//    Vuforia::Matrix44F
//    Matrix44FTranspose(const Vuforia::Matrix44F& m)
//    {
//        Vuforia::Matrix44F r;
//        for (int i = 0; i < 4; i++)
//            for (int j = 0; j < 4; j++)
//                r.data[i*4+j] = m.data[i+4*j];
//        return r;
//    }
}

