//
//  PXNetworkManager.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXAccountHolder.h"
#import "PXProblem.h"
#import "PXSolution.h"
#import "PXTag.h"
#import "Config.h"
#import "AFNetworking.h"
#import "AFOAuth2Manager.h"
#import "AFHTTPRequestSerializer+OAuth2.h"

@protocol PXNetworkProtocol;

@interface PXNetworkManager : NSObject {
    AFHTTPRequestOperationManager *_operationManager;
}

@property (strong, nonatomic) AFOAuthCredential *credential;
@property (strong, nonatomic) id <PXNetworkProtocol> delegate;


@property (strong, nonatomic) CLLocation *currentLocation;


#pragma mark - Init Methods

+ (instancetype)sharedStore;


#pragma mark - User Methods

/**
 *用户登录
 *异步函数，返回结果在PXNetworkProtocol的onLoginResult通知
 */
- (void)loginByUsername:(NSString *)username password:(NSString *)pswd;

/**
 *自动登录。通过保存在本地的用户名和密码。
 *异步函数，返回结果在NetworkProtocol的onLoginResult通知
 */
- (void)loginAutomatically;

/**
 *用户通过手机号码注册，会收到验证码
 *异步函数，返回结果在NetworkProtocol的onRegisterByTelOrEmailResult通知
 *@param tel 手机号码
 */
- (void)registerByTelephone:(NSString *)tel;

/**
 *用户通过邮箱注册，会收到验证码
 *异步函数，返回结果在NetworkProtocol的onRegisterByTelOrEmailResult通知
 *@param email  邮箱
 */
- (void)registerByEmail:(NSString *)email;

/**
 *验证用户手机收到的验证码
 *异步函数，返回结果在NetworkProtocol的onVerifyTelOrEmailCodeResult通知
 *@param code 验证码
 */
- (void)verifyTel:(NSString *)tel andCode:(NSString *)code;

/**
 *验证用户邮箱收到的验证码
 *异步函数，返回结果在NetworkProtocol的onVerifyTelOrEmailCodeResult通知
 *@param code 验证码
 */
- (void)verifyEmail:(NSString *)email andCode:(NSString *)code;


/**
 *新用户注册时，验证手机或邮箱成功后，设置新密码。
 *异步函数，返回结果在NetworkProtocol的onSetNewPasswordResult通知
 *@param pswd 新密码
 */
- (void)setNewPassword:(NSString *)pswd;

/**
 *上传当前设备token，用作发送推送。每次启动应用时调用。
 *异步函数，返回结果在NetworkProtocol的onUploadDeviceTokenResult通知
 *@param clientType YES for seeker, NO for solver
 */
- (void)uploadDeviceTokenOfClientType:(BOOL)clientType;


#pragma mark - Functional Methods

#pragma mark Problem

/**
 *获得用户的所有Problems
 *异步函数，返回结果在PXNetworkProtocol的onGetAllProblemsResult通知
 */
- (void)getAllProblems;

/**
 *create new problem
 *异步函数，返回结果在PXNetworkProtocol的onPostNewProblemResult通知
 */
- (void)postNewProblem;

/**
 *发表新提问
 *异步函数，返回结果在NetworkProtocol的onPostNewProblemResult通知
 *@param img    not nil
 *@param desc     optional
 *@param duration     not nil, default as 
 *@param tag       optional
 *@param location   not nil
 */
- (void)postNewProblemByImage:(NSData *)imgData desc:(NSString *)desc duration:(NSNumber *)duration tag:(PXTag *)tag location:(CLLocation *)location;

/**
 *删除Problem
 *异步函数，返回结果在PXNetworkProtocol的onDeleteProblemResult通知
 *@param problem
 */
- (void)deleteProblem:(PXProblem *)problem;

#pragma mark Solution

/**
 *获得用户的所有Solutions
 *异步函数，返回结果在PXNetworkProtocol的onGetAllSolutionsResult通知
 */
- (void)getAllSolutions;

/**
 *回答问题
 *异步函数，返回结果在NetworkProtocol的onPostNewSolutionResult通知
 *@param img    optional
 *@param desc     optional
 *@param price      not nil
 *@param problemID      not nil
 */
- (void)postNewSolutionByImage:(NSData *)imgData desc:(NSString *)desc price:(NSNumber *)price forSolution:(NSString *)solutionID;

/**
 *删除Solution
 *异步函数，返回结果在PXNetworkProtocol的onDeleteSolutionResult通知
 *@param solutionID
 */
- (void)deleteSolution:(NSString *)solutionID;

#pragma mark Tag

/*
 *获得所有tag。
 *异步函数，返回结果在onGetAllTags
 */
- (void)getAllTags;


@end

@protocol PXNetworkProtocol <NSObject>

@optional


#pragma mark - User Methods

/**
 *异步回调，返回登录结果
 *@param error nil表示成功
 */
- (void)onLoginResult:(NSError *)error;


/**
 *异步回调，返回上传设备token的结果
 *@param error  nil表示成功
 */
- (void)onUploadDeviceTokenResult:(NSError *)error;

#pragma mark - Functional Methods

/**
 *异步回调，返回获得用户的所有Problem的结果
 */
- (void)onGetAllProblemsResult:(NSArray *)problems error:(NSError *)error;

/**
 *异步回调，
 */
- (void)onPostNewProblemResult:(NSError *)error;

/**
 *异步回调，返回删除Problem的结果
 */
- (void)onDeleteProblemResult:(NSError *)error;

/**
 *异步回调，返回获得用户的所有Problem的结果
 */
- (void)onGetAllSolutionsResult:(NSArray *)solutions error:(NSError *)error;

/**
 *异步回调，
 */
- (void)onPostNewSolutionResult:(NSError *)error;

/**
 *异步回调，返回删除Problem的结果
 */
- (void)onDeleteSolutionResult:(NSError *)error;



@end
