package br.com.lab360.bioprime.ui.activity.newvideo;


import android.net.Uri;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.widget.MediaController;
import android.widget.VideoView;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideoActivity extends AppCompatActivity
{

    @BindView(R.id.surfView)
    public VideoView videoView;

    private String videoUrl;
    private int currentPos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_media_player);
        ButterKnife.bind(this);

        videoUrl = getIntent().getStringExtra("videoUrl");
        currentPos = getIntent().getIntExtra("currentPos", 0);

        MediaController controller = new MediaController(this);
        videoView.setVideoURI(Uri.parse(videoUrl));
        videoView.setMediaController(controller);
        videoView.seekTo(currentPos);
        videoView.start();

    }

    @Override
    protected void onStop() {
        super.onStop();
        setResult(videoView.getCurrentPosition());
    }
}
