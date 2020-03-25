package br.com.lab360.bioprime.logic.model.pojo.customer;

import com.google.gson.annotations.SerializedName;

/**
 * Created by paulo on 08/11/2017.
 */
public class CustomerDetail {
    private int id;

    @SerializedName("access_token")
    private String  accessToken;

    @SerializedName("first_name")
    private String  firstName;

    @SerializedName("last_name")
    private String  lastName;
    private String  email;
    private String  phone;

    @SerializedName("ddd_phone")
    private String  dddPhone;

    private String  address;
    private String  city;
    private String  zipcode;
    private String  state;
    private String  country;
    private String  cpf;
    private String  number;
    private String  complement;
    private String  district;

    @SerializedName("cell_phone")
    private String  cellPhone;
    private String  rg;

    @SerializedName("ddd_cell_phone")
    private String  dddCellPhone;

    @SerializedName("gender")
    private String  gender;

    @SerializedName("profile_image")
    private String  profileImage;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDddPhone() {
        return dddPhone;
    }

    public void setDddPhone(String dddPhone) {
        this.dddPhone = dddPhone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
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

    public String getCellPhone() {
        return cellPhone;
    }

    public void setCellPhone(String cellPhone) {
        this.cellPhone = cellPhone;
    }

    public String getRg() {
        return rg;
    }

    public void setRg(String rg) {
        this.rg = rg;
    }

    public String getDddCellPhone() {
        return dddCellPhone;
    }

    public void setDddCellPhone(String dddCellPhone) {
        this.dddCellPhone = dddCellPhone;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

}
