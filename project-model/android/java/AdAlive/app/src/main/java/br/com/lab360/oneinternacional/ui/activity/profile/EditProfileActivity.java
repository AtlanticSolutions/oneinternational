package br.com.lab360.oneinternacional.ui.activity.profile;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.appcompat.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Base64;
import android.util.Log;
import android.util.Pair;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;

import org.apache.commons.validator.routines.EmailValidator;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.UserInteractor;
import br.com.lab360.oneinternacional.logic.interactor.CustomerInteractor;
import br.com.lab360.oneinternacional.logic.interactor.PromotionRegisterInteractor;
import br.com.lab360.oneinternacional.logic.model.pojo.user.UpdateUserRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.utils.CepResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.customer.CustomerResponseDetail;
import br.com.lab360.oneinternacional.logic.presenter.profile.ProfilePresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.activity.timeline.TimelineActivity;
import br.com.lab360.oneinternacional.utils.Base64Utils;
import br.com.lab360.oneinternacional.utils.DatePickerUtil;
import br.com.lab360.oneinternacional.utils.FieldsValidator;
import br.com.lab360.oneinternacional.utils.ImageUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import de.hdodenhof.circleimageview.CircleImageView;
import me.anshulagarwal.simplifypermissions.Permission;

/**
 * Created by David on 10/11/2017.
 *
 */

public class EditProfileActivity extends BaseActivity implements PromotionRegisterInteractor.
        CepInteractorListener, ProfilePresenter.ISignupView,
        UserInteractor.UpdateCustomerListener{

    //region Binds
    @BindView(R.id.containerProgressBar)    protected LinearLayout containerProgressBar;
    @BindView(R.id.edtCpf)                  protected EditText edtCpf;
    @BindView(R.id.edtCnpj)                  protected EditText edtCnpj;
    @BindView(R.id.edtRg)                   protected EditText edtRg;
    @BindView(R.id.edtName)                 protected EditText edtNome;
    @BindView(R.id.edtSobrenome)            protected EditText edtSobrenome;
    @BindView(R.id.edtDataNasc)             protected EditText edtDataNasc;
    @BindView(R.id.sexo)                    protected Spinner spinnerSexo;
    @BindView(R.id.edtDDDTel)               protected EditText edtDddTel;
    @BindView(R.id.edtTelefone)             protected EditText edtTelefone;
    @BindView(R.id.edtDDDCelular)           protected EditText edtDddCelular;
    @BindView(R.id.edtCelular)              protected EditText edtCelular;
    @BindView(R.id.edtEmail)                protected EditText edtEmail;
    @BindView(R.id.edtCep)                  protected EditText edtCep;
    @BindView(R.id.edtEndereco)             protected EditText edtEndereco;
    @BindView(R.id.edtNumero)               protected EditText edtNumero;
    @BindView(R.id.edtComplemento)          protected EditText edtComplemento;
    @BindView(R.id.edtBairro)               protected EditText edtBairro;
    @BindView(R.id.edtMunicipio)            protected EditText edtMunicipio;
    @BindView(R.id.edtEstado)               protected Spinner edtEstado;
    @BindView(R.id.edtEmpresa)              protected EditText edtEmpresa;
    @BindView(R.id.btnContinue)             protected Button btnContinue;
    @BindView(R.id.btnChangePassword)       protected Button btnChangePassword;
    @BindView(R.id.btnPhoto)                protected CircleImageView btnPhoto;
    //endregion

    /* Vars */
    private Map<Integer,EditText> edtToValidate = new HashMap<>();
    private PromotionRegisterInteractor promotionInteractor;
    private UserInteractor userInteractor;
    private String auxSpinnerSexo;
    private CustomerInteractor mCustomerInteractor;
    private String namePromotion;
    private long promotionId;
    private String urlTerms;
    private String textToWin;
    private Button btnEnviarCpf;
    private static final int BORN_YEAR_RANGE = 1999;
    private static final int CPF_LENGTH_FORMATTED = 14;
    private static final int CPF_LENGTH_FORMATTED_WITHOUT_POINT = 11;
    private static final int CEP_LENGTH_FORMATTED = 9;
    private static final int REQUEST_VALID_EMAIL = 100;
    public Spinner getSpinnerSexo() {
        return spinnerSexo;
    }
    private CustomerResponseDetail mCustomer;
    private static final int REQUEST_PICK_IMAGE = 0x32;
    private static final int REQUEST_CHANGE_PASSWORD = 0x33;
    private static final int REQUEST_TAKE_PHOTO = 0x31;
    private static final int PERMISSION_REQUEST_CODE = 0x33;
    private boolean gettingCustomer = false;
    public String password = "";

    private String[] ACTIVITY_PERMISSIONS = {
            Manifest.permission.CAMERA,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    };
    private ProfilePresenter mPresenter;
    private String mCurrentPhotoPath;

    //region Life Cyle
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);
        ButterKnife.bind(this);
        initToolbar(getString(R.string.SCREEN_TITLE_EDIT_PROFILE));
        configureData();
        configureUI();

        mPresenter = new ProfilePresenter(this);
        mPresenter.start();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case REQUEST_TAKE_PHOTO:
                    resizeBitmap(mCurrentPhotoPath);
                    btnPhoto.setImageBitmap(ImageUtils.resizePic(btnPhoto.getWidth(), btnPhoto.getHeight(), mCurrentPhotoPath));
                    ImageUtils.addPhotoToGallery(this, mCurrentPhotoPath);
                    break;
                case REQUEST_PICK_IMAGE:
                    Uri originalUri = data.getData();
                    mCurrentPhotoPath = ImageUtils.getRealPathFromUri(this, originalUri);
                    btnPhoto.setImageBitmap(ImageUtils.resizePic(btnPhoto.getWidth(), btnPhoto.getHeight(), mCurrentPhotoPath));
                    break;
                case REQUEST_VALID_EMAIL:
                    edtEmail.setText(data.getStringExtra("RESULT_STRING"));
                    break;
                case REQUEST_CHANGE_PASSWORD:
                    password = data.getStringExtra(AdaliveConstants.INTENT_TAG_PASSWORD);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onResume() {
        super.onResume();
        createFieldsMap();
        //createAndShowCPFDialog();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putString("TEXT_TO_WIN",textToWin);
    }

    //region ISignupView
    public void setPresenter(ProfilePresenter mPresenter) {
        this.mPresenter = mPresenter;
        this.mPresenter.start();
    }

    @Override
    public void setColorViews() {
        int color = Color.parseColor(UserUtils.getButtonColor(this));
        btnContinue.setBackgroundColor(color);
    }
    //endregion

    @Override
    public void initBackground() {

    }

    //region Camera methods
    @Override
    public void showGalleryCameraDialog() {
        AlertDialog dialog = new AlertDialog.Builder(this)
                .setTitle(getString(R.string.ALERT_TITLE_PICK_PHOTO))
                .setMessage(getString(R.string.ALERT_MESSAGE_PICK_PHOTO))
                .setPositiveButton(getString(R.string.ALERT_OPTION_TAKE_PHOTO), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        mPresenter.onBtnOpenCameraTouched();
                        dialogInterface.dismiss();
                    }
                })
                .setNegativeButton(getString(R.string.ALERT_OPTION_PICK_PHOTO), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        mPresenter.onBtnOpenGalleryTouched();
                        dialogInterface.dismiss();
                    }
                }).create();
        dialog.show();
    }

    @Override
    public void attemptToOpenGallery() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, getString(R.string.ALERT_TITLE_PICK_PHOTO)), REQUEST_PICK_IMAGE);
    }

    @Override
    public void attemptToOpenCamera() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Ensure that there's a camera activity to handle the intent
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                Pair<File, String> fileStringPair = ImageUtils.createImageFile(this);
                photoFile = fileStringPair.first;
                mCurrentPhotoPath = fileStringPair.second;

            } catch (IOException ex) {
                // Error occurred while creating the File
                mPresenter.onCreateFileError();
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {
                Uri photoURI = FileProvider.getUriForFile(this,
                        AdaliveConstants.FILE_PROVIDER_URI,
                        photoFile);
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO);
            }
        }
    }

    @Override
    public void checkPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

                Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
                    @Override
                    public void onPermissionGranted(int requestCode) {

                    }

                    @Override
                    public void onPermissionDenied(int requestCode) {
                        mPresenter.onPermissionDenied();
                    }

                    @Override
                    public void onPermissionAccessRemoved(int requestCode) {
                        mPresenter.onPermissionAccessRemoved();
                    }
                };
                Permission.PermissionBuilder permissionBuilder =
                        new Permission.PermissionBuilder(
                                ACTIVITY_PERMISSIONS,
                                PERMISSION_REQUEST_CODE,
                                mPermissionCallback)
                                .enableDefaultRationalDialog(
                                        getString(R.string.DIALOG_TITLE_PERMISSION),
                                        getString(R.string.DIALOG_PROFILE_MESSAGE_PERMISSION)
                                );

                requestAppPermissions(permissionBuilder.build());
            }
        }
    }

    @Override
    public void showPermissionNeededSnackMessage() {
        showSnackMessage(getString(R.string.DIALOG_PROFILE_MESSAGE_PERMISSION));
    }


    @Override
    public void showFileCreationError() {
        showToastMessage(getString(R.string.ERROR_ALERT_MESSAGE_DISK_SAVE));
    }
    //endregion

    //region Configuration
    private void configureUI() {
        edtDataNasc.setKeyListener(null);
        //edtCpf.setKeyListener(null);
        btnChangePassword.setVisibility(View.VISIBLE);
        btnContinue.setText(getString(R.string.BUTTON_TITLE_SAVE_PROFILE));
        btnPhoto.setVisibility(View.VISIBLE);
    }

    private void configureData() {
        createFieldsMap();
        promotionInteractor = new PromotionRegisterInteractor(this);
        userInteractor = new UserInteractor(this);
        mCustomerInteractor = new CustomerInteractor(this);
        populateUserFields();
        submitTextCep();
    }

    private void resizeBitmap(String filePath) {
        try {
            Bitmap bitmap = BitmapFactory.decodeFile(filePath);
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();
            float scaleWidth = ((float) 1024) / width;
            float scaleHeight = ((float) 1024) / height;
            // CREATE A MATRIX FOR THE MANIPULATION
            ExifInterface exif = new ExifInterface(filePath);
            int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

            int angle = 0;

            if (orientation == ExifInterface.ORIENTATION_ROTATE_90) {
                angle = 90;
            }
            else if (orientation == ExifInterface.ORIENTATION_ROTATE_180) {
                angle = 180;
            }
            else if (orientation == ExifInterface.ORIENTATION_ROTATE_270) {
                angle = 270;
            }

            Matrix mat = new Matrix();
            mat.postScale(scaleWidth, scaleHeight);
            mat.postRotate(angle);


            // "RECREATE" THE NEW BITMAP
            Bitmap resizedBitmap = Bitmap.createBitmap(
                    bitmap, 0, 0, width, height, mat, false);
            bitmap.recycle();
            OutputStream outStream = null;

            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
                file = new File(filePath);
                Log.e("file exist", "" + file + ",Bitmap= " + filePath);
            }
            try {
                // make a new bitmap from your file
                outStream = new FileOutputStream(file);
                resizedBitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);
                outStream.flush();
                outStream.close();
                resizedBitmap.recycle();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        catch (IOException e) {
            Log.w("TAG", "-- Error in setting image");
        }
        catch(OutOfMemoryError oom) {
            Log.w("TAG", "-- OOM Error in setting image");
        }
    }



    /**
     * Create CPF Dialog for user input
     */
    private void createAndShowCPFDialog() {
        /*dialogCPF = new CPFInputDialog(this, getString(R.string.custom_dialog_title),
                getString(R.string.msg_dialog_title),
                R.drawable.exclamacao_yellow, false, cpfOnClickListener);
        dialogCPF.show();*/
    }

    @OnClick(R.id.btnPhoto)
    public void onClick() {
        mPresenter.attemptToOpenPhoto();
    }

    //endregion


    //region Listener
    @OnClick({R.id.edtCpf, R.id.btnContinue, R.id.edtDataNasc, R.id.btnChangePassword})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btnContinue:
                attemptToUpdate();
                break;
            case R.id.btnChangePassword:
                Intent i = new Intent(this, ChangePasswordActivity.class);
                startActivityForResult(i, REQUEST_CHANGE_PASSWORD);
                break;
            case R.id.edtDataNasc:
                hideKeyboard();
                DatePickerUtil datePicker = new DatePickerUtil();
                datePicker.setEditText(edtDataNasc);
                datePicker.show(getSupportFragmentManager(), "");
                break;
            case R.id.edtCpf:
                createAndShowCPFDialog();
                break;
        }
    }


    /**
     * When the length of the cep content is equal or greater than 9, then it will call a resp api to get the
     * result from ws postmail service
     */

    public void submitTextCep(){
        edtCep.addTextChangedListener(new TextWatcher() {

            @Override
            public void afterTextChanged(Editable s) {}

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (edtCep.getText().length() >= 9) {
                    attempToGetAddress();
                    hideKeyboard();
                    return;
                }
            }
        });
    }

    public void attempToGetAddress(){
        showProgress();
        promotionInteractor.getCepAdress(edtCep.getText().toString(), this);
    }

    @OnTextChanged(R.id.edtCpf)
    protected void onCPFTextChanged() {
        /*
        final String formmated = edtCpf.getText().toString();
        if(gettingCustomer && formmated.length() < CPF_LENGTH_FORMATTED &&
                formmated.length() != CPF_LENGTH_FORMATTED_WITHOUT_POINT){
            gettingCustomer = false;
            cleanFields();
        }

        if (formmated.length() >= CPF_LENGTH_FORMATTED && !gettingCustomer) {
            gettingCustomer = true;
            if (ValidatorUtils.isCPFValid(formmated)) {

                String unfformated = formmated.replaceAll("[^\\d]", "");
                showProgress(this);
                promotionInteractor.getCustomerByCpf(BaseActivity.getUserToken(), unfformated,EditProfileActivity.this);
            } else {
                edtCpf.setError("CPF inválido");
            }
        }
        */
    }

    //endregion

    //region Utils

    public void attemptToUpdate() {
        Map<Integer,EditText> auxValidatedEdt = FieldsValidator.validateEditTextContent(edtToValidate);
        boolean isValid = true;

        if (!EmailValidator.getInstance().isValid(edtEmail.getText().toString())) {
            edtEmail.setError("E-mail inválido");
            isValid = false;
        }

        if (spinnerSexo.getSelectedItem().toString().equalsIgnoreCase("Sexo*")){
            TextView view = (TextView)spinnerSexo.getSelectedView();
            view.setError("Campo não pode ser nulo");
            isValid = false;
        }

        if (edtEstado.getSelectedItem().toString().equalsIgnoreCase("Estado*")){
            TextView view = (TextView) edtEstado.getSelectedView();
            view.setError("Campo não pode ser nulo");
            isValid = false;
        }

        if (auxValidatedEdt.isEmpty() && isValid) {
            List<String> emails = new ArrayList<>();


            User user = UserUtils.loadUser(this);

            /* Check if the email from Ad-Alive and typed email are the same */
            if (user.getEmail() != edtEmail.getText().toString()) {
                emails.add(user.getEmail());
                emails.add(edtEmail.getText().toString());
            }

            //User from API
            if (mCustomer != null) {

                /* Check if the email from Shopping API and typed are equal */
                if (mCustomer.getEmail() != edtEmail.getText().toString()) {
                    emails.add(mCustomer.getEmail());
                    emails.add(edtEmail.getText().toString());
                }

                /* Check if email from Shopping API is equal to Ad-alive */
                if (mCustomer.getEmail() != user.getEmail()) {
                    emails.add(mCustomer.getEmail());
                    emails.add(user.getEmail());
                }

            }

            /*if (emails.size() > 1) {
                Set<String> set = new HashSet<>();
                set.addAll(emails);
                String[] mArray = Arrays.copyOf(set.toArray(), set.size(), String[].class);


                EmailDialog dialogCPF = new EmailDialog(this,
                        getString(R.string.dialog_email_title),
                        getString(R.string.msg_dialog_email),
                        R.drawable.exclamacao_yellow, true, mInterface,
                        mArray);
                dialogCPF.show();
                return;
            }*/

            /* Proceed */

            if (edtTelefone.getEditableText().toString().equalsIgnoreCase("") &&
                    edtCelular.getEditableText().toString().equalsIgnoreCase("")){
                infoDialog("Atenção", "Ao menos um dos telefones deve ser preenchido", null);
            }else {

                attemptToProceed();
            }

        } else {

            for (int key : auxValidatedEdt.keySet()){
                auxValidatedEdt.get(key).setError("Campo não pode ser nulo");
            }

        }

    }


    private void attemptToProceed() {
        UpdateUserRequest updateUser = new UpdateUserRequest(populateUserValues());
        showProgress();
        userInteractor.updateCustomer(getUserToken(), updateUser, this);
    }

    private User populateUserValues() {
        User user = new User();
        user.setId(UserUtils.loadUser(this).getId());
        user.setCpf(edtCpf.getText().toString().replaceAll("[^\\d]",""));
        user.setCnpj(edtCnpj.getText().toString().replaceAll("[^\\d]",""));
        user.setFirstName(edtNome.getText().toString());
        user.setLastName(edtSobrenome.getText().toString());
        user.setRg(edtRg.getText().toString().replaceAll("[^\\d]",""));
        user.setBirthDate(edtDataNasc.getText().toString());
        user.setDddPhone(edtDddTel.getText().toString().replaceAll("[^\\d]", ""));
        user.setPhone(edtTelefone.getText().toString().replaceAll("[^\\d]", ""));
        user.setDddCellPhone(edtDddCelular.getText().toString().replaceAll("[^\\d]", ""));
        user.setCellPhone(edtCelular.getText().toString().replaceAll("[^\\d]", ""));
        user.setEmail(edtEmail.getText().toString());
        user.setCompanyName(edtEmpresa.getText().toString());
        user.setZipcode(edtCep.getText().toString().replaceAll("[^\\d]",""));
        user.setAddress(edtEndereco.getText().toString());
        user.setNumber(edtNumero.getText().toString());
        user.setComplement(edtComplemento.getText().toString());
        user.setCompanyName(edtEmpresa.getText().toString());
        user.setState(edtEstado.getSelectedItem().toString());
        user.setCity(edtMunicipio.getText().toString());
        user.setDistrict(edtBairro.getText().toString());

        if(mCurrentPhotoPath != null && !mCurrentPhotoPath.equals("")){
            user.setProfileImage(Base64Utils.encodeFileToBase64(ImageUtils.resizePic(200, 200, mCurrentPhotoPath) ,Bitmap.CompressFormat.PNG, 100));
        }else{
            user.setProfileImage(UserUtils.loadUser(this).getProfileImage());
        }

        if (spinnerSexo.getSelectedItem().toString().equalsIgnoreCase("Feminino")) {
            user.setGender("1");
        } else if (spinnerSexo.getSelectedItem().toString().equalsIgnoreCase("Masculino")) {
            user.setGender("0");
        }

        if(!password.equals("")){
            user.setPassword(password);
        }

        return user;
    }


    private void populateUserFields(){
        User user = UserUtils.loadUser(this);
        if(user == null)
            return;

        edtCpf.setText(user.getCpf());
        edtCnpj.setText(user.getCnpj());
        edtRg.setText(user.getRg());
        edtNome.setText(user.getFirstName());
        edtSobrenome.setText(user.getLastName());
        edtDataNasc.setText(user.getBirthDate());
        edtDddTel.setText(user.getDddPhone()); //To complete the mask
        edtTelefone.setText(user.getPhone());
        edtDddCelular.setText(user.getDddCellPhone());
        edtCelular.setText(user.getCellPhone());
        edtCep.setText(user.getZipcode());
        edtEndereco.setText(user.getAddress());
        edtNumero.setText(user.getNumber());
        edtComplemento.setText(user.getComplement());
        edtBairro.setText(user.getDistrict());
        edtMunicipio.setText(user.getCity());
        edtEmail.setText(user.getEmail());
        edtEmpresa.setText(user.getCompanyName());

        selectSpinnerState(edtEstado, user.getState());


        if(user.getProfileImage() != null && !user.getProfileImage().equals("")){
            if(user.getProfileImage().contains("http")){
                Glide.with(this)
                        .load(user.getProfileImage())
                        .listener(new RequestListener<Drawable>() {
                            @Override
                            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                                return false;
                            }

                            @Override
                            public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                                Bitmap bitmap = ((BitmapDrawable)resource).getBitmap();
                                String encodedImage = Base64Utils.encodeFileToBase64(bitmap, Bitmap.CompressFormat.PNG, 100);
                                final SharedPreferences.Editor editor = getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE).edit();
                                editor.putString(AdaliveConstants.BASE64_PROFILE_IMAGE, encodedImage);
                                editor.apply();
                                return false;
                            }
                        })
                        .into(btnPhoto);

            }else{
                Glide.with(this)
                        .load(Base64.decode(user.getProfileImage(), Base64.DEFAULT))
                        .into(btnPhoto);
            }

        }

        if (user.getGender().equals("0")) {
            spinnerSexo.setSelection(2);
        }else if (user.getGender().equals("1")) {
            spinnerSexo.setSelection(1);
        }else{
            spinnerSexo.setSelection(0);
        }
    }

    private void selectSpinnerState(Spinner spinner, String myString) {
        for(int i = 0; i < spinner.getCount(); i++){
            if(spinner.getItemAtPosition(i).toString().equals(myString)){
                spinner.setSelection(i);
                break;
            }
        }
    }

    /**
     *
     * @param endereco
     * @param municipio
     * @param estado
     */
    private void populateAdressFields(String endereco, String municipio, String estado, String bairro) {
        edtEndereco.setText(endereco);
        edtMunicipio.setText(municipio);
        edtBairro.setText(bairro);
        String[] mTestArray;
        mTestArray =   getResources().getStringArray(R.array.estados);
        int index = 0;

        for(int i = 0; i < mTestArray.length; i++){
            if(mTestArray[i].equalsIgnoreCase(estado)){
                index = i;
            }
        }

        edtEstado.setSelection(index);
    }

    /**
     * This method to create a map with the all editText that will be validate
     */
    private void createFieldsMap() {
        if(edtToValidate == null){
            edtToValidate = new HashMap<>();
        }
        edtToValidate.put(FieldsValidator.FieldType.CPF,edtCpf);
        edtToValidate.put(FieldsValidator.FieldType.RG,edtRg);
        edtToValidate.put(FieldsValidator.FieldType.NAME,edtNome);
        edtToValidate.put(FieldsValidator.FieldType.LASTNAME,edtSobrenome);
        edtToValidate.put(FieldsValidator.FieldType.BORN,edtDataNasc);
        //edtToValidate.put(FieldsValidator.FieldType.DDD_TEL,edtDddTel);
        //edtToValidate.put(FieldsValidator.FieldType.TELEPHONE,edtTelefone);
        //edtToValidate.put(FieldsValidator.FieldType.DDD_CELL,edtDddCelular);
        //edtToValidate.put(FieldsValidator.FieldType.CELULAR,edtCelular);
        edtToValidate.put(FieldsValidator.FieldType.ZONE,edtCep);
        edtToValidate.put(FieldsValidator.FieldType.ADDRESS,edtEndereco);
        edtToValidate.put(FieldsValidator.FieldType.NUMBER,edtNumero);
        edtToValidate.put(FieldsValidator.FieldType.DISTRICT,edtBairro);
        edtToValidate.put(FieldsValidator.FieldType.CITY,edtMunicipio);
        edtToValidate.put(FieldsValidator.FieldType.EMAIL, edtEmail);
        // edtToValidate.put(FieldsValidator.FieldType.STATE,edtEstado);
    }

    /**
     * Clean all Text Fields
     */
    private void cleanFields() {
        for (Map.Entry<Integer, EditText> entry : edtToValidate.entrySet()) {
            /* Skip CPF */
            if (entry.getValue().getId() == edtCpf.getId()) {
                continue;
            }

            entry.getValue().setText("");
        }
    }

    /*public void blockFieldsCpfNotFilled(){

        edtRg.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtNome.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtDataNasc.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        spinnerSexo.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtDddTel.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtTelefone.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtDddCelular.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtCelular.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtEmail.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtCep.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtEndereco.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtNumero.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtComplemento.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtBairro.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtMunicipio.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtEstado.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign_disable));
        edtRg.setEnabled(false);
        edtNome.setEnabled(false);
        edtDataNasc.setEnabled(false);
        spinnerSexo.setEnabled(false);
        edtDddTel.setEnabled(false);
        edtTelefone.setEnabled(false);
        edtDddCelular.setEnabled(false);
        edtCelular.setEnabled(false);
        edtEmail.setEnabled(false);
        edtCep.setEnabled(false);
        edtEndereco.setEnabled(false);
        edtNumero.setEnabled(false);
        edtComplemento.setEnabled(false);
        edtBairro.setEnabled(false);
        edtMunicipio.setEnabled(false);
        edtEstado.setEnabled(false);
    }

    public void unblockFieldsCpfFilled(){
        edtRg.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtNome.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtDataNasc.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        spinnerSexo.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtDddTel.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtTelefone.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtDddCelular.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtCelular.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtEmail.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtCep.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtEndereco.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtNumero.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtComplemento.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtBairro.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtMunicipio.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtEstado.setBackground(getResources().getDrawable(R.drawable.back_ground_edt_promotion_sign));
        edtRg.setEnabled(true);
        edtNome.setEnabled(true);
        edtDataNasc.setEnabled(true);
        spinnerSexo.setEnabled(true);
        edtDddTel.setEnabled(true);
        edtTelefone.setEnabled(true);
        edtDddCelular.setEnabled(true);
        edtCelular.setEnabled(true);
        edtEmail.setEnabled(true);
        edtCep.setEnabled(true);
        edtEndereco.setEnabled(true);
        edtNumero.setEnabled(true);
        edtComplemento.setEnabled(true);
        edtBairro.setEnabled(true);
        edtMunicipio.setEnabled(true);
        edtEstado.setEnabled(true);
    }*/

    //endregion

    //region Cloud
    /****************************************************CEP LISTENER************************************************/
    @Override
    public void onGetCepSuccess(CepResponse cepResponse) {
        hideProgress();
        populateAdressFields(cepResponse.getLogradouro(),cepResponse.getLocalidade(),
                cepResponse.getUf(),cepResponse.getBairro());
    }

    @Override
    public void onCepError(String message) {
        hideProgress();
        populateAdressFields(null,null,null,null);
    }


    /******************************************************Call back about search customer by cpf ***********************/

    @Override
    public void onUpdateSuccess(User user) {
        hideProgress();
        successDialog(getString(R.string.DIALOG_TITLE_SUCCESS),
                getString(R.string.msg_dialog_sucesso),
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
        );

        UserUtils.saveUser(this, populateUserValues());
    }

    @Override
    public void onUpdateError(String message) {
        hideProgress();
        errorDialog(getString(R.string.DIALOG_TITLE_ERROR),
                message,
                onClickDialogButton(R.id.DIALOG_BUTTON_2)
        );
    }

    @Override
    public View.OnClickListener onClickDialogButton(final int id) {

        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissCustomDialog();
                Intent intent;
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        finish();
                        break;
                    case R.id.DIALOG_BUTTON_2:
                        finish();
                        break;
                }
            }
        };
    }
    //endregion

}
