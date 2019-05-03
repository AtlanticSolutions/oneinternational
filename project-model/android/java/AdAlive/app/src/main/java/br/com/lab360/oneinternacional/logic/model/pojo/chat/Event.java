package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.oneinternacional.application.AdaliveConstants;

/**
 * AHK Event.
 * Created by Victor Santiago on 10/08/2016.
 */
public class Event implements Parcelable {

    @SerializedName(AdaliveConstants.TAG_EVENT_ID)
    private int id;
    @SerializedName(AdaliveConstants.TAG_EVENT_TITLE)
    private String title;
    @SerializedName(AdaliveConstants.TAG_EVENT_TYPE)
    private String type;
    @SerializedName(AdaliveConstants.TAG_EVENT_PANELIST)
    private String panelist;
    @SerializedName(AdaliveConstants.TAG_EVENT_THEME)
    private String theme;
    @SerializedName(AdaliveConstants.TAG_EVENT_SYNOPS)
    private String synopsis;
    @SerializedName(AdaliveConstants.TAG_EVENT_DATA)
    private String date;
    @SerializedName(AdaliveConstants.TAG_EVENT_ADATA)
    private String aDate;
    @SerializedName(AdaliveConstants.TAG_EVENT_HOUR)
    private String hour;
    @SerializedName(AdaliveConstants.TAG_EVENT_AHOUR)
    private String aHour;
    @SerializedName(AdaliveConstants.TAG_EVENT_LOCATION)
    private String location;
    @SerializedName(AdaliveConstants.TAG_EVENT_VALUE)
    private String value;
    @SerializedName(AdaliveConstants.TAG_EVENT_VALUE_A)
    private String valueA;
    @SerializedName(AdaliveConstants.TAG_EVENT_VALUE_N)
    private String valueN;
    @SerializedName(AdaliveConstants.TAG_EVENT_LANGUAGE)
    private String language;
    @SerializedName(AdaliveConstants.TAG_EVENT_INCRI)
    private String inscription;
    @SerializedName(AdaliveConstants.TAG_EVENT_P_EMAIL)
    private String pEmail;
    @SerializedName(AdaliveConstants.TAG_EVENT_P_SITE)
    private String pSite;
    @SerializedName(AdaliveConstants.TAG_EVENT_P_PHONE)
    private String pPhone;
    @SerializedName(AdaliveConstants.TAG_EVENT_P_FAX)
    private String pFax;
    @SerializedName(AdaliveConstants.TAG_EVENT_OBS)
    private String obs;
    @SerializedName(AdaliveConstants.TAG_EVENT_LIMIT)
    private String limit;
    @SerializedName(AdaliveConstants.TAG_EVENT_DATE_A)
    private String dateA;
    @SerializedName(AdaliveConstants.TAG_EVENT_DATE_D)
    private String dateD;
    @SerializedName(AdaliveConstants.TAG_EVENT_PATRO)
    private List<String> patroc;
    @SerializedName(AdaliveConstants.TAG_EVENT_EX_ASS)
    private String exAss;
    @SerializedName(AdaliveConstants.TAG_EVENT_URL)
    private String url;

    private boolean isRegistered;

    public Event() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getPanelist() {
        return panelist;
    }

    public void setPanelist(String panelist) {
        this.panelist = panelist;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getSynopsis() {
        return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getaDate() {
        return aDate;
    }

    public void setaDate(String aDate) {
        this.aDate = aDate;
    }

    public String getHour() {
        return hour;
    }

    public void setHour(String hour) {
        this.hour = hour;
    }

    public String getaHour() {
        return aHour;
    }

    public void setaHour(String aHour) {
        this.aHour = aHour;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValueA() {
        return valueA;
    }

    public void setValueA(String valueA) {
        this.valueA = valueA;
    }

    public String getValueN() {
        return valueN;
    }

    public void setValueN(String valueN) {
        this.valueN = valueN;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getInscription() {
        return inscription;
    }

    public void setInscription(String inscription) {
        this.inscription = inscription;
    }

    public String getpEmail() {
        return pEmail;
    }

    public void setpEmail(String pEmail) {
        this.pEmail = pEmail;
    }

    public String getpSite() {
        return pSite;
    }

    public void setpSite(String pSite) {
        this.pSite = pSite;
    }

    public String getpPhone() {
        return pPhone;
    }

    public void setpPhone(String pPhone) {
        this.pPhone = pPhone;
    }

    public String getpFax() {
        return pFax;
    }

    public void setpFax(String pFax) {
        this.pFax = pFax;
    }

    public String getObs() {
        return obs;
    }

    public void setObs(String obs) {
        this.obs = obs;
    }

    public String getLimit() {
        return limit;
    }

    public void setLimit(String limit) {
        this.limit = limit;
    }

    public String getDateA() {
        return dateA;
    }

    public void setDateA(String dateA) {
        this.dateA = dateA;
    }

    public String getDateD() {
        return dateD;
    }

    public void setDateD(String dateD) {
        this.dateD = dateD;
    }

    public List<String> getPatroc() {
        return patroc == null ? new ArrayList<String>() : patroc;
    }

    public void setPatroc(List<String> patroc) {
        this.patroc = patroc;
    }

    public String getExAss() {
        return exAss;
    }

    public void setExAss(String exAss) {
        this.exAss = exAss;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public boolean isRegistered() {
        return isRegistered;
    }

    public void setRegistered(boolean registered) {
        isRegistered = registered;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeString(this.title);
        dest.writeString(this.type);
        dest.writeString(this.panelist);
        dest.writeString(this.theme);
        dest.writeString(this.synopsis);
        dest.writeString(this.date);
        dest.writeString(this.aDate);
        dest.writeString(this.hour);
        dest.writeString(this.aHour);
        dest.writeString(this.location);
        dest.writeString(this.value);
        dest.writeString(this.valueA);
        dest.writeString(this.valueN);
        dest.writeString(this.language);
        dest.writeString(this.inscription);
        dest.writeString(this.pEmail);
        dest.writeString(this.pSite);
        dest.writeString(this.pPhone);
        dest.writeString(this.pFax);
        dest.writeString(this.obs);
        dest.writeString(this.limit);
        dest.writeString(this.dateA);
        dest.writeString(this.dateD);
        dest.writeStringList(this.patroc);
        dest.writeString(this.exAss);
        dest.writeString(this.url);
        dest.writeByte(this.isRegistered ? (byte) 1 : (byte) 0);
    }

    protected Event(Parcel in) {
        this.id = in.readInt();
        this.title = in.readString();
        this.type = in.readString();
        this.panelist = in.readString();
        this.theme = in.readString();
        this.synopsis = in.readString();
        this.date = in.readString();
        this.aDate = in.readString();
        this.hour = in.readString();
        this.aHour = in.readString();
        this.location = in.readString();
        this.value = in.readString();
        this.valueA = in.readString();
        this.valueN = in.readString();
        this.language = in.readString();
        this.inscription = in.readString();
        this.pEmail = in.readString();
        this.pSite = in.readString();
        this.pPhone = in.readString();
        this.pFax = in.readString();
        this.obs = in.readString();
        this.limit = in.readString();
        this.dateA = in.readString();
        this.dateD = in.readString();
        this.patroc = in.createStringArrayList();
        this.exAss = in.readString();
        this.url = in.readString();
        this.isRegistered = in.readByte() != 0;
    }

    public static final Creator<Event> CREATOR = new Creator<Event>() {
        @Override
        public Event createFromParcel(Parcel source) {
            return new Event(source);
        }

        @Override
        public Event[] newArray(int size) {
            return new Event[size];
        }
    };
}
