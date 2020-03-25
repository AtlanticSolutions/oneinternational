package br.com.lab360.bioprime.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Victor Santiago on 07/12/2016.
 */

public abstract class YoutubeUtils {

    public static String extractYoutubeVideoId(String ytUrl) {

        String vId = null;

        String pattern = "(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*";

        Pattern compiledPattern = Pattern.compile(pattern);
        Matcher matcher = compiledPattern.matcher(ytUrl);

        if(matcher.find()){
            vId= matcher.group();
        }
        return vId;
    }
}
