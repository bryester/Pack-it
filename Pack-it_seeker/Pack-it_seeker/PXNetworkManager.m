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
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:22.0 longitude:22.0];
    PXProblem *problem = [PXProblem new];
    
    problem.pictureURL = @"xxx";
    
    problem.location = nil;
    problem.status = @"yStatus";
    problem.duration = 1;
    problem.pictureURL = @"http://image.baidu.com/channel?c=%E6%B1%BD%E8%BD%A6&t=%E5%85%A8%E9%83%A8&s=0";
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:problem];
    
    if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
        [self.delegate onGetAllProblemsResult:array error:nil];
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
@end
