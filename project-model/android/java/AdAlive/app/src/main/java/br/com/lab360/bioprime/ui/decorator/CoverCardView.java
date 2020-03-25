package br.com.lab360.bioprime.ui.decorator;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

import br.com.lab360.bioprime.R;

public class CoverCardView extends View {

    private final static String TAG = CoverCardView.class.getSimpleName();
    private final static float DEFAULT_ERASER_SIZE = 60f;
    private final static int DEFAULT_MASKER_COLOR = 0xffcccccc;
    private final static int DEFAULT_PERCENT = 70;
    private final static int MAX_PERCENT = 100;
    private Paint mMaskPaint;
    private Bitmap mMaskBitmap;
    private Canvas mMaskCanvas;
    private Paint mBitmapPaint;
    private BitmapDrawable mWatermark;
    private Paint mErasePaint;
    private static Path mErasePath;
    private float mStartX;
    private float mStartY;
    private int mTouchSlop;
    private boolean mIsCompleted = false;
    private int mMaxPercent = DEFAULT_PERCENT;
    private int mPercent = 0;
    private int mPixels[];


    public static int prizeWidth;
    public static int prizeHeight;

    public static int viewX1;
    public static int viewY1;

    public static int viewX2;
    public static int viewY2;

    public static int totalErased;
    int percent = 0;

    private EraseStatusListener mEraseStatusListener;

    public CoverCardView(Context context) {
        super(context);
        TypedArray typedArray = context.obtainStyledAttributes(R.styleable.ScratchView);
        init(typedArray);
    }

    public CoverCardView(Context context, AttributeSet attrs) {
        super(context, attrs);
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.ScratchView);
        init(typedArray);
    }

    public CoverCardView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.ScratchView, defStyleAttr, 0);
        init(typedArray);
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public CoverCardView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.ScratchView, defStyleAttr, defStyleRes);
        init(typedArray);
    }

    private void init(TypedArray typedArray) {
        int maskColor = typedArray.getColor(R.styleable.ScratchView_msk, DEFAULT_MASKER_COLOR);
        int watermarkResId = typedArray.getResourceId(R.styleable.ScratchView_watermark, -1);
        float eraseSize = typedArray.getFloat(R.styleable.ScratchView_eraseSize, DEFAULT_ERASER_SIZE);
        mMaxPercent = typedArray.getInt(R.styleable.ScratchView_maxPercent, DEFAULT_PERCENT);
        typedArray.recycle();

        mMaskPaint = new Paint();
        mMaskPaint.setAntiAlias(true);//抗锯齿
        mMaskPaint.setDither(true);//防抖
        // setMaskColor(maskColor);

        mBitmapPaint = new Paint();
        mBitmapPaint.setAntiAlias(true);
        mBitmapPaint.setDither(true);

        //setWatermark(watermarkResId);

        mErasePaint = new Paint();
        mErasePaint.setAntiAlias(true);
        mErasePaint.setDither(true);
        mErasePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
        mErasePaint.setStyle(Paint.Style.STROKE);
        mErasePaint.setStrokeCap(Paint.Cap.ROUND);
        setEraserSize(eraseSize);
        setTotalErased(0);
        mErasePath = new Path();

        ViewConfiguration viewConfiguration = ViewConfiguration.get(getContext());
        mTouchSlop = viewConfiguration.getScaledTouchSlop();

    }

    public void setEraserSize(float eraserSize) {
        mErasePaint.setStrokeWidth(eraserSize);
    }

    public void setMaskColor(int color) {
        mMaskPaint.setColor(color);
    }

    public void setMaxPercent(int max) {
        if (max > 100 || max <= 0) {
            return;
        }
        this.mMaxPercent = max;
    }


    public static int getTotalErased() {
        return totalErased;
    }

    public static void setTotalErased(int totalErased) {
        CoverCardView.totalErased = totalErased;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        int measuredWidth = measureSize(widthMeasureSpec);
        int measuredHeight = measureSize(heightMeasureSpec);
        setMeasuredDimension(measuredWidth, measuredHeight);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawBitmap(mMaskBitmap, 0, 0, mBitmapPaint);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {

        int action = event.getAction();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                startErase(event.getX(), event.getY());
                invalidate();
                return true;
            case MotionEvent.ACTION_MOVE:
                erase(event.getX(), event.getY());
                invalidate();
                return true;
            case MotionEvent.ACTION_UP:
                stopErase();
                invalidate();
                return true;
            default:
                break;
        }
        return super.onTouchEvent(event);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        createMasker(w, h);
    }

    private void createMasker(int width, int height) {
        mMaskBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        mMaskCanvas = new Canvas(mMaskBitmap);
        Rect rect = new Rect(0, 0, width, height);
        mMaskCanvas.drawRect(rect, mMaskPaint);

        if (mWatermark != null) {
            Rect bounds = new Rect(rect);
            mWatermark.setBounds(bounds);
            mWatermark.draw(mMaskCanvas);
        }

        mPixels = new int[width * height];
    }

    private int measureSize(int measureSpec) {
        int size = 0;
        int specMode = MeasureSpec.getMode(measureSpec);
        int specSize = MeasureSpec.getSize(measureSpec);
        if (specMode == MeasureSpec.EXACTLY) {
            size = specSize;
        } else {
            if (specMode == MeasureSpec.AT_MOST) {
                size = Math.min(size, specSize);
            }
        }
        return size;
    }

    public void startErase(float x, float y) {
        mErasePath.reset();
        mErasePath.moveTo(x, y);
        this.mStartX = x;
        this.mStartY = y;
    }

    public void erase(float x, float y) {
        int dx = (int) Math.abs(x - mStartX);
        int dy = (int) Math.abs(y - mStartY);
        if (dx >= mTouchSlop || dy >= mTouchSlop) {
            this.mStartX = x;
            this.mStartY = y;

            mErasePath.lineTo(x, y);
            mMaskCanvas.drawPath(mErasePath, mErasePaint);

            updateErasePercent();


            mErasePath.reset();
            mErasePath.moveTo(mStartX, mStartY);
        }
    }

    @SuppressLint("StaticFieldLeak")
    private void updateErasePercent() {
        int width = prizeWidth;
        int height = prizeHeight;
        new AsyncTask<Integer, Integer, Boolean>() {

            @Override
            protected Boolean doInBackground(Integer... params) {
                int width = params[0];
                int height = params[1];


                try {
                    mMaskBitmap.getPixels(mPixels, 0, width, viewX1, viewY1, width, height);
                }catch (IllegalArgumentException i){
                    mMaskBitmap.getPixels(mPixels, 0, width, 0, 0, width, height);
                }


                float erasePixelCount = 0;
                float totalPixelCount = width * height;

                for (int pos = 0; pos < totalPixelCount; pos++) {
                    if (mPixels[pos] == 0) {
                        erasePixelCount++;
                    }
                }

                if (erasePixelCount >= 0 && totalPixelCount > 0) {
                    percent = Math.round(erasePixelCount * 100 / totalPixelCount);
                    publishProgress(percent);
                    Log.e("TOTALERASE", String.valueOf(percent));
                }

                setTotalErased(percent);
                return percent >= mMaxPercent;
            }

            @Override
            protected void onProgressUpdate(Integer... values) {
                super.onProgressUpdate(values);
                mPercent = values[0];
                onPercentUpdate();
            }

            @Override
            protected void onPostExecute(Boolean result) {
                super.onPostExecute(result);
                if (result && !mIsCompleted) {
                    mIsCompleted = true;
                    if (mEraseStatusListener != null) {
                        mEraseStatusListener.onCompleted(CoverCardView.this);
                    }
                }
            }

        }.execute(width, height);
    }

    public void stopErase() {
        this.mStartX = 0;
        this.mStartY = 0;
        mErasePath.reset();
        //updateErasePercent();
    }

    private void onPercentUpdate() {
        if (mEraseStatusListener != null) {
            mEraseStatusListener.onProgress(mPercent);
        }
    }

    public void setEraseStatusListener(EraseStatusListener listener) {
        this.mEraseStatusListener = listener;
    }


    public void setWatermark(Bitmap bmp) {
        mWatermark = new BitmapDrawable(bmp);
    }

    public void reset() {
        mIsCompleted = false;

        int width = getWidth();
        int height = getHeight();
        createMasker(width, height);
        invalidate();

        updateErasePercent();
    }

    public void clear() {
        int width = getWidth();
        int height = getHeight();
        mMaskBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        mMaskCanvas = new Canvas(mMaskBitmap);
        Rect rect = new Rect(0, 0, width, height);
        mMaskCanvas.drawRect(rect, mErasePaint);
        invalidate();

        updateErasePercent();
    }

    public static interface EraseStatusListener {

        public void onProgress(int percent);
        public void onCompleted(View view);
    }
}