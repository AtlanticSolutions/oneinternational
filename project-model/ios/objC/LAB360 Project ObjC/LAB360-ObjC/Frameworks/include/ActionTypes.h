//
//  ActionTypes.h
//  AdAlive
//
//  Created by Lab360 on 27/10/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

/**
 * \enum ActionTypes
 * \brief An enumeration with action types.
 */
typedef enum : NSUInteger
{
    AudioAction,                /**< Audio action item */
    ARAvatarAction,             /**< Avatar action item */
    AROfferAction,              /**< Offer action item */
    EmailAction,                /**< Email action item */
    InfoAction,                 /**< Info action item */
    LikeAction,                 /**< Like action item */
    LinkAction,                 /**< Link action item */
    MaskAction,                 /**< Mask action item */
    OrderAction,                /**< Order action item */
    PhoneAction,                /**< Phone action item */
    PriceAction,                /**< Price action item */
    PromotionAction,            /**< Promotion action item */
    SurveyAction,               /**< Survey action item */
    TweetAction,                /**< Tweet action item */
    VideoAction,                /**< Video action item */
    VideoARAction,              /**< Video AR action item */
    VideoARTransparentAction,   /**< Video AR transparent action item */
	AppLinkAction				/**< Link to app action item */
} ActionTypes;


/**
 * \enum ActionFilters
 * \brief An enumeration with action filters.
 */
typedef enum : NSInteger
{
    OldestAction,       /**< The oldest action filter item */
    NewestAction,       /**< The newest action filter item */
    OldestAutoAction,   /**< The oldest autolaunch action filter item */
    NewestAutoAction,   /**< The newest autolaunch action filter item */
}ActionFilters;
