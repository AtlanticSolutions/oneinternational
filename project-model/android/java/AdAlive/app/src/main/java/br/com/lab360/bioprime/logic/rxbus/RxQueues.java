package br.com.lab360.bioprime.logic.rxbus;

import net.jokubasdargis.rxbus.Queue;

import br.com.lab360.bioprime.logic.rxbus.events.BadgeMessageUpdateEvent;
import br.com.lab360.bioprime.logic.rxbus.events.ChatEnterEvent;
import br.com.lab360.bioprime.logic.rxbus.events.ChatExitEvent;
import br.com.lab360.bioprime.logic.rxbus.events.DownloadFileDeletedEvent;
import br.com.lab360.bioprime.logic.rxbus.events.DownloadFileFinishedEvent;
import br.com.lab360.bioprime.logic.rxbus.events.FcmMessageReceivedEvent;
import br.com.lab360.bioprime.logic.rxbus.events.EventChanged;
import br.com.lab360.bioprime.logic.rxbus.events.ProfileChanged;
import br.com.lab360.bioprime.logic.rxbus.events.InteractiveNotification;
import br.com.lab360.bioprime.logic.rxbus.events.LikeRequestFinishedEvent;
import br.com.lab360.bioprime.logic.rxbus.events.SectorMessageReceivedEvent;
import br.com.lab360.bioprime.logic.rxbus.events.SingleChatBlockEvent;
import br.com.lab360.bioprime.logic.rxbus.events.SponsorTitleEvent;
import br.com.lab360.bioprime.logic.rxbus.events.TimelineActionEvent;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */

public final class RxQueues {
    public static final Queue<EventChanged> USER_EVENT_CHANGED_QUEUE = Queue.of(EventChanged.class).build();
    public static final Queue<ProfileChanged> USER_PROFILE_CHANGED_QUEUE = Queue.of(ProfileChanged.class).build();
    public static final Queue<FcmMessageReceivedEvent> FCM_MESSAGE_RECEIVED = Queue.of(FcmMessageReceivedEvent.class).build();
    public static final Queue<SectorMessageReceivedEvent> SECTOR_MESSAGE_RECEIVED = Queue.of(SectorMessageReceivedEvent.class).build();

    public static final Queue<ChatExitEvent> CHAT_EXIT_BTN_EVENT = Queue.of(ChatExitEvent.class).build();
    public static final Queue<ChatEnterEvent> CHAT_ENTER_BTN_EVENT = Queue.of(ChatEnterEvent.class).build();

    public static final Queue<SingleChatBlockEvent> SINGLE_CHAT_BLOCK_BTN_EVENT = Queue.of(SingleChatBlockEvent.class).build();

    public static final Queue<TimelineActionEvent> TIMELINE_ACTION = Queue.of(TimelineActionEvent.class).build();
    public static final Queue<LikeRequestFinishedEvent> LIKE_REQUEST_FINISHED_EVENT = Queue.of(LikeRequestFinishedEvent.class).build();

    public static final Queue<SponsorTitleEvent> SPONSORS_TITLE_EVENT = Queue.of(SponsorTitleEvent.class).build();

    public static final Queue<InteractiveNotification> NOTIFICATION_ACTIONS_QUEUE = Queue.of(InteractiveNotification.class).build();

    public static final Queue<BadgeMessageUpdateEvent> BADGE_UPDATE_EVENT = Queue.of(BadgeMessageUpdateEvent.class).build();

    public static final Queue<DownloadFileFinishedEvent> DOWNALOAD_FILE_COMPLETED = Queue.of(DownloadFileFinishedEvent.class).build();
    public static final Queue<DownloadFileDeletedEvent> DELETE_DOWNALOADED_FILE = Queue.of(DownloadFileDeletedEvent.class).build();


}
