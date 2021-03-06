//
//  PXNetworkManager.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXNetworkManager.h"

@implementation PXNetworkManager

#pragma mark - Init Methods

+ (instancetype)sharedStore{
    static PXNetworkManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [PXNetworkManager new];
//        [shared setClientID:CLIENT_ID
//                     secret:SECRET
//                      scope:SCOPE
//           authorizationURL:AUTH_URL
//                   tokenURL:TOKEN_URL
//                redirectURL:REDIRECT_URL];
    });
    return shared;
}

//- (void)setClientID:(NSString *)clientID secret:(NSString *)secret scope:(NSString *)scope authorizationURL:(NSString *)authURL tokenURL:(NSString *)tokenURL redirectURL:(NSString *)redirectURL{
//    [[NXOAuth2AccountStore sharedStore] setClientID:clientID
//                                             secret:secret
//                                              scope:[NSSet setWithObject:scope]
//                                   authorizationURL:[NSURL URLWithString:authURL]
//                                           tokenURL:[NSURL URLWithString:tokenURL]
//                                        redirectURL:[NSURL URLWithString:redirectURL]
//                                      keyChainGroup:KEY_CHAIN_GROUP
//                                     forAccountType:FOR_ACCOUNT_TYPE];
//}

//-(instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret scope:(NSString *)scope authorizationURL:(NSString *)authURL tokenURL:(NSString *)tokenURL redirectURL:(NSString *)redirectURL{
//    self = [self init];
//    
//    
//    
//    [[NXOAuth2AccountStore sharedStore] setClientID:clientID
//                                             secret:secret
//                                              scope:[NSSet setWithObject:scope]
//                                   authorizationURL:[NSURL URLWithString:authURL]
//                                           tokenURL:[NSURL URLWithString:tokenURL]
//                                        redirectURL:[NSURL URLWithString:redirectURL]
//                                      keyChainGroup:KEY_CHAIN_GROUP
//                                     forAccountType:FOR_ACCOUNT_TYPE];
//    return self;
//}

- (void)initOpertationManager {
    if (_credential) {
        _operationManager = [AFHTTPRequestOperationManager manager];
        [_operationManager.requestSerializer setAuthorizationHeaderFieldWithCredential:_credential];
        
    }
}

#pragma mark - Setters
//
//- (void)setCurrentLocation:(CLLocation *)currentLocation {
//    self.currentLocation = currentLocation;
//}

#pragma mark - User Methods

- (void)loginByUsername:(NSString *)username password:(NSString *)pswd {
    

    AFOAuth2Manager *OAuth2Manager =
    [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]
                                    clientID:CLIENT_ID
                                      secret:SECRET];
    
    [OAuth2Manager authenticateUsingOAuthWithURLString:@"/oauth/token"
                                              username:username
                                              password:pswd
                                                 scope:SCOPE
                                               success:^(AFOAuthCredential *credential) {
                                                   NSLog(@"Token: %@", credential.accessToken);
                                                   [[PXAccountHolder sharedInstance] setUsername:username password:pswd];
                                                   //[self parseAccountFromLoginNSNotification:aNotification];
                                                   _credential = credential;
                                                   [self initOpertationManager];
                                                   NSError *error = nil;
                                                   if ([self.delegate respondsToSelector:@selector(onLoginResult:)]) {
                                                       [self.delegate onLoginResult:error];
                                                   }
                                                   
                                                   //Automatically download tags after successful login.
                                                   [self getAllTags];
                                                   
                                                   [self uploadDeviceTokenOfClientType:YES];

                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"login %@", error);
                                                   if ([self.delegate respondsToSelector:@selector(onLoginResult:)]) {
                                                       [self.delegate onLoginResult:error];
                                                   }
                                               }];
    
//    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:FOR_ACCOUNT_TYPE
//                                                              username:username
//                                                              password:pswd];
//    NSLog(@"requestUserName");
//    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
//                                                      object:[NXOAuth2AccountStore sharedStore]
//                                                       queue:nil
//                                                  usingBlock:^(NSNotification *aNotification){
//                                                      //NSLog(@"np.1 observer");
//                                                      [[PXAccountHolder sharedInstance] setUsername:username password:pswd];
//                                                      
//                                                      
//                                                      [self parseAccountFromLoginNSNotification:aNotification];
//                                                      
//                                                      NSError *error = nil;
//                                                      if ([self.delegate respondsToSelector:@selector(onLoginResult:)]) {
//                                                          [self.delegate onLoginResult:error];
//                                                      }
//                                                      
//                                                      //[self uploadDeviceTokenForNotification];
//                                                      
//                                                  }];
//    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
//                                                      object:[NXOAuth2AccountStore sharedStore]
//                                                       queue:nil
//                                                  usingBlock:^(NSNotification *aNotification){
//                                                      
//                                                      //[self getTempAccount];
//                                                      
//                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
//                                                      NSLog(@"login %@", error);
//                                                      
//                                                      if ([self.delegate respondsToSelector:@selector(onLoginResult:)]) {
//                                                          [self.delegate onLoginResult:error];
//                                                      }
//                                                  }];
}

- (void)loginAutomatically {
    if ([[PXAccountHolder sharedInstance] username] && [[PXAccountHolder sharedInstance] password]) {
        [self loginByUsername:[[PXAccountHolder sharedInstance] username] password:[[PXAccountHolder sharedInstance] password]];
    }
}


- (void)registerByTelephone:(NSString *)tel {
    
}

- (void)registerByEmail:(NSString *)email {
    
}

- (void)verifyTel:(NSString *)tel andCode:(NSString *)code {
    
}

- (void)verifyEmail:(NSString *)email andCode:(NSString *)code {
    
}

- (void)setNewPassword:(NSString *)pswd {
    
}

/**
 *上传当前设备token，用作发送推送。每次启动应用时调用。
 *异步函数，返回结果在NetworkProtocol的onUploadDeviceTokenResult通知
 */
- (void)uploadDeviceTokenOfClientType:(BOOL)clientType {
    
    NSString *token = [PXAccountHolder sharedInstance].token;
    
    if (_operationManager && token) {
        
        NSLog(@"upload token:%@", token);
        
        NSMutableDictionary *profile = [NSMutableDictionary dictionary];
        
        if (clientType) {       //seeker client
            [profile setObject:token forKey:@"seeker_token"];
            [profile setObject:@"ios" forKey:@"seeker_type"];
        } else {                //solver client
            [profile setObject:token forKey:@"solver_token"];
            [profile setObject:@"ios" forKey:@"solver_type"];
        }
        
        NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
        [finalDictionary setObject:profile forKey:@"profile"];
        
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        [_operationManager PUT:ON_RESOURCE_URL_TO_PUT_TOKEN
                    parameters:finalDictionary
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"onUploadDeviceTokenResult Success: %@", operation);
                           
                           if ([self.delegate respondsToSelector:@selector(onUploadDeviceTokenResult:)]) {
                               [self.delegate onUploadDeviceTokenResult:nil];
                           }
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"onUploadDeviceTokenResult Error: %@", error);
                           if ([self.delegate respondsToSelector:@selector(onUploadDeviceTokenResult:)]) {
                               [self.delegate onUploadDeviceTokenResult:error];
                               
                               //If fail to upload token, then reupload for every 10 seconds.
                               [NSThread sleepForTimeInterval:10];
                               [self uploadDeviceTokenOfClientType:YES];
                           }
                           
                       }];
    } else {
        if ([self.delegate respondsToSelector:@selector(onUploadDeviceTokenResult:)]) {
            [self.delegate onUploadDeviceTokenResult:[NSError new]];
        }
    }

}



#pragma mark - Functional Methods
- (void)getAllProblems {
    
    if (_operationManager) {

        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        [_operationManager GET:ON_RESOURCE_URL_TO_GET_PROBLEMS
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
                               [self.delegate onGetAllProblemsResult:[self parseProblemsFromResponseObject:responseObject] error:nil];
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"getAllProblems Error: %@", error);
                           if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
                               [self.delegate onGetAllProblemsResult:nil error:error];
                           }
                       }];
    } else {
        if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
            [self.delegate onGetAllProblemsResult:nil error:[NSError new]];
        }
    }
}

/**
 *获得specific problem
 *异步函数，返回结果在PXNetworkProtocol的onGetProblemResult通知
 */
- (void)getProblemByID:(NSString *)problemID {
    
    if (_operationManager) {
        
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        [_operationManager GET:[NSString stringWithFormat:ON_RESOURCE_URL_TO_GET_PROBLEM_BY_ID, problemID]
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if ([self.delegate respondsToSelector:@selector(onGetProblemByIDResult:error:)]) {
                               [self.delegate onGetProblemByIDResult:[self parseSingleProblemFromResponseObject:responseObject] error:nil];
                           }
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"onGetProblemByIDResult Error: %@", error);
                           if ([self.delegate respondsToSelector:@selector(onGetProblemByIDResult:error:)]) {
                               [self.delegate onGetProblemByIDResult:nil error:error];
                           }
                       }];
    } else {
        if ([self.delegate respondsToSelector:@selector(onGetProblemByIDResult:error:)]) {
            [self.delegate onGetProblemByIDResult:nil error:[NSError new]];
        }
    }
    
}

/**
 *alter the tag of a specific problem
 *异步函数，返回结果在PXNetworkProtocol的onPutNewTagResult通知
 */
- (void)putNewTag:(NSString *)tagID forProblem:(NSString *)problemID {
    if (_operationManager && tagID) {
        
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        //[_operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        NSMutableDictionary *problem = [NSMutableDictionary dictionary];
        [problem setObject:tagID forKey:@"tag"];
        
        NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
        [finalDictionary setObject:problem forKey:@"problem"];

        
        [_operationManager PUT:[NSString stringWithFormat:ON_RESOURCE_URL_TO_PUT_TAG_FOR_PROBLEM, problemID]
                    parameters:finalDictionary
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if ([self.delegate respondsToSelector:@selector(onPutNewTagResult:)]) {
                               [self.delegate onPutNewTagResult:nil];
                           }
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"putNewTag Error: %@", error);
                           if ([self.delegate respondsToSelector:@selector(onPutNewTagResult:)]) {
                               [self.delegate onPutNewTagResult:error];
                           }
                           
                       }];
    } else {
        if ([self.delegate respondsToSelector:@selector(onPutNewTagResult:)]) {
            [self.delegate onPutNewTagResult:[NSError new]];
        }
    }
}

- (void)postNewProblemByImage:(NSData *)imgData desc:(NSString *)desc duration:(NSNumber*)duration tag:(PXTag *)tag location:(CLLocation *)location {
    
    if (!(imgData && desc && duration && tag && location)) {
        
    }
    
    NSNumber *_duration = duration == nil ? @(5) : duration;
    NSString *_desc = desc;
    NSArray *_location = [NSArray arrayWithObjects:@(location.coordinate.longitude), @(location.coordinate.latitude), nil];
    
    NSString *_tagID;
    if (!tag) {
        _tagID = @"";
    } else {
        _tagID = tag.tagID;
    }
    
    
    
    NSMutableDictionary *problem = [NSMutableDictionary dictionary];
    [problem setObject:_duration forKey:@"duration"];
    [problem setObject:_location forKey:@"location"];
    [problem setObject:_desc forKey:@"description"];
    if (_tagID) {
        [problem setObject:_tagID forKey:@"tag"];
    } else {
        [problem setObject:@"" forKey:@"tag"];
    }
    //[problem setObject:imgData forKey:@"picture"];
    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    [finalDictionary setObject:problem forKey:@"problem"];
    
    NSLog(@"quest dictionary:%@", finalDictionary);
    //NSString *jsonString = [self convertToJSONStringFromDictionary:finalDictionary];
    
    if (_credential) {
        //_operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //[_operationManager.requestSerializer setAuthorizationHeaderFieldWithCredential:_credential];
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        [_operationManager POST:ON_RESOURCE_URL_TO_POST_PROBLEM
                     parameters:finalDictionary
      constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          [formData appendPartWithFileData:imgData name:@"problem[picture]" fileName:@"iim.png" mimeType:@"image/jpeg"];
      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSLog(@"postNewProblemByImage responseHandler:%@", responseObject);
          if ([self.delegate respondsToSelector:@selector(onPostNewProblemResult:)]) {
              [self.delegate onPostNewProblemResult:nil];
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"postNewProblemByImage Error:%@", error);
          if ([self.delegate respondsToSelector:@selector(onPostNewProblemResult:)]) {
              [self.delegate onPostNewProblemResult:error];
          }
      }];
        
    } else {
        if ([self.delegate respondsToSelector:@selector(onPostNewProblemResult:)]) {
            [self.delegate onPostNewProblemResult:[NSError new]];
        }
    }
    
//    [NXOAuth2Request performMethod:@"POST"
//                        onResource:[NSURL URLWithString:ON_RESOURCE_URL_TO_POST_PROBLEM]
//                   usingParameters:@{@"API-VERSION": @"v1", @"Content-Type": @"application/json", @"data": jsonString, @"file": w}
//                       withAccount:_account
//               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
//                   NSLog(@"requestProcess:%llu", bytesSend/bytesTotal);
//               }
//                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
//                       
//                       NSLog(@"responseHandler:%@", response);
//                       
//                   }];
    
//    [NXOAuth2Request performMethod:@"POST"
//                        onResource:[NSURL URLWithString:ON_RESOURCE_URL_TO_POST_PROBLEM]
//                   usingParameters:@{@"file": w}
//                       withAccount:_account
//               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
//                   NSLog(@"requestProcess:%llu", bytesSend/bytesTotal);
//               }
//                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
//                       
//                       NSLog(@"responseHandler:%@", response);
//                       
//                   }];
    
}

- (void)deleteProblem:(PXProblem *)problem {
    
}


#pragma mark Tag

/*
 *获得所有tag。
 *异步函数，返回结果在onGetAllTags
 */
- (void)getAllTags {
    if (_operationManager) {
        
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        [_operationManager GET:ON_RESOURCE_URL_TO_GET_TAGS
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSArray *tags = [self parseTagsFromResponseObject:responseObject];
                           
                           if (tags && tags.count > 0) {
                               [[PXTagHolder sharedInstance] setTags:tags];
                           }
                           
                           
                           if ([self.delegate respondsToSelector:@selector(onGetAllTagsResult:error:)]) {
                               
                               [self.delegate onGetAllTagsResult:tags error:nil];
                               
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSLog(@"onGetAllTagsResult Error: %@", error);
                           
                           if ([self.delegate respondsToSelector:@selector(onGetAllTagsResult:error:)]) {
                               [self.delegate onGetAllTagsResult:nil error:error];
                           }
                       }];
    }
}

#pragma mark - Parse Result

- (NSArray *)parseProblemsFromResponseObject:(id)responseObject {
    NSArray *result = [self getArrayFromResponseObject:responseObject];
    
    if (!result) {
        return nil;
    }
    
    NSMutableArray *problems = [NSMutableArray new];
    NSError* err = nil;
    for (NSDictionary *dic in result) {
        PXProblem *p = [[PXProblem alloc] initWithDictionary:dic error:&err];
        if (p && p.status) {
            if ([p.status isEqualToString:@"waiting"]) {
                p.status_CHN = @"待解决";
            } else if ([p.status isEqualToString:@"solved"]) {
                p.status_CHN = @"已解决";
            } else if ([p.status isEqualToString:@"failed"]) {
                p.status_CHN = @"已过期";
            }
        }
        [problems addObject:p];
    }
    return problems;
}

- (PXProblem *)parseSingleProblemFromResponseObject:(id)responseObject {
    NSDictionary *result = [self getDictionaryFromResponseObject:responseObject];
    
    if (!result) {
        return nil;
    }
    
    PXProblem *problem = [[PXProblem alloc] initWithDictionary:result error:nil];
    if (problem && problem.status) {
        if ([problem.status isEqualToString:@"waiting"]) {
            problem.status_CHN = @"待解决";
        } else if ([problem.status isEqualToString:@"solved"]) {
            problem.status_CHN = @"已解决";
        } else if ([problem.status isEqualToString:@"failed"]) {
            problem.status_CHN = @"已过期";
        }
    }
    return problem;
}

- (NSArray *)parseTagsFromResponseObject:(id)responseObject {
    NSArray *result = [self getArrayFromResponseObject:responseObject];
    
    if (!result) {
        return nil;
    }
    
    NSMutableArray *tags = [NSMutableArray new];
    NSError* err = nil;
    for (NSDictionary *dic in result) {
        PXTag *tag = [[PXTag alloc] initWithDictionary:dic error:&err];
        [tags addObject:tag];
    }
    return tags;
}


#pragma mark - Common Methods
/*
 *通用方法，将网络请求返回的data转换成dictionary
 */
- (NSDictionary *)getDictionaryFromResponse:(NSData *)data{
    if (!data) {
        return nil;
    }
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:&error];
    
    if(error) {
        NSLog(@"JSON was malformed, act appropriately here");
        return nil;
    }
    
    NSDictionary *result;
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        result = object;
    }
    else
    {
        NSLog(@"result is not a dictionary");
    }
    return result;
}

- (NSArray *)getArrayFromResponse:(NSData *)data{
    NSError *error = nil;
    if (!data) {
        return nil;
    }
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:&error];
    
    if(error) {
        NSLog(@"JSON was malformed, act appropriately here");
        return nil;
    }
    
    NSArray *result;
    
    if([object isKindOfClass:[NSArray class]])
    {
        result = object;
    }
    else
    {
        NSLog(@"result is not an array");
    }
    return result;
}

- (NSDictionary *)getDictionaryFromResponseObject:(id)responseObject{

    NSDictionary *result;
    
    if([responseObject isKindOfClass:[NSDictionary class]])
    {
        result = responseObject;
    }
    else
    {
        NSLog(@"result is not a dictionary");
    }
    return result;
}

- (NSArray *)getArrayFromResponseObject:(id)responseObject{

    NSArray *result;
    
    if([responseObject isKindOfClass:[NSArray class]])
    {
        result = responseObject;
    }
    else
    {
        NSLog(@"result is not an array");
    }
    return result;
}

/*
 *通用方法，将dictionary转换成json格式的string
 */
- (NSString *)convertToJSONStringFromDictionary:(NSDictionary*)dic{
    if (!dic) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
@end
