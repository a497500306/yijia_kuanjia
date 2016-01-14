//
//  MLInterface.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/7.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLInterface.h"

@implementation MLInterface

singleton_implementation(MLInterface)
//http://192.168.1.88:8080
//http://192.168.1.88:8080
-(NSString *)getPatientHome{
    return @"http://192.168.1.88:8080/crm/patient_sp/getPatientHome.json";
}
-(NSString *)saveGlycemicRecord{
    return @"http://192.168.1.88:8080/crm/glycemic_sp/saveGlycemicRecord.json";
}
-(NSString *)getPatientHistory{
    return @"http://192.168.1.88:8080/crm/patient_sp/getPatientHistory.json";
}
-(NSString *)getfriendList{
    return @"http://192.168.1.88:8080/crm/user_sp/getfriendList.json";
}
-(NSString *)addFriendRelation{
    return @"http://192.168.1.88:8080/crm/user_sp/addFriendRelation.json";
}
-(NSString *)getDoctorList{
    return @"http://192.168.1.88:8080/crm/doctor_sp/getDoctorList.json";
}
-(NSString *)getDoctorDetail{
    return @"http://192.168.1.88:8080/crm/doctor_sp/getDoctorDetail.json";
}
-(NSString *)saveMessage{
    return @"http://192.168.1.88:8080/crm/message_sp/saveMessage.json";
}
-(NSString *)getDoctorListDietitian{
    return @"http://192.168.1.88:8080/crm/doctor_sp/getDoctorList.json";
}
-(NSString *)saveMessageDietitian{
    return @"http://192.168.1.88:8080/crm/message_sp/saveMessage.json";
}
-(NSString *)getPatientList{
    return @"http://192.168.1.88:8080/crm/patient_sp/getPatientList.json";
}
-(NSString *)getPostListByMap{
    return @"http://192.168.1.88:8080/crm/post_sp/getPostListByMap.json";
}
-(NSString *)getPostByMap{
    return @"http://192.168.1.88:8080/crm/post_sp/getPostByMap.json";
}
-(NSString *)saveReply{
    return @"http://192.168.1.88:8080/crm/reply_sp/saveReply.json";
}
-(NSString *)deleteReoly{
    return @"http://192.168.1.88:8080/crm/reply_sp/deleteReply.json";
}
-(NSString *)informReply{
    return @"http://192.168.1.88:8080/crm/reply_sp/informReply.json";
}
-(NSString *)savePraise{
    return @"http://192.168.1.88:8080/crm/praise_sp/savePraise.json";
}
-(NSString *)deletePraise{
    return @"http://192.168.1.88:8080/crm/praise_sp/deletePraise.json";
}
-(NSString *)getUserHome{
    return @"http://192.168.1.88:8080/crm/user_sp/getUserHome.json";
}
-(NSString *)getUserByToken{
    return @"http://192.168.1.88:8080/crm/user_sp/getUserByToken.json";
}
-(NSString *)saveDoctor{
    return @"http://192.168.1.88:8080/crm/user_sp/saveDoctor.json";
}
-(NSString *)getReplyListByMap{
    return @"http://192.168.1.88:8080/crm/reply_sp/getReplyListByMap.json";
}
-(NSString *)getPraiseListByMap{
    return @"http://192.168.1.88:8080/crm/praise_sp/getPraiseListByMap.json";
}
-(NSString *)getRelationListByMap{
    return @"http://192.168.1.88:8080/crm/relation_sp/getRelationListByMap.json";
}
-(NSString *)getRelationListByMapFans{
    return @"http://192.168.1.88:8080/crm/relation_sp/getRelationListByMap.json";
}
-(NSString *)contactaddApproved{
    return @"http://192.168.1.88:8080/crm/relation_sp/contactaddApproved.json";
}
-(NSString *)saveFamilyGroup{
    return @"http://192.168.1.88:8080/crm/family_sp/saveFamilyGroup.json";
}
-(NSString *)getFamilyListByMap{
    return @"http://192.168.1.88:8080/crm/family_sp/getFamilyListByMap.json";
}
-(NSString *)updateFamilyGroup{
    return @"http://192.168.1.88:8080/crm/family_sp/updateFamilyGroup.json";
}
-(NSString *)getFamilyListByMapRemoveAccount{
    return @"http://192.168.1.88:8080/crm/family_sp/getFamilyListByMap.json";
}
-(NSString *)deleteFamilyGroup{
    return @"http://192.168.1.88:8080/crm/family_sp/deleteFamilyGroup.json";
}
-(NSString *)login{
    return @"http://192.168.1.88:8080/crm/user_sp/login.json";
}
-(NSString *)sendVerifycode{
    return @"http://192.168.1.88:8080/crm/send_sp/sendVerifycode.json";
}
-(NSString *)saveUser{
    return @"http://192.168.1.88:8080/crm/user_sp/saveUser.json";
    
}
-(NSString *)sendVerifycodeBack{
    return @"http://192.168.1.88:8080/crm/send_sp/sendVerifycode.json";
}
-(NSString *)updatePassword{
    return @"http://192.168.1.88:8080/crm/user_sp/updatePassword.json";
}
-(NSString *)yanzhenma{
    return @"http://192.168.1.88:8080/crm/verifycode_sp/checkVerifycode.json";
}
-(NSString *)imageUrl{
    return @"http://192.168.1.88:8080";
}
@end
