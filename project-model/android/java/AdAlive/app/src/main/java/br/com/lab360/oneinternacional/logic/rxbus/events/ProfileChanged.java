package br.com.lab360.oneinternacional.logic.rxbus.events;

import br.com.lab360.oneinternacional.logic.model.pojo.user.User;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */

public class ProfileChanged {
    private User user;

    public ProfileChanged(User user) {
        this.user = user;
    }

    public User getUser() {
        return user;
    }
}
