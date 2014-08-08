//
//  GetUserInfoUserInfo.h
//
//  Created by   on 14-8-8
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GetUserInfoUserInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *province;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
