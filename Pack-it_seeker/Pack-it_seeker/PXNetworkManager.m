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
        [shared setClientID:CLIENT_ID
                     secret:SECRET
                      scope:SCOPE
           authorizationURL:AUTH_URL
                   tokenURL:TOKEN_URL
                redirectURL:REDIRECT_URL];
    });
    return shared;
}

- (void)setClientID:(NSString *)clientID secret:(NSString *)secret scope:(NSString *)scope authorizationURL:(NSString *)authURL tokenURL:(NSString *)tokenURL redirectURL:(NSString *)redirectURL{
    [[NXOAuth2AccountStore sharedStore] setClientID:clientID
                                             secret:secret
                                              scope:[NSSet setWithObject:scope]
                                   authorizationURL:[NSURL URLWithString:authURL]
                                           tokenURL:[NSURL URLWithString:tokenURL]
                                        redirectURL:[NSURL URLWithString:redirectURL]
                                      keyChainGroup:KEY_CHAIN_GROUP
                                     forAccountType:FOR_ACCOUNT_TYPE];
}

-(instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret scope:(NSString *)scope authorizationURL:(NSString *)authURL tokenURL:(NSString *)tokenURL redirectURL:(NSString *)redirectURL{
    self = [self init];
    [[NXOAuth2AccountStore sharedStore] setClientID:clientID
                                             secret:secret
                                              scope:[NSSet setWithObject:scope]
                                   authorizationURL:[NSURL URLWithString:authURL]
                                           tokenURL:[NSURL URLWithString:tokenURL]
                                        redirectURL:[NSURL URLWithString:redirectURL]
                                      keyChainGroup:KEY_CHAIN_GROUP
                                     forAccountType:FOR_ACCOUNT_TYPE];
    return self;
}

#pragma mark - User Methods

- (void)loginByUsername:(NSString *)username password:(NSString *)pswd {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:FOR_ACCOUNT_TYPE
                                                              username:username
                                                              password:pswd];
    NSLog(@"requestUserName");
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      //NSLog(@"np.1 observer");
                                                      [[PXAccountHolder sharedInstance] setUsername:username password:pswd];
                                                      
                                                      
                                                      [self parseAccountFromLoginNSNotification:aNotification];
                                                      
                                                      NSError *error = nil;
                                                      if ([self.delegate respondsToSelector:@selector(onLoginResult:)]) {
                                                          [self.delegate onLoginResult:error];
                                                      }
                                                      
                                                      //[self uploadDeviceTokenForNotification];
                                                      
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      
                                                      //[self getTempAccount];
                                                      
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      NSLog(@"login %@", error);
                                                      
                                                      if ([self.delegate respondsToSelector:@selector(onLoginResult:)]) {
                                                          [self.delegate onLoginResult:error];
                                                      }
                                                  }];
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



#pragma mark - Functional Methods
- (void)getAllProblems {
    
    if (_account) {
        [NXOAuth2Request performMethod:@"GET"
                            onResource:[NSURL URLWithString:ON_RESOURCE_URL_TO_GET_PROBLEMS]
                       usingParameters:@{@"API-VERSION": @"v1"}
                           withAccount:_account
                   sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                       NSLog(@"requestProcess:%llu", bytesSend/bytesTotal);
                   }
                       responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                           
                           
                           
                           if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
                               [self.delegate onGetAllProblemsResult:[self parseProblemsFromResponse:responseData] error:nil];
                           }
                           
                       }];
        
    } else{
        if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
            [self.delegate onGetAllProblemsResult:nil error:nil];
        }
    }
}

- (void)postNewProblem {
    
}

- (void)postNewProblemByImage:(UIImage *)img desc:(NSString *)desc duration:(int)duration tag:(PXTag *)tag location:(CLLocation *)location {
    
}

- (void)deleteProblem:(PXProblem *)problem {
    
}


#pragma mark Tag

/*
 *获得所有tag。
 *异步函数，返回结果在onGetAllTags
 */
- (void)getAllTags {
    
}

#pragma mark - Parse Result
/*
 *用户登录，从返回信息中获得token
 */
- (void)parseAccountFromLoginNSNotification:(NSNotification*)aNotification{
    
    NSLog(@"aNotification.userInfo objectForKey:%@", [aNotification.userInfo objectForKey:@"NXOAuth2AccountStoreNewAccountUserInfoKey"]);
    
    
    _account =[aNotification.userInfo objectForKey:@"NXOAuth2AccountStoreNewAccountUserInfoKey"];
    NSLog(@"account token: %@", _account.accessToken);
    NXOAuth2AccessToken *authToken =_account.accessToken;
    
    NSLog(@"accessToken:%@", authToken.accessToken);        //NSString
    NSLog(@"refreshToken:%@", authToken.refreshToken);      //NSString
    NSLog(@"tokenType:%@", authToken.tokenType);            //NSString
    
    NSLog(@"expiresDate:%@", authToken.expiresAt);          //NSDate
}

- (NSArray *)parseProblemsFromResponse:(NSData *)responseData {
    NSArray *result = [self getArrayFromResponse:responseData];
    
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
@end
