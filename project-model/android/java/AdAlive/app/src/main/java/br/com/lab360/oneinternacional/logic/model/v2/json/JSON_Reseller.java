package br.com.lab360.oneinternacional.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

/**
 * Created by paulo on 03/11/2017.
 */

public class JSON_Reseller {
    @SerializedName("profile_image")
    public String profile_image;
    public String name;
    public String cpf;
    public String birthdate;
    public String phone;

    @SerializedName("cell_phone")
    public String cellPhone;
    public String email;
    public String street;
    public String number;
    public String complement;

    @SerializedName("zip_code")
    public String zip_code;
    public String district;
    public String city;
    public String state;

    public JSON_Distributor distributor;

    public String getProfile_image() {
        return profile_image;
    }

    public void setProfile_image(String profile_image) {
        this.profile_image = profile_image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(String birthdate) {
        this.birthdate = birthdate;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCellPhone() {
        return cellPhone;
    }

    public void setCellPhone(String cellPhone) {
        this.cellPhone = cellPhone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
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

    public String getZip_code() {
        return zip_code;
    }

    public void setZip_code(String zip_code) {
        this.zip_code = zip_code;
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

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public JSON_Distributor getDistributor() {
        return distributor;
    }

    public void setDistributor(JSON_Distributor distributor) {
        this.distributor = distributor;
    }
}
