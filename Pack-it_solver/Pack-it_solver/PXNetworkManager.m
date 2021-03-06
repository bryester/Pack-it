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
    });
    return shared;
}


- (void)initOpertationManager {
    if (_credential) {
        _operationManager = [AFHTTPRequestOperationManager manager];
        [_operationManager.requestSerializer setAuthorizationHeaderFieldWithCredential:_credential];
        
    }
}

#pragma mark - Setters

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    //
}

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
                                                   
                                                   [self uploadDeviceTokenOfClientType:NO];

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
//    if ([[PXAccountHolder sharedInstance] username] && [[PXAccountHolder sharedInstance] password]) {
//        [self loginByUsername:[[PXAccountHolder sharedInstance] username] password:[[PXAccountHolder sharedInstance] password]];
//    }
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
                       }];
    }
}

- (void)postNewProblem {
    
}

- (void)postNewProblemByImage:(NSData *)imgData desc:(NSString *)desc duration:(NSNumber*)duration tag:(PXTag *)tag location:(CLLocation *)location {
    
    if (!(imgData && desc && duration && tag && location)) {
        
    }
    
    NSNumber *_duration = duration == nil ? @(5) : duration;
    NSString *_desc = desc;
    NSArray *_location = [NSArray arrayWithObjects:@(location.coordinate.longitude), @(location.coordinate.latitude), nil];
    NSString *_tagID = tag.tagID;
    
    
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

#pragma mark Solution

/**
 *获得用户的所有Solutions
 *异步函数，返回结果在PXNetworkProtocol的onGetAllSolutionsResult通知
 */
- (void)getAllSolutions {
    if (_operationManager) {
        
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        [_operationManager GET:ON_RESOURCE_URL_TO_GET_SOLUTIONS
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if ([self.delegate respondsToSelector:@selector(onGetAllSolutionsResult:error:)]) {
                               
                               [self.delegate onGetAllSolutionsResult:[self parseSolutionsFromResponseObject:responseObject]
                                                                error:nil];
                               
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"getAllSolutions Error: %@", error);
                       }];
    }
}

/**
 *回答问题
 *异步函数，返回结果在NetworkProtocol的onPostNewSolutionResult通知
 *@param img    optional
 *@param desc     optional
 *@param price      not nil
 *@param problemID      not nil
 */
- (void)postNewSolutionByImage:(NSData *)imgData desc:(NSString *)desc price:(NSNumber *)price forSolution:(NSString *)solutionID {
    
    if (!solutionID) {
        return;
    }
    
    NSString *_desc = desc;
    
    NSMutableDictionary *solution = [NSMutableDictionary dictionary];
    [solution setObject:price forKey:@"price"];
    [solution setObject:_desc forKey:@"description"];
    //[problem setObject:imgData forKey:@"picture"];
    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    [finalDictionary setObject:solution forKey:@"solution"];
    
    NSLog(@"quest dictionary:%@", finalDictionary);
    
    if (_credential) {
        
        
        
        
        [_operationManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"API-VERSION"];
        
        
        // need to pass the full URLString instead of just a path like when using 'PUT' or 'POST' convenience methods
        NSString *URLString = [NSString stringWithFormat:ON_RESOURCE_URL_TO_POST_SOLUTION_FOR_PROBLEM, solutionID];
        NSMutableURLRequest *request = [_operationManager.requestSerializer
                                        multipartFormRequestWithMethod:@"PUT"
                                        URLString:URLString
                                        parameters:finalDictionary
                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            if (imgData) {
                                                [formData appendPartWithFileData:imgData name:@"solution[picture]" fileName:@"iim.png" mimeType:@"image/jpeg"];
                                            }
            
        }
                                        error:nil];
        
        // 'PUT' and 'POST' convenience methods auto-run, but HTTPRequestOperationWithRequest just
        // sets up the request. you're respondsible for firing it.
        AFHTTPRequestOperation *requestOperation = [_operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"postNewSolutionByImage responseHandler:%@", responseObject);
            if ([self.delegate respondsToSelector:@selector(onPostNewSolutionResult:)]) {
                [self.delegate onPostNewSolutionResult:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"postNewSolutionByImage Error:%@", error);
            if ([self.delegate respondsToSelector:@selector(onPostNewSolutionResult:)]) {
                [self.delegate onPostNewSolutionResult:error];
            }
            
        }];
        
        // fire the request
        [requestOperation start];
        
        
        
        
        
//        [_operationManager POST:[NSString stringWithFormat:ON_RESOURCE_URL_TO_POST_SOLUTION_FOR_PROBLEM, solutionID]
//                     parameters:finalDictionary
//      constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//          [formData appendPartWithFileData:imgData name:@"solution[picture]" fileName:@"iim.png" mimeType:@"image/jpeg"];
//      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//          
//          
//          NSLog(@"postNewSolutionByImage responseHandler:%@", responseObject);
//          if ([self.delegate respondsToSelector:@selector(onPostNewSolutionResult:)]) {
//              [self.delegate onPostNewSolutionResult:nil];
//          }
//          
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          NSLog(@"postNewSolutionByImage Error:%@", error);
//          if ([self.delegate respondsToSelector:@selector(onPostNewSolutionResult:)]) {
//              [self.delegate onPostNewSolutionResult:error];
//          }
//      }];
        
    }
}

/**
 *删除Solution
 *异步函数，返回结果在PXNetworkProtocol的onDeleteSolutionResult通知
 *@param solutionID
 */
- (void)deleteSolution:(NSString *)solutionID {
    
}


#pragma mark Tag

/*
 *获得所有tag。
 *异步函数，返回结果在onGetAllTags
 */
- (void)getAllTags {
    
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
        [problems addObject:p];
    }
    return problems;
}

- (NSArray *)parseSolutionsFromResponseObject:(id)responseObject {
    NSArray *result = [self getArrayFromResponseObject:responseObject];
    
    if (!result) {
        return nil;
    }
    
    NSMutableArray *solutions = [NSMutableArray new];
    NSError* err = nil;
    for (NSDictionary *dic in result) {
        PXSolution *s = [[PXSolution alloc] initWithDictionary:dic error:&err];
        [solutions addObject:s];
    }
    return solutions;
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
