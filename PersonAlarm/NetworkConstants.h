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
typedef enum WebServiceResposes{
    WEBSERVICE_SUCCESS = 1,
    WEBSERVICE_FAILURE_USER_INFO_NOT_VALID = 2,
    WEBSERVICE_FAILUE_CONNECTION_ERROR = 3
}WebServiceResponse;



#endif
