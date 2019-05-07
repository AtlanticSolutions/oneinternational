package br.com.lab360.oneinternacional.logic.model.pojo.user;

import android.os.Parcel;
import android.os.Parcelable;
import androidx.annotation.IntDef;
import android.text.TextUtils;

import com.google.gson.annotations.SerializedName;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.ErrorResponse;
import br.com.lab360.oneinternacional.utils.ValidatorUtils;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public class User implements Parcelable {
    @SerializedName("id")
    private int id;

    @SerializedName("access_token")
    private String accessToken;

    @SerializedName("first_name")
    private String firstName;

    @SerializedName("last_name")
    private String lastName;

    @SerializedName("email")
    private String email;

    @SerializedName("ddd_phone")
    private String dddPhone;

    @SerializedName("phone")
    private String phone;

    @SerializedName("ddd_cell_phone")
    private String dddCellPhone;

    @SerializedName("cell_phone")
    private String cellPhone;

    @SerializedName("role")
    private String role;

    @SerializedName("company_name")
    private String companyName;

    @SerializedName("address")
    private String address;

    @SerializedName("number")
    private String number;

    @SerializedName("complement")
    private String complement;

    @SerializedName("district")
    private String district;

    @SerializedName("city")
    private String city;

    @SerializedName("zipcode")
    private String zipcode;

    @SerializedName("state")
    private String state;

    @SerializedName("country")
    private String country;

    @SerializedName("sector_id")
    private int sectorId;

    @SerializedName("job_role_id")
    private String jobRoleID;

    @SerializedName("cpf")
    private String cpf;

    @SerializedName("cnpj")
    private String cnpj;

    @SerializedName("rg")
    private String rg;

    @SerializedName("birthdate")
    private String birthDate;

    @SerializedName("gender")
    private Object gender;

    @SerializedName("profile_image")
    private String profileImageURL;


    @SerializedName("events_speaker")
    private ArrayList<Integer> eventsSpeaker;

    @SerializedName("interest_areas")
    private ArrayList<Integer> interestArea;

    @SerializedName("login")
    private String login;

    @SerializedName("marital_status")
    private String maritalStatus;

    @SerializedName("password")
    private String password;

    @SerializedName("base64_profile_image")
    private String profileImage;

    @SerializedName("app_id")
    private String appid;

    @SerializedName("fb_access_token")
    private String token;

    @SerializedName("fb_id")
    private String fbid;

    boolean create;

    private ErrorResponse message;
    private boolean errors;

    public static User createUserForRegistration(String firstName, String email, String password, String facebookToken, String photoBase64, String companyName) {
        return new User(facebookToken, firstName, null, companyName, 0, photoBase64, null, null, email, null, null, null, null, null, null, password, 0);
    }

    public static User createUserForRegistrationOneInternacional(String firstName, String email, String password, String cpf, String cnpj, String facebookToken, String photoBase64) {
        return new User(facebookToken, firstName, cpf, cnpj, 0, photoBase64, email, password, 0);
    }

    public static User createUserToUpdateProfile(int id, String firstName, String companyName, String state, String city, String role, int sectorId, String profileImage, ArrayList<Integer> interestArea, String email, String newPassword) {
        return new User (null, firstName, null, companyName, sectorId, profileImage, interestArea, null, email, role, null, city, null, state, null, newPassword, id);
    }

    public boolean equals(User user) {

        String currentFirstName = firstName == null ? "" : firstName;
        String currentCompanyName = companyName == null ? "" : companyName;
        String currentProfileImage = profileImage == null ? "" : profileImage;
        ArrayList<Integer> currentInterestArea = interestArea == null ? new ArrayList<Integer>() : interestArea;
        String currentEmail = email == null ? "" : email;
        String currentPassword = password == null ? "" : password;

        String newFirstName = user.getFirstName() == null ? "" : user.getFirstName();
        String newCompanyName = user.getCompanyName() == null ? "" : user.getCompanyName();
        String newProfileImage = user.getProfileImage() == null ? "" : user.getProfileImage();
        ArrayList<Integer> newInterestArea = user.getInterestArea() == null ?
                new ArrayList<Integer>() : user.getInterestArea();
        String newEmail = user.getEmail() == null ? "" : user.getEmail();
        String newPassword = user.getPassword() == null ? "" : user.getPassword();

        return currentFirstName.equals(newFirstName) &&
                currentCompanyName.equals(newCompanyName) &&
                sectorId == user.getSectorId() &&
                currentProfileImage.equals(newProfileImage) &&
                currentInterestArea.equals(newInterestArea) &&
                currentEmail.equals(newEmail) &&
                currentPassword.equals(newPassword);
    }

    public User() {
        interestArea = new ArrayList<>();
        eventsSpeaker = new ArrayList<>();
    }

    private User(String accessToken, String firstName, String lastName, String companyName, int sectorId, String profileImage, ArrayList<Integer> interestArea, ArrayList<Integer> eventsSpeaker, String email, String jobRoleID, String address, String city, String zipcode, String state, String country, String password, int id) {
        this.accessToken = accessToken;
        this.firstName = firstName;
        this.lastName = lastName;
        this.companyName = companyName;
        this.sectorId = sectorId;
        this.profileImage = profileImage;
        this.interestArea = interestArea;
        this.eventsSpeaker = eventsSpeaker;
        this.email = email;
        this.jobRoleID = jobRoleID;
        this.address = address;
        this.city = city;
        this.zipcode = zipcode;
        this.state = state;
        this.country = country;
        this.password = password;
        this.id = id;
    }

    private User(String accessToken, String firstName, String cpf, String cnpj, int sectorId, String profileImage, String email, String password, int id) {
        this.accessToken = accessToken;
        this.firstName = firstName;
        this.cpf = cpf;
        this.cnpj = cnpj;
        this.sectorId = sectorId;
        this.profileImage = profileImage;
        this.email = email;
        this.password = password;
        this.id = id;
    }

    public User(String appid, String accessToken, String fbid, boolean create, String firstName, String email) {
        this.appid = appid;
        this.accessToken = accessToken;
        this.fbid = fbid;
        this.create = create;
        this.firstName = firstName;
        this.email = email;
    }

    //region Public methods

    /**
     * Validate user input during registration attempt
     *
     * @return
     */
    public ArrayList<Integer> validateSignup() {
        ArrayList<Integer> wrongFields = new ArrayList<>();

        if (TextUtils.isEmpty(email)) {
            wrongFields.add(FieldType.EMAIL);
        } else if (!ValidatorUtils.isEmailValid(email)) {
            wrongFields.add(FieldType.EMAIL_INVALID);
        }
        if (TextUtils.isEmpty(password)) {
            wrongFields.add(FieldType.PASSWORD);
        }
        if (password.length() < 8 || password.length() > 14) {
            wrongFields.add(FieldType.PASSWORD_CHARACTER);
        }
        if (TextUtils.isEmpty(firstName)) {
            wrongFields.add(FieldType.NAME);
        }

        return wrongFields.size() > 0 ? wrongFields : null;
    }

    /**
     * Validate user input during edit profile attempt
     *
     * @return
     */
    public ArrayList<Integer> validateEditProfile() {

        ArrayList<Integer> wrongFields = new ArrayList<>();
        if (TextUtils.isEmpty(email)) {
            wrongFields.add(FieldType.EMAIL);
        } else if (!ValidatorUtils.isEmailValid(email)) {
            wrongFields.add(FieldType.EMAIL_INVALID);
        }
        if (TextUtils.isEmpty(firstName)) {
            wrongFields.add(FieldType.NAME);
        }
        /*
        if (sectorId <= 0) {
            wrongFields.add(FieldType.SECTOR);
        }

        if (interestArea.size() == 0) {
            wrongFields.add(FieldType.INTEREST_AREA);
        }*/
        return wrongFields.size() > 0 ? wrongFields : null;
    }

    /**
     * check if has server errors
     *
     * @return
     */
    public boolean hasErrors() {
        return errors;
    }

    /**
     * Get fields given server errors
     *
     * @return
     */
    public ArrayList<Integer> getErrorFields() {
        ArrayList<Integer> wrongFields = new ArrayList<>();

        if (!TextUtils.isEmpty(message.getEmailErrorMessage())) {
            wrongFields.add(User.FieldType.EMAIL_SERVER_ERROR);
        }
        if (!TextUtils.isEmpty(message.getPasswordErrorMessage())) {
            wrongFields.add(User.FieldType.PASSWORD_CHARACTER);
        }

        return wrongFields.size() > 0 ? wrongFields : null;
    }

    //endregion

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({User.FieldType.EMAIL_SERVER_ERROR,
            User.FieldType.PASSWORD,
            User.FieldType.NAME,
            User.FieldType.PASSWORD_CHARACTER,
            User.FieldType.INTEREST_AREA,
            User.FieldType.SECTOR})
    public @interface FieldType {
        int EMAIL = 0;
        int EMAIL_INVALID = 1;
        int EMAIL_SERVER_ERROR = 2;
        int PASSWORD = 3;
        int PASSWORD_CHARACTER = 4;
        int NAME = 5;
        int INTEREST_AREA = 6;
        int SECTOR = 7;
        int COMPANY = 8;
    }

    //region Getter/Setters

    public void setProfileImageURL(String profileImageURL) {
        this.profileImageURL = profileImageURL;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public int getSectorId() {
        return sectorId;
    }

    public void setSectorId(int sectorId) {
        this.sectorId = sectorId;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public ArrayList<Integer> getInterestArea() {
        return interestArea;
    }

    public void setInterestArea(ArrayList<Integer> interestArea) {
        this.interestArea = interestArea;
    }

    public ArrayList<Integer> getEventsSpeaker() {
        return eventsSpeaker;
    }

    public void setEventsSpeaker(ArrayList<Integer> eventsSpeaker) {
        this.eventsSpeaker = eventsSpeaker;
    }

    public String getProfileImageURL() {
        return profileImageURL;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getJobRoleID() {
        return jobRoleID;
    }

    public void setJobRoleID(String jobRoleID) {
        this.jobRoleID = jobRoleID;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getComplement() {
        return complement;
    }

    public void setComplement(String complement) {
        this.complement = complement;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }

    public String getAppid() {
        return appid;
    }

    public void setAppid(String appid) {
        this.appid = appid;
    }

    public boolean isCreate() {
        return create;
    }

    public void setCreate(boolean create) {
        this.create = create;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getFbid() {
        return fbid;
    }

    public void setFbid(String fbid) {
        this.fbid = fbid;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public String getRg() {
        return rg;
    }

    public void setRg(String rg) {
        this.rg = rg;
    }

    public String getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(String birthDate) {
        this.birthDate = birthDate;
    }

    public Object getGender() {
        return gender;
    }

    public void setGender(Object gender) {
        this.gender = gender;
    }

    public String getDddPhone() {
        return dddPhone;
    }

    public void setDddPhone(String dddPhone) {
        this.dddPhone = dddPhone;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDddCellPhone() {
        return dddCellPhone;
    }

    public void setDddCellPhone(String dddCellPhone) {
        this.dddCellPhone = dddCellPhone;
    }

    public String getCellPhone() {
        return cellPhone;
    }

    public void setCellPhone(String cellPhone) {
        this.cellPhone = cellPhone;
    }

    //endregion

    //region Parcelable

    //endregion
    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.accessToken);
        dest.writeString(this.firstName);
        dest.writeString(this.lastName);
        dest.writeString(this.companyName);
        dest.writeInt(this.sectorId);
        dest.writeString(this.profileImage);
        dest.writeString(this.profileImageURL);
        dest.writeList(this.interestArea);
        dest.writeList(this.eventsSpeaker);
        dest.writeInt(this.id);
        dest.writeString(this.email);
        dest.writeString(this.jobRoleID);
        dest.writeString(this.address);
        dest.writeString(this.city);
        dest.writeString(this.zipcode);
        dest.writeString(this.state);
        dest.writeString(this.country);
        dest.writeString(this.password);
        dest.writeParcelable(this.message, flags);
        dest.writeString(this.role);
        dest.writeByte(this.errors ? (byte) 1 : (byte) 0);
    }

    protected User(Parcel in) {
        this.accessToken = in.readString();
        this.firstName = in.readString();
        this.lastName = in.readString();
        this.companyName = in.readString();
        this.sectorId = in.readInt();
        this.profileImage = in.readString();
        this.profileImageURL = in.readString();
        this.interestArea = new ArrayList<Integer>();
        in.readList(this.interestArea, Integer.class.getClassLoader());
        this.eventsSpeaker = new ArrayList<Integer>();
        in.readList(this.eventsSpeaker, Integer.class.getClassLoader());
        this.id = in.readInt();
        this.email = in.readString();
        this.jobRoleID = in.readString();
        this.address = in.readString();
        this.city = in.readString();
        this.zipcode = in.readString();
        this.state = in.readString();
        this.country = in.readString();
        this.password = in.readString();
        this.message = in.readParcelable(ErrorResponse.class.getClassLoader());
        this.role = in.readString();
        this.errors = in.readByte() != 0;
    }

    public static final Creator<User> CREATOR = new Creator<User>() {
        @Override
        public User createFromParcel(Parcel source) {
            return new User(source);
        }

        @Override
        public User[] newArray(int size) {
            return new User[size];
        }
    };

}
