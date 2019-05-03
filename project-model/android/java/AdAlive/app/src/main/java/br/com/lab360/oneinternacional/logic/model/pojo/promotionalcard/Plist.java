package br.com.lab360.oneinternacional.logic.model.pojo.promotionalcard;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "plist")
public class Plist {

    @Attribute(name = "version")
    private String version;


    @Element(name = "dict", required = false)
    Dict dict;

    public Plist(){

    }

    public Dict getDict() {
        return dict;
    }

    public void setDict(Dict dict) {
        this.dict = dict;
    }

}


