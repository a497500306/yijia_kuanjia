//
//  MLInterface.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/7.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


@interface MLInterface : NSObject
singleton_interface(MLInterface);
/**
 *  首页; 诊断方案
 */
@property(nonatomic, copy)NSString *getPatientHome;
/**
 *  首页; 录入血糖
 */
@property(nonatomic, copy)NSString *saveGlycemicRecord;
/**
 *  首页; 查看历史
 */
@property(nonatomic, copy)NSString *getPatientHistory;
/**
 *  消息; 消息首页
 */
@property(nonatomic, copy)NSString *getfriendList;
/**
 *  消息; 添加联系人
 */
@property(nonatomic, copy)NSString *addFriendRelation;
/**
 *  消息; 附近医生
 */
@property(nonatomic, copy)NSString *getDoctorList;
/**
 *  消息; 医生详细
 */
@property(nonatomic, copy)NSString *getDoctorDetail;
/**
 *  消息; 对医生发表评论
 */
@property(nonatomic, copy)NSString *saveMessage;
/**
 *  消息; 附近营养师
 */
@property(nonatomic, copy)NSString *getDoctorListDietitian;
/**
 *  消息; 对营养师发表评论
 */
@property(nonatomic, copy)NSString *saveMessageDietitian;
/**
 *  消息; 同病人
 */
@property(nonatomic, copy)NSString *getPatientList;
/**
 *  圈子; 首页
 */
@property(nonatomic, copy)NSString *getPostListByMap;
/**
 *  圈子; 帖子详情
 */
@property(nonatomic, copy)NSString *getPostByMap;
/**
 *  圈子; 发表评论
 */
@property(nonatomic, copy)NSString *saveReply;
/**
 *  圈子; 删除评论
 */
@property(nonatomic, copy)NSString *deleteReoly;
/**
 *  圈子; 举报评论
 */
@property(nonatomic, copy)NSString *informReply;
/**
 *  圈子; 赞
 */
@property(nonatomic, copy)NSString *savePraise;
/**
 *  圈子; 取消赞
 */
@property(nonatomic, copy)NSString *deletePraise;
/**
 *  我的; 首页
 */
@property(nonatomic, copy)NSString *getUserHome;
/**
 *  我的; 个人信息
 */
@property(nonatomic, copy)NSString *getUserByToken;
/**
 *  我的; 个人信息提交
 */
@property(nonatomic, copy)NSString *saveDoctor;
/**
 *  我的; 我评论的帖子
 */
@property(nonatomic, copy)NSString *getReplyListByMap;
/**
 *  我的; 我的喜欢
 */
@property(nonatomic, copy)NSString *getPraiseListByMap;
/**
 *  我的; 我的关注
 */
@property(nonatomic, copy)NSString *getRelationListByMap;
/**
 *  我的; 我的粉丝; 粉丝列表
 */
@property(nonatomic, copy)NSString *getRelationListByMapFans;
/**
 *  我的; 我的粉丝; 关注
 */
@property(nonatomic, copy)NSString *contactaddApproved;
/**
 *  我的; 新建家庭人员
 */
@property(nonatomic, copy)NSString *saveFamilyGroup;
/**
 *  我的; 更改户主; 成员列表
 */
@property(nonatomic, copy)NSString *getFamilyListByMap;
/**
 *  我的; 更改户主; 成提升为户主
 */
@property(nonatomic, copy)NSString *updateFamilyGroup;
/**
 *  我的; 移除账号; 成员列表
 */
@property(nonatomic, copy)NSString *getFamilyListByMapRemoveAccount;
/**
 *  我的; 移除账号; 删除成员
 */
@property(nonatomic, copy)NSString *deleteFamilyGroup;
/**
 *  登陆注册; 登陆
 */
@property(nonatomic, copy)NSString *login;
/**
 *  登陆注册; 注册; 获取验证码接口
 */
@property(nonatomic, copy)NSString *sendVerifycode;
/**
 *  登陆注册; 注册; 注册.校验验证码.登陆
 */
@property(nonatomic, copy)NSString *saveUser;
/**
 *  登陆注册; 找回密码; 获取验证码接口
 */
@property(nonatomic, copy)NSString *sendVerifycodeBack;
/**
 *  登陆注册; 找回密码; 修改密码
 */
@property(nonatomic, copy)NSString *updatePassword;
/**
 *  验证验证码
 */
@property(nonatomic, copy)NSString *yanzhenma;
@end
