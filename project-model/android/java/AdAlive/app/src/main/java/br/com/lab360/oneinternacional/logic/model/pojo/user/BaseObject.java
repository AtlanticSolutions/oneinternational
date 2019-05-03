package br.com.lab360.oneinternacional.logic.model.pojo.user;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.common.base.Strings;

/**
 * Created by Alessandro Valenza on 23/11/2016.
 */
public class BaseObject implements Parcelable {
    private int id;
    private String name, email, cargo, cidade, estado;
    private boolean selected;

    public BaseObject() {
    }

    public BaseObject(int id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
    }

    public BaseObject(int id, String name, String email, String cargo, String cidade, String estado) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.cargo = cargo;
        this.cidade = cidade;
        this.estado = estado;
    }

    //region Public methods
    public void toggleSelection() {
        selected = !selected;
    }
    //endregion

    //region Override Methods
    @Override
    public boolean equals(Object object) {
        boolean sameSame = false;

        if (object != null && object instanceof BaseObject) {
            sameSame = this.id == ((BaseObject) object).getId();
        }

        return sameSame;
    }
    //endregion

    //region Getter/Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isSelected() {
        return selected;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCargo() {
        return Strings.isNullOrEmpty(cargo) ? "" : cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public String getCidade() {
        return Strings.isNullOrEmpty(cidade) ? "" : cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getEstado() {
        return Strings.isNullOrEmpty(estado) ? "" : estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    //endregion


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeString(this.name);
        dest.writeString(this.email);
        dest.writeString(this.cargo);
        dest.writeString(this.cidade);
        dest.writeString(this.estado);

        dest.writeByte(this.selected ? (byte) 1 : (byte) 0);
    }

    protected BaseObject(Parcel in) {
        this.id = in.readInt();
        this.name = in.readString();
        this.email = in.readString();
        this.cargo = in.readString();
        this.cidade = in.readString();
        this.estado= in.readString();

        this.selected = in.readByte() != 0;
    }

    public static final Creator<BaseObject> CREATOR = new Creator<BaseObject>() {
        @Override
        public BaseObject createFromParcel(Parcel source) {
            return new BaseObject(source);
        }

        @Override
        public BaseObject[] newArray(int size) {
            return new BaseObject[size];
        }
    };
}
