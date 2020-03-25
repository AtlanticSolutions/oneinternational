package br.com.lab360.bioprime.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Methods for applying useful.
 * Created by Victor on 02/08/2016.
 */
public abstract class ValidatorUtils {

    private static final int[] pesoCPF = {11, 10, 9, 8, 7, 6, 5, 4, 3, 2};
    private static final int[] pesoCNPJ = {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};

    private static int calcularDigito(String str, int[] peso) {
        int soma = 0;
        for (int indice = str.length() - 1, digito; indice >= 0; indice--) {
            digito = Integer.parseInt(str.substring(indice, indice + 1));
            soma += digito * peso[peso.length - str.length() + indice];
        }
        soma = 11 - soma % 11;
        return soma > 9 ? 0 : soma;
    }


    /**
     * Method is used for checking valid email id format.
     *
     * @param email
     * @return boolean true for valid false for invalid
     */
    public static boolean isEmailValid(String email) {
        boolean isValid = false;
        String expression = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";

        Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(email);
        if (matcher.matches()) {
            isValid = true;
        }
        return isValid;
    }

    /**
     * Method is used for checking valid email id format.
     *
     * @param cpf
     * @return boolean true for valid false for invalid
     */
    public static boolean isCPFValid(String cpf) {
        String cpfresult = cpf.replaceAll("[-+.^:,/]", "");
        if ((cpfresult == null) || (cpfresult.length() != 11))
            return false;

        Integer digito1 = calcularDigito(cpfresult.substring(0, 9), pesoCPF);
        Integer digito2 = calcularDigito(cpfresult.substring(0, 9) + digito1, pesoCPF);

        return cpfresult.equals(cpfresult.substring(0, 9) + digito1.toString() + digito2.toString());

    }

    /**
     * Method is used for checking valid email id format.
     *
     * @param cnpj
     * @return boolean true for valid false for invalid
     */
    public static boolean isCNPJValid(String cnpj) {
        String cnpjresult = cnpj.replaceAll("[-+.^:,/]", "");
        if ((cnpjresult == null) || (cnpjresult.length() != 14))
            return false;

        Integer digito1 = calcularDigito(cnpjresult.substring(0, 12), pesoCNPJ);
        Integer digito2 = calcularDigito(cnpjresult.substring(0, 12) + digito1, pesoCNPJ);

        return cnpjresult.equals(cnpjresult.substring(0, 12) + digito1.toString() + digito2.toString());

    }

}
