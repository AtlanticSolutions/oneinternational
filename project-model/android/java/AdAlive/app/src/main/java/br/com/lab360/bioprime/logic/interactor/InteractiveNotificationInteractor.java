package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.StatusResponse;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationRequest;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.ui.activity.timeline.TimelineActivity;
import br.com.lab360.bioprime.utils.UserUtils;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Victor Santiago on 21/01/2017.
 */

public class InteractiveNotificationInteractor {

    public static void postNotificationAction(final Context context, String notificationId) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        User user = UserUtils.loadUser(context);
        String appUserId = String.valueOf(user.getId());

        NotificationRequest notificationRequest = new NotificationRequest(notificationId, appUserId);

        adaliveApi.postNotificationAction(notificationRequest)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<StatusResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {

                        Log.e(AdaliveConstants.ERROR, AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(StatusResponse statusResponse) {

                        Intent intent = new Intent(context, TimelineActivity.class);
                        intent.putExtra(AdaliveConstants.NOTIFICATION_MESSAGE, statusResponse.getMessage());

                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK
                                | Intent.FLAG_ACTIVITY_NO_ANIMATION);
                        context.startActivity(intent);

                    }
                });

    }

}
