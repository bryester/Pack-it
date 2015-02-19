//
//  PXNetworkManager.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXProblem.h"
#import "PXSolution.h"

@protocol PXNetworkProtocol;

@interface PXNetworkManager : NSObject

@property (strong, nonatomic) id <PXNetworkProtocol> delegate;


#pragma mark - Init Methods

+ (instancetype)sharedStore;


#pragma mark - User Methods

/**
 *用户登录
 *异步函数，返回结果在NetworkProtocol的onLoginResult通知
 */
- (void)loginByUsername:(NSString *)username password:(NSString *)pswd;


#pragma mark - Functional Methods
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
 *删除Problem
 *异步函数，返回结果在PXNetworkProtocol的onDeleteProblemResult通知
 *@param problem
 */
- (void)deleteProblem:(PXProblem *)problem;


@end

@protocol PXNetworkProtocol <NSObject>

@optional


#pragma mark - User Methods

/**
 *异步回调，返回登录结果
 *@param error nil表示成功
 */
- (void)onLoginResult:(NSError *)error;

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


@end
