package br.com.lab360.oneinternacional.logic.model.pojo.showcase;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Edson on 08/05/2018.
 */

public class ShowCaseEyesPosition implements Parcelable {

    @SerializedName("left_eye_x")
    String leftEyeX;
    @SerializedName("left_eye_y")
    String leftEyeY;
    @SerializedName("right_eye_x")
    String rightEyeX;
    @SerializedName("right_eye_y")
    String rightEyeY;

    public String getLeftEyeX() {
        return leftEyeX;
    }

    public void setLeftEyeX(String leftEyeX) {
        this.leftEyeX = leftEyeX;
    }

    public String getLeftEyeY() {
        return leftEyeY;
    }

    public void setLeftEyeY(String leftEyeY) {
        this.leftEyeY = leftEyeY;
    }

    public String getRightEyeX() {
        return rightEyeX;
    }

    public void setRightEyeX(String rightEyeX) {
        this.rightEyeX = rightEyeX;
    }

    public String getRightEyeY() {
        return rightEyeY;
    }

    public void setRightEyeY(String rightEyeY) {
        this.rightEyeY = rightEyeY;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.leftEyeX);
        dest.writeString(this.leftEyeY);
        dest.writeString(this.rightEyeX);
        dest.writeString(this.rightEyeY);
    }

    public ShowCaseEyesPosition() {
    }

    protected ShowCaseEyesPosition(Parcel in) {
        this.leftEyeX = in.readString();
        this.leftEyeY = in.readString();
        this.rightEyeX = in.readString();
        this.rightEyeY = in.readString();
    }

    public static final Parcelable.Creator<ShowCaseEyesPosition> CREATOR = new Parcelable.Creator<ShowCaseEyesPosition>() {
        @Override
        public ShowCaseEyesPosition createFromParcel(Parcel source) {
            return new ShowCaseEyesPosition(source);
        }

        @Override
        public ShowCaseEyesPosition[] newArray(int size) {
            return new ShowCaseEyesPosition[size];
        }
    };
}
