package br.com.lab360.bioprime.ui.activity.video360;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.view.TextureView;
import android.view.View;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

public class Video360Activity extends AppCompatActivity {

    @BindView(R.id.spherical_video_player)
    protected SphericalVideoPlayer videoPlayer;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video_360);
        ButterKnife.bind(this);

        videoPlayer.setVideoURIPath("https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/demo.m4v");

        videoPlayer.playWhenReady();
    }

    public static void toast(Context context, String msg) {
        /*Toast.makeText(
                context,
                msg,
                Toast.LENGTH_SHORT).show();*/
    }

    public static String readRawTextFile(Context context, int resId) {
        InputStream is = context.getResources().openRawResource(resId);
        InputStreamReader reader = new InputStreamReader(is);
        BufferedReader buf = new BufferedReader(reader);
        StringBuilder text = new StringBuilder();
        try {
            String line;
            while ((line = buf.readLine()) != null) {
                text.append(line).append('\n');
            }
        } catch (IOException e) {
            return null;
        }
        return text.toString();
    }

    private void init() {
        videoPlayer.setSurfaceTextureListener(new TextureView.SurfaceTextureListener() {
            @Override
            public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
                videoPlayer.initRenderThread(surface, width, height);
            }

            @Override
            public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
            }

            @Override
            public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
                videoPlayer.releaseResources();
                return false;
            }

            @Override
            public void onSurfaceTextureUpdated(SurfaceTexture surface) {
            }
        });
        videoPlayer.setVisibility(View.VISIBLE);
    }
}
