package br.com.lab360.oneinternacional.logic.adalive;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.opengl.GLES20;
import android.opengl.Matrix;
import android.opengl.GLSurfaceView.Renderer;
import android.os.SystemClock;
import android.util.DisplayMetrics;

import com.vuforia.ImageTarget;
import com.vuforia.Matrix44F;
import com.vuforia.State;
import com.vuforia.Tool;
import com.vuforia.TrackableResult;
import com.vuforia.Vec2F;
import com.vuforia.Vec3F;
import com.vuforia.Vuforia;
import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Iterator;
import java.util.Vector;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;
import lib.hardware.video.VideoPlayerHelper;
import lib.hardware.video.VideoPlayerHelper.MEDIA_STATE;
import lib.hardware.video.VideoPlayerHelper.MEDIA_TYPE;
import lib.hardware.video.utils.AdAliveMath;
import lib.hardware.video.utils.AdAliveVideoUtils;
import lib.utils.AdAliveTexture;

public class CloudRecoRenderer implements Renderer {
    private final AdAliveApplicationSession session;
    private static final float OBJECT_SCALE_FLOAT = 3.0F;
    private int shaderProgramID;
    private int vertexHandle;
    private int normalHandle;
    private int textureCoordHandle;
    private int mvpMatrixHandle;
    private int texSampler2DHandle;
    private Vector<AdAliveTexture> mAdAliveTextures;
    private final AdAliveCamera mAdAliveCamera;
    private int videoPlaybackShaderID = 0;
    private int videoPlaybackVertexHandle = 0;
    private int videoPlaybackTexCoordHandle = 0;
    private int videoPlaybackMVPMatrixHandle = 0;
    private int videoPlaybackTexSamplerOESHandle = 0;
    private int[] videoPlaybackTextureID = new int[1];
    private int keyframeShaderID = 0;
    private int keyframeVertexHandle = 0;
    private int keyframeTexCoordHandle = 0;
    private int keyframeMVPMatrixHandle = 0;
    private int keyframeTexSampler2DHandle = 0;
    private float[] videoQuadTextureCoords = new float[]{0.0F, 0.0F, 1.0F, 0.0F, 1.0F, 1.0F, 0.0F, 1.0F};
    private float[] videoQuadTextureCoordsTransformedStones = new float[]{0.0F, 0.0F, 1.0F, 0.0F, 1.0F, 1.0F, 0.0F, 1.0F};
    private Vec3F targetPositiveDimensions;
    static int NUM_QUAD_VERTEX = 4;
    private static int NUM_QUAD_INDEX = 6;
    private double[] quadVerticesArray = new double[]{-1.0D, -1.0D, 0.0D, 1.0D, -1.0D, 0.0D, 1.0D, 1.0D, 0.0D, -1.0D, 1.0D, 0.0D};
    private double[] quadTexCoordsArray = new double[]{0.0D, 0.0D, 1.0D, 0.0D, 1.0D, 1.0D, 0.0D, 1.0D};
    private double[] quadNormalsArray = new double[]{0.0D, 0.0D, 1.0D, 0.0D, 0.0D, 1.0D, 0.0D, 0.0D, 1.0D, 0.0D, 0.0D, 1.0D};
    private short[] quadIndicesArray = new short[]{0, 1, 2, 2, 3, 0};
    private Buffer quadVertices;
    private Buffer quadTexCoords;
    private Buffer quadIndices;
    private Buffer quadNormals;
    private boolean mIsActive = false;
    private float[] mTexCoordTransformationMatrix = null;
    private VideoPlayerHelper mVideoPlayerHelper = null;
    private String mMovieName = null;
    private MEDIA_TYPE mCanRequestType = null;
    private int mSeekPosition = 0;
    private boolean mShouldPlayImmediately;
    private long mLostTrackingSince;
    private boolean mLoadRequested;
    private Context context;
    private Matrix44F modelViewMatrix;
    private boolean isTracking = false;
    private MEDIA_STATE currentStatus;
    private float videoQuadAspectRatio = 0.0F;
    private float keyframeQuadAspectRatio = 0.0F;
    private boolean isVideoAR = false;
    private VIDEO_AR_STATE videoARState;
    private int videoARTranspPlaybackShaderID;
    private int videoARTranspPlaybackVertexHandle;
    private int videoARTranspPlaybackTexCoordHandle;
    private int videoARTranspPlaybackMVPMatrixHandle;
    private int videoARTranspPlaybackTexSamplerOESHandle;

    public CloudRecoRenderer(Context context, AdAliveApplicationSession session, AdAliveCamera mAdAliveCamera, VideoPlayerHelper mVideoPlayerHelper, int mSeekPosition) {
        this.videoARState = VIDEO_AR_STATE.NONE;
        this.videoARTranspPlaybackShaderID = 0;
        this.videoARTranspPlaybackVertexHandle = 0;
        this.videoARTranspPlaybackTexCoordHandle = 0;
        this.videoARTranspPlaybackMVPMatrixHandle = 0;
        this.videoARTranspPlaybackTexSamplerOESHandle = 0;
        this.context = context;
        this.session = session;
        this.mAdAliveCamera = mAdAliveCamera;
        this.mSeekPosition = mSeekPosition;
        this.mVideoPlayerHelper = mVideoPlayerHelper;
        this.mMovieName = "";
        this.mCanRequestType = MEDIA_TYPE.ON_TEXTURE_FULLSCREEN;
        this.mShouldPlayImmediately = true;
        this.mLostTrackingSince = -1L;
        this.mLoadRequested = true;
        this.mTexCoordTransformationMatrix = new float[16];
        this.targetPositiveDimensions = new Vec3F();
        this.modelViewMatrix = new Matrix44F();
    }

    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        this.videoARState = VIDEO_AR_STATE.NONE;
        this.initRendering();
        this.session.onSurfaceCreated();
        if (this.mVideoPlayerHelper != null) {
            if (!this.mVideoPlayerHelper.setupSurfaceTexture(this.videoPlaybackTextureID[0])) {
                this.mCanRequestType = MEDIA_TYPE.FULLSCREEN;
            } else {
                this.mCanRequestType = MEDIA_TYPE.ON_TEXTURE_FULLSCREEN;
            }

            this.mLoadRequested = false;
        }

    }

    public void onSurfaceChanged(GL10 gl, int width, int height) {
        this.session.onSurfaceChanged(width, height);
        if (this.mLoadRequested && this.mVideoPlayerHelper != null) {
            this.mVideoPlayerHelper.load(this.mMovieName, this.mCanRequestType, this.mShouldPlayImmediately, this.mSeekPosition);
            this.mLoadRequested = false;
        }

    }

    public void onDrawFrame(GL10 gl) {
        if (!this.isVideoAR) {
            this.renderFrame();
        } else {
            if (!this.mIsActive) {
                return;
            }

            switch(this.videoARState) {
                case NONE:
                case SCANNING:
                case TARGET_FOUND:
                case WAITING_LINK:
                default:
                    break;
                case LINK_FOUND:
                    this.mVideoPlayerHelper.stop();
                    this.mVideoPlayerHelper.unload();
                    if (this.mMovieName != null && !this.mMovieName.equals("") && this.mVideoPlayerHelper != null) {
                        this.videoARState = VIDEO_AR_STATE.VIDEO_READY;
                        this.mVideoPlayerHelper.load(this.mMovieName, this.mCanRequestType, this.mShouldPlayImmediately, this.mSeekPosition);
                        break;
                    }

                    this.videoARState = VIDEO_AR_STATE.WAITING_LINK;
                    break;
                case VIDEO_READY:
                    if (this.mVideoPlayerHelper != null && this.mVideoPlayerHelper.isPlayableOnTexture() && this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.PLAYING) {
                        this.mVideoPlayerHelper.updateVideoData();
                    }

                    if (this.isTracking) {
                        this.mLostTrackingSince = -1L;
                    } else if (this.mLostTrackingSince < 0L) {
                        this.mLostTrackingSince = SystemClock.uptimeMillis();
                    } else if (SystemClock.uptimeMillis() - this.mLostTrackingSince > 2000L && this.mVideoPlayerHelper != null) {
                        this.mVideoPlayerHelper.pause();
                        this.videoARState = VIDEO_AR_STATE.SCANNING;
                    }
            }

            if (this.mVideoPlayerHelper != null) {
                this.mVideoPlayerHelper.getSurfaceTextureTransformMatrix(this.mTexCoordTransformationMatrix);
                this.setVideoDimensions((float)this.mVideoPlayerHelper.getVideoWidth(), (float)this.mVideoPlayerHelper.getVideoHeight(), this.mTexCoordTransformationMatrix);
                this.setStatus(this.mVideoPlayerHelper.getStatus().getNumericType());
                this.renderFrameWithVideoAR();
            }
        }

    }

    public void playVideoPlayback() {
        this.videoARState = VIDEO_AR_STATE.LINK_FOUND;
    }

    public void lostTargetUpdateStatus() {
        if (this.mVideoPlayerHelper != null && (this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.PLAYING || this.isVideoAR && this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.NOT_READY)) {
            this.mVideoPlayerHelper.pause();
            this.mVideoPlayerHelper.stop();
            this.mVideoPlayerHelper.unload();
        }

        this.setVideoAR(false);
        this.setUrlVideoAR("");
        this.videoARState = VIDEO_AR_STATE.WAITING_LINK;
    }

    private void initRendering() {
        GLES20.glClearColor(0.0F, 0.0F, 0.0F, Vuforia.requiresAlpha() ? 0.0F : 1.0F);
        Iterator var1 = this.mAdAliveTextures.iterator();

        while(var1.hasNext()) {
            AdAliveTexture t = (AdAliveTexture)var1.next();
            GLES20.glGenTextures(1, t.mTextureID, 0);
            GLES20.glBindTexture(3553, t.mTextureID[0]);
            GLES20.glTexParameterf(3553, 10241, 9729.0F);
            GLES20.glTexParameterf(3553, 10240, 9729.0F);
            GLES20.glTexParameterf(3553, 10242, 33071.0F);
            GLES20.glTexParameterf(3553, 10243, 33071.0F);
            GLES20.glTexImage2D(3553, 0, 6408, t.mWidth, t.mHeight, 0, 6408, 5121, t.mData);
        }

        GLES20.glGenTextures(1, this.videoPlaybackTextureID, 0);
        GLES20.glBindTexture(36197, this.videoPlaybackTextureID[0]);
        GLES20.glTexParameterf(36197, 10241, 9729.0F);
        GLES20.glTexParameterf(36197, 10240, 9729.0F);
        GLES20.glBindTexture(36197, 0);
        this.videoPlaybackShaderID = AdAliveVideoUtils.createProgramFromShaderSrc(" \nattribute vec4 vertexPosition; \nattribute vec2 vertexTexCoord; \nvarying vec2 texCoord; \nuniform mat4 modelViewProjectionMatrix; \n\nvoid main() \n{ \n   gl_Position = modelViewProjectionMatrix * vertexPosition; \n   texCoord = vertexTexCoord; \n} \n", " \n#extension GL_OES_EGL_image_external : require \nprecision mediump float; \nvarying vec2 texCoord; \nuniform samplerExternalOES texSamplerOES; \n \nvoid main() \n{ \n   gl_FragColor = texture2D(texSamplerOES, texCoord); \n} \n");

        this.videoPlaybackVertexHandle = GLES20.glGetAttribLocation(this.videoPlaybackShaderID, "vertexPosition");
        this.videoPlaybackTexCoordHandle = GLES20.glGetAttribLocation(this.videoPlaybackShaderID, "vertexTexCoord");
        this.videoPlaybackMVPMatrixHandle = GLES20.glGetUniformLocation(this.videoPlaybackShaderID, "modelViewProjectionMatrix");
        this.videoPlaybackTexSamplerOESHandle = GLES20.glGetUniformLocation(this.videoPlaybackShaderID, "texSamplerOES");
        this.initShadersVideoARTransp();
        this.keyframeShaderID = AdAliveVideoUtils.createProgramFromShaderSrc(" \nattribute vec4 vertexPosition; \nattribute vec2 vertexTexCoord; \nvarying vec2 texCoord; \nuniform mat4 modelViewProjectionMatrix; \n\nvoid main() \n{ \n   gl_Position = modelViewProjectionMatrix * vertexPosition; \n   texCoord = vertexTexCoord; \n} \n", " \n\nprecision mediump float; \nvarying vec2 texCoord; \nuniform sampler2D texSampler2D; \n \nvoid main() \n{ \n   gl_FragColor = texture2D(texSampler2D, texCoord); \n} \n");
        this.keyframeVertexHandle = GLES20.glGetAttribLocation(this.keyframeShaderID, "vertexPosition");
        this.keyframeTexCoordHandle = GLES20.glGetAttribLocation(this.keyframeShaderID, "vertexTexCoord");
        this.keyframeMVPMatrixHandle = GLES20.glGetUniformLocation(this.keyframeShaderID, "modelViewProjectionMatrix");
        this.keyframeTexSampler2DHandle = GLES20.glGetUniformLocation(this.keyframeShaderID, "texSampler2D");
        this.keyframeQuadAspectRatio = (float)((AdAliveTexture)this.mAdAliveTextures.get(0)).mHeight / (float)((AdAliveTexture)this.mAdAliveTextures.get(0)).mWidth;
        this.quadVertices = this.fillBuffer(this.quadVerticesArray);
        this.quadTexCoords = this.fillBuffer(this.quadTexCoordsArray);
        this.quadIndices = this.fillBuffer(this.quadIndicesArray);
        this.quadNormals = this.fillBuffer(this.quadNormalsArray);
        this.videoARState = VIDEO_AR_STATE.SCANNING;
    }

    private void initShadersVideoARTransp() {
        this.videoARTranspPlaybackShaderID = AdAliveVideoUtils.createProgramFromShaderSrc(" \nattribute vec4 vertexPosition; \nattribute vec2 vertexTexCoord; \nuniform mat4 modelViewProjectionMatrix; \nvarying vec2 normalTexCoord; \nvarying vec2 transparentTexCoord; \n\nvoid main() \n{ \n   gl_Position = modelViewProjectionMatrix * vertexPosition; \n   normalTexCoord = vec2(vertexTexCoord.x,vertexTexCoord.y*0.5); \n   transparentTexCoord = vec2(vertexTexCoord.x,vertexTexCoord.y*0.5 + 0.5); \n} \n", " \n#extension GL_OES_EGL_image_external : require \nprecision mediump float; \nuniform samplerExternalOES texSamplerOES; \n \nvarying vec2 normalTexCoord; \nvarying vec2 transparentTexCoord; \nvoid main() \n{ \n    vec4 pixel = texture2D(texSamplerOES, normalTexCoord); \n    vec4 alpha = texture2D(texSamplerOES, transparentTexCoord); \n    gl_FragColor = vec4(pixel.rgb, alpha.r); \n} \n");
        this.videoARTranspPlaybackVertexHandle = GLES20.glGetAttribLocation(this.videoARTranspPlaybackShaderID, "vertexPosition");
        this.videoARTranspPlaybackTexCoordHandle = GLES20.glGetAttribLocation(this.videoARTranspPlaybackShaderID, "vertexTexCoord");
        this.videoARTranspPlaybackMVPMatrixHandle = GLES20.glGetUniformLocation(this.videoARTranspPlaybackShaderID, "modelViewProjectionMatrix");
        this.videoARTranspPlaybackTexSamplerOESHandle = GLES20.glGetUniformLocation(this.videoARTranspPlaybackShaderID, "texSamplerOES");
    }

    private void renderFrame() {
        GLES20.glClear(16640);
        State state = com.vuforia.Renderer.getInstance().begin();
        com.vuforia.Renderer.getInstance().drawVideoBackground();
        GLES20.glEnable(2929);
        GLES20.glEnable(2884);
        if (com.vuforia.Renderer.getInstance().getVideoBackgroundConfig().getReflection() == 1) {
            GLES20.glFrontFace(2304);
        } else {
            GLES20.glFrontFace(2305);
        }

        if (state.getNumTrackableResults() > 0) {
            TrackableResult trackableResult = state.getTrackableResult(0);
            if (trackableResult == null) {
                return;
            }

            this.mAdAliveCamera.stopFinderIfStarted();
        } else {
            this.mAdAliveCamera.startFinderIfStopped();
        }

        GLES20.glDisable(2929);
        com.vuforia.Renderer.getInstance().end();
    }

    private void renderFrameWithVideoAR() {
        GLES20.glClear(16640);
        State state = com.vuforia.Renderer.getInstance().begin();
        com.vuforia.Renderer.getInstance().drawVideoBackground();
        GLES20.glEnable(2929);
        int[] viewport = this.session.getViewport();
        GLES20.glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
        GLES20.glEnable(2884);
        GLES20.glCullFace(1029);
        if (com.vuforia.Renderer.getInstance().getVideoBackgroundConfig().getReflection() == 1) {
            GLES20.glFrontFace(2304);
        } else {
            GLES20.glFrontFace(2305);
        }

        float[] temp = new float[]{0.0F, 0.0F, 0.0F};
        this.isTracking = false;
        this.targetPositiveDimensions.setData(temp);
        if (state.getNumTrackableResults() > 0) {
            TrackableResult trackableResult = state.getTrackableResult(0);
            ImageTarget imageTarget = (ImageTarget)trackableResult.getTrackable();
            trackableResult.getTrackable().getName();
            this.modelViewMatrix = Tool.convertPose2GLMatrix(trackableResult.getPose());
            this.isTracking = true;
            this.targetPositiveDimensions = imageTarget.getSize();
            temp[0] = this.targetPositiveDimensions.getData()[0] / 2.0F;
            temp[1] = this.targetPositiveDimensions.getData()[1] / 2.0F;
            this.targetPositiveDimensions.setData(temp);
            float[] modelViewMatrixButton;
            float[] modelViewProjectionButton;
            if (this.currentStatus != MEDIA_STATE.READY && this.currentStatus != MEDIA_STATE.REACHED_END && this.currentStatus != MEDIA_STATE.NOT_READY && this.currentStatus != MEDIA_STATE.ERROR) {
                if (this.mAdAliveCamera.isVideoARTransp()) {
                    modelViewMatrixButton = Tool.convertPose2GLMatrix(trackableResult.getPose()).getData();
                    modelViewProjectionButton = new float[16];
                    Matrix.scaleM(modelViewMatrixButton, 0, this.targetPositiveDimensions.getData()[0], this.targetPositiveDimensions.getData()[0] * this.videoQuadAspectRatio * 0.5F, this.targetPositiveDimensions.getData()[0]);
                    Matrix.multiplyMM(modelViewProjectionButton, 0, this.session.getProjectionMatrix().getData(), 0, modelViewMatrixButton, 0);
                    GLES20.glUseProgram(this.videoARTranspPlaybackShaderID);
                    GLES20.glEnable(3042);
                    GLES20.glVertexAttribPointer(this.videoARTranspPlaybackVertexHandle, 3, 5126, false, 0, this.quadVertices);
                    GLES20.glVertexAttribPointer(this.videoARTranspPlaybackTexCoordHandle, 2, 5126, false, 0, this.fillBuffer(this.videoQuadTextureCoordsTransformedStones));
                    GLES20.glEnableVertexAttribArray(this.videoARTranspPlaybackVertexHandle);
                    GLES20.glEnableVertexAttribArray(this.videoARTranspPlaybackTexCoordHandle);
                    GLES20.glActiveTexture(33984);
                    GLES20.glBindTexture(36197, this.videoPlaybackTextureID[0]);
                    GLES20.glUniformMatrix4fv(this.videoARTranspPlaybackMVPMatrixHandle, 1, false, modelViewProjectionButton, 0);
                    GLES20.glUniform1i(this.videoARTranspPlaybackTexSamplerOESHandle, 0);
                    GLES20.glDrawElements(4, NUM_QUAD_INDEX, 5123, this.quadIndices);
                    GLES20.glDisableVertexAttribArray(this.videoARTranspPlaybackVertexHandle);
                    GLES20.glDisableVertexAttribArray(this.videoARTranspPlaybackTexCoordHandle);
                    GLES20.glDisable(3042);
                    GLES20.glUseProgram(0);
                } else {
                    modelViewMatrixButton = Tool.convertPose2GLMatrix(trackableResult.getPose()).getData();
                    modelViewProjectionButton = new float[16];
                    Matrix.scaleM(modelViewMatrixButton, 0, this.targetPositiveDimensions.getData()[0], this.targetPositiveDimensions.getData()[0] * this.videoQuadAspectRatio, this.targetPositiveDimensions.getData()[0]);
                    Matrix.multiplyMM(modelViewProjectionButton, 0, this.session.getProjectionMatrix().getData(), 0, modelViewMatrixButton, 0);
                    GLES20.glUseProgram(this.videoPlaybackShaderID);
                    GLES20.glVertexAttribPointer(this.videoPlaybackVertexHandle, 3, 5126, false, 0, this.quadVertices);
                    GLES20.glVertexAttribPointer(this.videoPlaybackTexCoordHandle, 2, 5126, false, 0, this.fillBuffer(this.videoQuadTextureCoordsTransformedStones));
                    GLES20.glEnableVertexAttribArray(this.videoPlaybackVertexHandle);
                    GLES20.glEnableVertexAttribArray(this.videoPlaybackTexCoordHandle);
                    GLES20.glActiveTexture(33984);
                    GLES20.glBindTexture(36197, this.videoPlaybackTextureID[0]);
                    GLES20.glUniformMatrix4fv(this.videoPlaybackMVPMatrixHandle, 1, false, modelViewProjectionButton, 0);
                    GLES20.glUniform1i(this.videoPlaybackTexSamplerOESHandle, 0);
                    GLES20.glDrawElements(4, NUM_QUAD_INDEX, 5123, this.quadIndices);
                    GLES20.glDisableVertexAttribArray(this.videoPlaybackVertexHandle);
                    GLES20.glDisableVertexAttribArray(this.videoPlaybackTexCoordHandle);
                    GLES20.glUseProgram(0);
                }
            } else {
                modelViewMatrixButton = Tool.convertPose2GLMatrix(trackableResult.getPose()).getData();
                modelViewProjectionButton = new float[16];
                float ratio = 1.0F;
                if (((AdAliveTexture)this.mAdAliveTextures.get(0)).mSuccess) {
                    ratio = this.keyframeQuadAspectRatio;
                } else {
                    ratio = this.targetPositiveDimensions.getData()[1] / this.targetPositiveDimensions.getData()[0];
                }

                Matrix.scaleM(modelViewMatrixButton, 0, this.targetPositiveDimensions.getData()[0], this.targetPositiveDimensions.getData()[0] * ratio, this.targetPositiveDimensions.getData()[0]);
                Matrix.multiplyMM(modelViewProjectionButton, 0, this.session.getProjectionMatrix().getData(), 0, modelViewMatrixButton, 0);
                GLES20.glUseProgram(this.keyframeShaderID);
                GLES20.glVertexAttribPointer(this.keyframeVertexHandle, 3, 5126, false, 0, this.quadVertices);
                GLES20.glVertexAttribPointer(this.keyframeTexCoordHandle, 2, 5126, false, 0, this.quadTexCoords);
                GLES20.glEnableVertexAttribArray(this.keyframeVertexHandle);
                GLES20.glEnableVertexAttribArray(this.keyframeTexCoordHandle);
                GLES20.glActiveTexture(33984);
                GLES20.glBindTexture(3553, ((AdAliveTexture)this.mAdAliveTextures.get(0)).mTextureID[0]);
                GLES20.glUniformMatrix4fv(this.keyframeMVPMatrixHandle, 1, false, modelViewProjectionButton, 0);
                GLES20.glUniform1i(this.keyframeTexSampler2DHandle, 0);
                GLES20.glDrawElements(4, NUM_QUAD_INDEX, 5123, this.quadIndices);
                GLES20.glDisableVertexAttribArray(this.keyframeVertexHandle);
                GLES20.glDisableVertexAttribArray(this.keyframeTexCoordHandle);
                GLES20.glUseProgram(0);
            }

            if (this.currentStatus == MEDIA_STATE.READY || this.currentStatus == MEDIA_STATE.REACHED_END || this.currentStatus == MEDIA_STATE.PAUSED || this.currentStatus == MEDIA_STATE.NOT_READY || this.currentStatus == MEDIA_STATE.ERROR) {
                modelViewMatrixButton = Tool.convertPose2GLMatrix(trackableResult.getPose()).getData();
                modelViewProjectionButton = new float[16];
                GLES20.glDepthFunc(515);
                GLES20.glEnable(3042);
                GLES20.glBlendFunc(770, 771);
                Matrix.translateM(modelViewMatrixButton, 0, 0.0F, 0.0F, this.targetPositiveDimensions.getData()[1] / 10.98F);
                Matrix.scaleM(modelViewMatrixButton, 0, this.targetPositiveDimensions.getData()[1] / 2.0F, this.targetPositiveDimensions.getData()[1] / 2.0F, this.targetPositiveDimensions.getData()[1] / 2.0F);
                Matrix.multiplyMM(modelViewProjectionButton, 0, this.session.getProjectionMatrix().getData(), 0, modelViewMatrixButton, 0);
                GLES20.glUseProgram(this.keyframeShaderID);
                GLES20.glVertexAttribPointer(this.keyframeVertexHandle, 3, 5126, false, 0, this.quadVertices);
                GLES20.glVertexAttribPointer(this.keyframeTexCoordHandle, 2, 5126, false, 0, this.quadTexCoords);
                GLES20.glEnableVertexAttribArray(this.keyframeVertexHandle);
                GLES20.glEnableVertexAttribArray(this.keyframeTexCoordHandle);
                GLES20.glActiveTexture(33984);
                switch(this.currentStatus) {
                    case READY:
                    case PAUSED:
                        break;
                    case REACHED_END:
                        this.setVideoAR(false);
                        this.mAdAliveCamera.stopVideoAR();
                        if (this.mAdAliveCamera.getVideoReachedEndListener() != null) {
                            this.mAdAliveCamera.getVideoReachedEndListener().onVideoReachedEndListener(true);
                        }
                        break;
                    case NOT_READY:
                        GLES20.glBindTexture(3553, ((AdAliveTexture)this.mAdAliveTextures.get(1)).mTextureID[0]);
                        break;
                    case ERROR:
                        GLES20.glBindTexture(3553, ((AdAliveTexture)this.mAdAliveTextures.get(2)).mTextureID[0]);
                        break;
                    default:
                        GLES20.glBindTexture(3553, ((AdAliveTexture)this.mAdAliveTextures.get(1)).mTextureID[0]);
                }

                GLES20.glUniformMatrix4fv(this.keyframeMVPMatrixHandle, 1, false, modelViewProjectionButton, 0);
                GLES20.glUniform1i(this.keyframeTexSampler2DHandle, 0);
                GLES20.glDrawElements(4, NUM_QUAD_INDEX, 5123, this.quadIndices);
                GLES20.glDisableVertexAttribArray(this.keyframeVertexHandle);
                GLES20.glDisableVertexAttribArray(this.keyframeTexCoordHandle);
                GLES20.glUseProgram(0);
                GLES20.glDepthFunc(513);
                GLES20.glDisable(3042);
            }

            AdAliveVideoUtils.checkGLError("VideoPlayback renderFrame");
        } else {
            this.resetVideoPlayer();
            this.mAdAliveCamera.stopVideoAR();
        }

        GLES20.glDisable(2929);
        com.vuforia.Renderer.getInstance().end();
    }

    private void resetVideoPlayer() {
        this.mVideoPlayerHelper.deinit();
        this.mVideoPlayerHelper = null;
        this.mVideoPlayerHelper = new VideoPlayerHelper();
        this.mVideoPlayerHelper.init();
        this.mVideoPlayerHelper.setActivity((Activity)this.context);
        this.videoPlaybackShaderID = 0;
        this.videoPlaybackVertexHandle = 0;
        this.videoPlaybackTexCoordHandle = 0;
        this.videoPlaybackMVPMatrixHandle = 0;
        this.videoPlaybackTexSamplerOESHandle = 0;
        this.videoARTranspPlaybackShaderID = 0;
        this.videoARTranspPlaybackVertexHandle = 0;
        this.videoARTranspPlaybackTexCoordHandle = 0;
        this.videoARTranspPlaybackMVPMatrixHandle = 0;
        this.videoARTranspPlaybackTexSamplerOESHandle = 0;
        this.mSeekPosition = 0;
        this.isTracking = true;
        this.mCanRequestType = MEDIA_TYPE.ON_TEXTURE_FULLSCREEN;
        this.mShouldPlayImmediately = true;
        this.mLostTrackingSince = -1L;
        this.mLoadRequested = true;
        this.mTexCoordTransformationMatrix = new float[16];
        this.targetPositiveDimensions = new Vec3F();
        this.modelViewMatrix = new Matrix44F();
        this.videoPlaybackTextureID = new int[1];
        this.initRendering();
        this.initShadersVideoARTransp();
        if (!this.mVideoPlayerHelper.setupSurfaceTexture(this.videoPlaybackTextureID[0])) {
            this.mCanRequestType = MEDIA_TYPE.FULLSCREEN;
        } else {
            this.mCanRequestType = MEDIA_TYPE.ON_TEXTURE_FULLSCREEN;
        }

    }

    public void setTextures(Vector<AdAliveTexture> adAliveTextures) {
        this.mAdAliveTextures = adAliveTextures;
    }

    public void requestLoad(String movieName, int seekPosition, boolean playImmediately) {
        this.mMovieName = movieName;
        this.mSeekPosition = seekPosition;
        this.mShouldPlayImmediately = playImmediately;
        this.mLoadRequested = true;
    }

    private Buffer fillBuffer(double[] array) {
        ByteBuffer bb = ByteBuffer.allocateDirect(4 * array.length);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        double[] var3 = array;
        int var4 = array.length;

        for(int var5 = 0; var5 < var4; ++var5) {
            double d = var3[var5];
            bb.putFloat((float)d);
        }

        bb.rewind();
        return bb;
    }

    private Buffer fillBuffer(short[] array) {
        ByteBuffer bb = ByteBuffer.allocateDirect(2 * array.length);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        short[] var3 = array;
        int var4 = array.length;

        for(int var5 = 0; var5 < var4; ++var5) {
            short s = var3[var5];
            bb.putShort(s);
        }

        bb.rewind();
        return bb;
    }

    private Buffer fillBuffer(float[] array) {
        ByteBuffer bb = ByteBuffer.allocateDirect(4 * array.length);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        float[] var3 = array;
        int var4 = array.length;

        for(int var5 = 0; var5 < var4; ++var5) {
            float d = var3[var5];
            bb.putFloat(d);
        }

        bb.rewind();
        return bb;
    }

    public boolean isTapOnScreenInsideTarget(float x, float y) {
        DisplayMetrics metrics = new DisplayMetrics();
        ((Activity)this.context).getWindowManager().getDefaultDisplay().getMetrics(metrics);
        Vec3F intersection = AdAliveMath.getPointToPlaneIntersection(AdAliveMath.Matrix44FInverse(this.session.getProjectionMatrix()), this.modelViewMatrix, (float)metrics.widthPixels, (float)metrics.heightPixels, new Vec2F(x, y), new Vec3F(0.0F, 0.0F, 0.0F), new Vec3F(0.0F, 0.0F, 1.0F));
        return intersection.getData()[0] >= -this.targetPositiveDimensions.getData()[0] && intersection.getData()[0] <= this.targetPositiveDimensions.getData()[0] && intersection.getData()[1] >= -this.targetPositiveDimensions.getData()[1] && intersection.getData()[1] <= this.targetPositiveDimensions.getData()[1];
    }

    void setVideoDimensions(float videoWidth, float videoHeight, float[] textureCoordMatrix) {
        this.videoQuadAspectRatio = videoHeight / videoWidth;
        float[] tempUVMultRes = new float[2];
        tempUVMultRes = this.uvMultMat4f(this.videoQuadTextureCoordsTransformedStones[0], this.videoQuadTextureCoordsTransformedStones[1], this.videoQuadTextureCoords[0], this.videoQuadTextureCoords[1], textureCoordMatrix);
        this.videoQuadTextureCoordsTransformedStones[0] = tempUVMultRes[0];
        this.videoQuadTextureCoordsTransformedStones[1] = tempUVMultRes[1];
        tempUVMultRes = this.uvMultMat4f(this.videoQuadTextureCoordsTransformedStones[2], this.videoQuadTextureCoordsTransformedStones[3], this.videoQuadTextureCoords[2], this.videoQuadTextureCoords[3], textureCoordMatrix);
        this.videoQuadTextureCoordsTransformedStones[2] = tempUVMultRes[0];
        this.videoQuadTextureCoordsTransformedStones[3] = tempUVMultRes[1];
        tempUVMultRes = this.uvMultMat4f(this.videoQuadTextureCoordsTransformedStones[4], this.videoQuadTextureCoordsTransformedStones[5], this.videoQuadTextureCoords[4], this.videoQuadTextureCoords[5], textureCoordMatrix);
        this.videoQuadTextureCoordsTransformedStones[4] = tempUVMultRes[0];
        this.videoQuadTextureCoordsTransformedStones[5] = tempUVMultRes[1];
        tempUVMultRes = this.uvMultMat4f(this.videoQuadTextureCoordsTransformedStones[6], this.videoQuadTextureCoordsTransformedStones[7], this.videoQuadTextureCoords[6], this.videoQuadTextureCoords[7], textureCoordMatrix);
        this.videoQuadTextureCoordsTransformedStones[6] = tempUVMultRes[0];
        this.videoQuadTextureCoordsTransformedStones[7] = tempUVMultRes[1];
    }

    float[] uvMultMat4f(float transformedU, float transformedV, float u, float v, float[] pMat) {
        float x = pMat[0] * u + pMat[4] * v + pMat[12] * 1.0F;
        float y = pMat[1] * u + pMat[5] * v + pMat[13] * 1.0F;
        float[] result = new float[]{x, y};
        return result;
    }

    void setStatus(int value) {
        switch(value) {
            case 0:
                this.currentStatus = MEDIA_STATE.REACHED_END;
                break;
            case 1:
                this.currentStatus = MEDIA_STATE.PAUSED;
                break;
            case 2:
                this.currentStatus = MEDIA_STATE.STOPPED;
                break;
            case 3:
                this.currentStatus = MEDIA_STATE.PLAYING;
                break;
            case 4:
                this.currentStatus = MEDIA_STATE.READY;
                break;
            case 5:
                this.currentStatus = MEDIA_STATE.NOT_READY;
                break;
            case 6:
                this.currentStatus = MEDIA_STATE.ERROR;
                break;
            default:
                this.currentStatus = MEDIA_STATE.NOT_READY;
        }

    }

    public void resumeServiceVideoAR() {
        this.requestLoad(this.mMovieName, this.mSeekPosition, this.mShouldPlayImmediately);
    }

    public void pauseServiceVideoAR() {
        if (this.mVideoPlayerHelper != null) {
            if (this.mVideoPlayerHelper.isPlayableOnTexture()) {
                this.mSeekPosition = this.mVideoPlayerHelper.getCurrentPosition();
            }

            this.mVideoPlayerHelper.unload();
        }

    }

    public void stopServiceVideoAR() {
        if (this.mVideoPlayerHelper != null) {
            this.mVideoPlayerHelper.deinit();
            this.mVideoPlayerHelper = null;
            this.mAdAliveTextures.clear();
            this.mAdAliveTextures = null;
            this.pauseAll();
        }

    }

    public void resultVideoAR(String movieBeingPlayed, Intent data) {
        if (movieBeingPlayed.compareTo(this.mMovieName) == 0) {
            this.mSeekPosition = data.getIntExtra("currentSeekPosition", 0);
        }

    }

    private void pauseAll() {
        if (this.mVideoPlayerHelper != null && this.mVideoPlayerHelper.isPlayableOnTexture()) {
            this.mVideoPlayerHelper.pause();
        }

    }

    public void setmIsActive(boolean mIsActive) {
        this.mIsActive = mIsActive;
    }

    public void setVideoAR(boolean isVideoAR) {
        this.isVideoAR = isVideoAR;
    }

    public void setUrlVideoAR(String urlVideoAR) {
        this.mMovieName = urlVideoAR;
    }

    public void setVideoPlayerHelper(VideoPlayerHelper newVideoPlayerHelper) {
        this.mVideoPlayerHelper = newVideoPlayerHelper;
    }

    private static enum VIDEO_AR_STATE {
        NONE(0),
        SCANNING(1),
        TARGET_FOUND(2),
        WAITING_LINK(3),
        LINK_FOUND(4),
        VIDEO_READY(5);

        private int type;

        private VIDEO_AR_STATE(int i) {
            this.type = i;
        }

        public int getNumericType() {
            return this.type;
        }
    }
}

