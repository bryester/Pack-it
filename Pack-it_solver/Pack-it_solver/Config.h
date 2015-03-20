//
//  Config.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/24/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#ifndef Pack_it_seeker_Config_h
#define Pack_it_seeker_Config_h


#pragma mark - Network Request


#define BASE_URL @"http://120.24.163.76:8000"

//[NSString stringWithFormat:@"%@%@%@", BASE_URL, xxx, xxx];
// xxx == @"/abc";


#define CLIENT_ID       @"d92e1ba0d9e5b8dbb15cb9ce329294c8e777ea5131f5f7aa9cd92d3188845217"
#define SECRET          @"aba811f93c72f582882b9f3c7f03b03b7fde3479568f437e4552a11e5e75a747"
#define ON_RESOURCE_BASE64_CODE_FOR_CLIENTID_AND_SECRET @"Basic ZDkyZTFiYTBkOWU1YjhkYmIxNWNiOWNlMzI5Mjk0YzhlNzc3ZWE1MTMxZjVmN2FhOWNkOTJkMzE4ODg0NTIxNzphYmE4MTFmOTNjNzJmNTgyODgyYjlmM2M3ZjAzYjAzYjdmZGUzNDc5NTY4ZjQzN2U0NTUyYTExZTVlNzVhNzQ3"

#define REDIRECT_URL            @"urn:ietf:wg:oauth:2.0:oob"
#define FOR_ACCOUNT_TYPE        @""
#define SCOPE                   @"public write admin"
#define KEY_CHAIN_GROUP         @""

#define AUTH_URL                    BASE_URL@"/oauth/authorize"
#define TOKEN_URL                   BASE_URL@"/oauth/token"

//用户注册

#define ON_RESOURCE_URL_FOR_TOKEN_WITHOUT_USER          BASE_URL@"/oauth/token"
#define ON_RESOURCE_URL_TO_POST_USER_TELPHONE_OR_EMAIL  BASE_URL@"/me"
#define ON_RESOURCE_URL_TO_PUT_NEW_PASSWORD             BASE_URL@"/me"


#define ON_RESOURCE_URL_TO_GET_PROBLEMS             BASE_URL@"/problems"
#define ON_RESOURCE_URL_TO_POST_PROBLEM             BASE_URL@"/problems"

#define ON_RESOURCE_URL_TO_GET_SOLUTIONS                    BASE_URL@"/solutions"
#define ON_RESOURCE_URL_TO_POST_SOLUTION_FOR_PROBLEM        BASE_URL@"/solutions/%@"

#define ON_RESOURCE_URL_TO_PUT_TOKEN             BASE_URL@"/profiles/notification_profile"


#pragma mark - BaiduMap

#define BaiduMap_Key    @"Zq1APR1rIS7k94yOFNh5Nt57"

#endif
