package br.com.lab360.bioprime.logic.model.pojo.promotionalcard;


import com.google.gson.annotations.SerializedName;

public class PromotionalCard {

    @SerializedName("id")
    int id;
    @SerializedName("code")
    String code;
    @SerializedName("title")
    String title;
    @SerializedName("link")
    String link;
    @SerializedName("message")
    String message;
    @SerializedName("info")
    String info;
    @SerializedName("is_premium")
    int isPremium;
    @SerializedName("prefered_size")
    int prefered_size;
    @SerializedName("prefered_posistion")
    int prefered_posistion;
    @SerializedName("url_prize_won")
    String url_prize_won;
    @SerializedName("url_prize_lose")
    String url_prize_lose;
    @SerializedName("url_prize_pedding")
    String url_prize_pedding;
    @SerializedName("url_background_card")
    String url_background_card;
    @SerializedName("url_cover_card")
    String url_cover_card;
    @SerializedName("url_background_screen")
    String url_background_screen;
    @SerializedName("url_particle_object")
    String url_particle_object;
    @SerializedName("color_background")
    String color_background;
    @SerializedName("color_detail")
    String color_detail;
    @SerializedName("color_text")
    String color_text;
    @SerializedName("line_width")
    double line_width;
    @SerializedName("cover_limit")
    double cover_limit;


    public static PromotionalCard parse (Plist plist){
        PromotionalCard promotionalCard = new PromotionalCard();
        promotionalCard.setId(plist.getDict().integer1);
        promotionalCard.setIsPremium(plist.getDict().integer2);
        promotionalCard.setPreferedSize(plist.getDict().integer3);
        promotionalCard.setPreferedPosistion(plist.getDict().integer4);
        promotionalCard.setCode(plist.getDict().string1);
        promotionalCard.setTitle(plist.getDict().string2);
        promotionalCard.setLink(plist.getDict().string3);
        promotionalCard.setMessage(plist.getDict().string4);
        promotionalCard.setInfo(plist.getDict().string5);
        promotionalCard.setUrlPrizeWon(plist.getDict().string6);
        promotionalCard.setUrlPrizeLose(plist.getDict().string7);
        promotionalCard.setUrlPrizePedding(plist.getDict().string8);
        promotionalCard.setUrlBackgroundCard(plist.getDict().string9);
        promotionalCard.setUrlCoverCard(plist.getDict().string10);
        promotionalCard.setUrlBackgroundScreen(plist.getDict().string11);
        promotionalCard.setUrlParticleObject(plist.getDict().string12);
        promotionalCard.setColorBackground(plist.getDict().string13);
        promotionalCard.setColorDetail(plist.getDict().string14);
        promotionalCard.setColorText(plist.getDict().string15);
        promotionalCard.setLineWidth(plist.getDict().real1);
        promotionalCard.setCoverLimit(plist.getDict().real2);
        return promotionalCard;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public int getIsPremium() {
        return isPremium;
    }

    public void setIsPremium(int isPremium) {
        this.isPremium = isPremium;
    }

    public int getPreferedSize() {
        return prefered_size;
    }

    public void setPreferedSize(int prefered_size) {
        this.prefered_size = prefered_size;
    }

    public int getPreferedPosistion() {
        return prefered_posistion;
    }

    public void setPreferedPosistion(int prefered_posistion) {
        this.prefered_posistion = prefered_posistion;
    }

    public String getUrlPrizeWon() {
        return url_prize_won;
    }

    public void setUrlPrizeWon(String url_prize_won) {
        this.url_prize_won = url_prize_won;
    }

    public String getUrlPrizeLose() {
        return url_prize_lose;
    }

    public void setUrlPrizeLose(String url_prize_lose) {
        this.url_prize_lose = url_prize_lose;
    }

    public String getUrlPrizePedding() {
        return url_prize_pedding;
    }

    public void setUrlPrizePedding(String url_prize_pedding) {
        this.url_prize_pedding = url_prize_pedding;
    }

    public String getUrlBackgroundCard() {
        return url_background_card;
    }

    public void setUrlBackgroundCard(String url_background_card) {
        this.url_background_card = url_background_card;
    }

    public String getUrlCoverCard() {
        return url_cover_card;
    }

    public void setUrlCoverCard(String url_cover_card) {
        this.url_cover_card = url_cover_card;
    }

    public String getUrlBackgroundScreen() {
        return url_background_screen;
    }

    public void setUrlBackgroundScreen(String url_background_screen) {
        this.url_background_screen = url_background_screen;
    }

    public String getUrlParticleObject() {
        return url_particle_object;
    }

    public void setUrlParticleObject(String url_particle_object) {
        this.url_particle_object = url_particle_object;
    }

    public String getColorBackground() {
        return color_background;
    }

    public void setColorBackground(String color_background) {
        this.color_background = color_background;
    }

    public String getColorDetail() {
        return color_detail;
    }

    public void setColorDetail(String color_detail) {
        this.color_detail = color_detail;
    }

    public String getColorText() {
        return color_text;
    }

    public void setColorText(String color_text) {
        this.color_text = color_text;
    }

    public double getLineWidth() {
        return line_width;
    }

    public void setLineWidth(double line_width) {
        this.line_width = line_width;
    }

    public double getCoverLimit() {
        return cover_limit;
    }

    public void setCoverLimit(double cover_limit) {
        this.cover_limit = cover_limit;
    }

}


