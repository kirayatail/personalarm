//
//  NetworkConstants.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-02.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#ifndef PersonAlarm_NetworkConstants_h
#define PersonAlarm_NetworkConstants_h
//Constants used by HTTPController
typedef enum WebServiceResponses{
    WEBSERVICE_SUCCESS = 1,
    WEBSERVICE_FAILURE_USER_INFO_NOT_VALID = 2,
    WEBSERVICE_FAILUE_CONNECTION_ERROR = 3
}WebServiceResponse;

//Parse related
#define PARSECLASS_FRIEND_REQUEST @"FriendRequest"
#define RELATIONS_FRIEND @"Friends"
#define FRIEND_REQUEST_SENDER @"Sender"
#define FRIEND_REQUEST_ACCEPTED @"Accepted"
#define FRIEND_REQUEST_RECEIVER @"Receiver"

//FriendShipsDeleted
#define PARSECLASS_FRIENDSHIPS_DELETED @"FriendshipsDeleted"
#define FRIENDSHIPS_DELETED_SENDER @"FriendToBeDeleted"
#define FRIENDSHIPS_DELETED_RECEIVER @"FriendThatHasBeenDeleted"

#define PARSECLASS_SESSION @"Session"
#define SESSION_RECEIVER @"Receiver"
#define SESSION_SENDER @"Sender"
#define SESSION_ACCEPTED @"Accepted"
#define SESSION_SENDER_LOCATION_LONGITUD @"Location_Longitud"
#define SESSION_SENDER_LOCATION_LATITUD @"Location_Latitud"

//Used in NSUserDefaults, YES if the user has started a Session
#define PA_NSUDEFAULTS_ACTIVESESSION @"SessionActive"



#endif
