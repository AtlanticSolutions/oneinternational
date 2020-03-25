package br.com.lab360.bioprime.logic.rxbus.events;

import br.com.lab360.bioprime.logic.model.pojo.user.User;

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
