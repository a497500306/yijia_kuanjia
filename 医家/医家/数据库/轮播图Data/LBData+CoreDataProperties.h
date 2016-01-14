//
//  LBData+CoreDataProperties.h
//  医家
//
//  Created by 洛耳 on 16/1/14.
//  Copyright © 2016年 workorz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LBData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LBData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *hrefUrl;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *imgUrl;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
