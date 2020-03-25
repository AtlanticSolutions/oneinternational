package br.com.lab360.bioprime.logic.model.pojo.promotionalcard;

import org.simpleframework.xml.Path;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;

@Root(name = "dict", strict = false)
public class Dict{

    @Path("integer[1]")
    @Text
    public int integer1;

    @Path("integer[2]")
    @Text
    public int integer2;

    @Path("integer[3]")
    @Text
    public int integer3;

    @Path("integer[4]")
    @Text
    public int integer4;

    @Path("string[1]")
    @Text
    public String string1;

    @Path("string[2]")
    @Text
    public String string2;

    @Path("string[3]")
    @Text
    public String string3;

    @Path("string[4]")
    @Text
    public String string4;

    @Path("string[5]")
    @Text
    public String string5;

    @Path("string[6]")
    @Text
    public String string6;

    @Path("string[7]")
    @Text
    public String string7;

    @Path("string[8]")
    @Text
    public String string8;

    @Path("string[9]")
    @Text
    public String string9;

    @Path("string[10]")
    @Text
    public String string10;

    @Path("string[11]")
    @Text
    public String string11;

    @Path("string[12]")
    @Text
    public String string12;

    @Path("string[13]")
    @Text
    public String string13;

    @Path("string[14]")
    @Text
    public String string14;

    @Path("string[15]")
    @Text
    public String string15;

    @Path("real[1]")
    @Text
    public double real1;

    @Path("real[2]")
    @Text
    public double real2;

    public Dict(){

    }
}