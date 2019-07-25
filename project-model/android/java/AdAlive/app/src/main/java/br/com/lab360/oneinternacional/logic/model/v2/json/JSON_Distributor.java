package br.com.lab360.oneinternacional.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

/**
 * Created by paulo on 03/11/2017.
 */

public class JSON_Distributor {
    @SerializedName("name=")
    public String name;

    @SerializedName("phone=")
    public String phone;

    @SerializedName("cell_phone=")
    public String cell_phone;

    @SerializedName("email=")
    public String email;

    @SerializedName("street=")
    public String street;

    @SerializedName("number=")
    public String number;

    @SerializedName("complement=")
    public String complement;

    @SerializedName("zip_code=")
    public String zip_code;

    @SerializedName("district=")
    public String district;

    @SerializedName("city=")
    public String city;

    @SerializedName("state=")
    public String state;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCell_phone() {
        return cell_phone;
    }

    public void setCell_phone(String cell_phone) {
        this.cell_phone = cell_phone;
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
}


