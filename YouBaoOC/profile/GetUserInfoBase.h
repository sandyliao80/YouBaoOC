//
//  GetUserInfoBase.h
//
//  Created by 超逸 李 on 14/8/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetUserInfoUserInfo;

@interface GetUserInfoBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) GetUserInfoUserInfo *userInfo;
@property (nonatomic, strong) NSArray *petInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
