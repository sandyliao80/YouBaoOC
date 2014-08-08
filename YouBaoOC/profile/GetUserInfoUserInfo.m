//
//  GetUserInfoUserInfo.m
//
//  Created by   on 14-8-8
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetUserInfoUserInfo.h"


NSString *const kGetUserInfoUserInfoNickName = @"nick_name";
NSString *const kGetUserInfoUserInfoCity = @"city";
NSString *const kGetUserInfoUserInfoHeadImage = @"head_image";
NSString *const kGetUserInfoUserInfoTip = @"tip";
NSString *const kGetUserInfoUserInfoTown = @"town";
NSString *const kGetUserInfoUserInfoUserName = @"user_name";
NSString *const kGetUserInfoUserInfoSex = @"sex";
NSString *const kGetUserInfoUserInfoProvince = @"province";


@interface GetUserInfoUserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetUserInfoUserInfo

@synthesize nickName = _nickName;
@synthesize city = _city;
@synthesize headImage = _headImage;
@synthesize tip = _tip;
@synthesize town = _town;
@synthesize userName = _userName;
@synthesize sex = _sex;
@synthesize province = _province;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.nickName = [self objectOrNilForKey:kGetUserInfoUserInfoNickName fromDictionary:dict];
            self.city = [self objectOrNilForKey:kGetUserInfoUserInfoCity fromDictionary:dict];
            self.headImage = [self objectOrNilForKey:kGetUserInfoUserInfoHeadImage fromDictionary:dict];
            self.tip = [self objectOrNilForKey:kGetUserInfoUserInfoTip fromDictionary:dict];
            self.town = [self objectOrNilForKey:kGetUserInfoUserInfoTown fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kGetUserInfoUserInfoUserName fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kGetUserInfoUserInfoSex fromDictionary:dict];
            self.province = [self objectOrNilForKey:kGetUserInfoUserInfoProvince fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.nickName forKey:kGetUserInfoUserInfoNickName];
    [mutableDict setValue:self.city forKey:kGetUserInfoUserInfoCity];
    [mutableDict setValue:self.headImage forKey:kGetUserInfoUserInfoHeadImage];
    [mutableDict setValue:self.tip forKey:kGetUserInfoUserInfoTip];
    [mutableDict setValue:self.town forKey:kGetUserInfoUserInfoTown];
    [mutableDict setValue:self.userName forKey:kGetUserInfoUserInfoUserName];
    [mutableDict setValue:self.sex forKey:kGetUserInfoUserInfoSex];
    [mutableDict setValue:self.province forKey:kGetUserInfoUserInfoProvince];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.nickName = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoNickName];
    self.city = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoCity];
    self.headImage = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoHeadImage];
    self.tip = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoTip];
    self.town = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoTown];
    self.userName = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoUserName];
    self.sex = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoSex];
    self.province = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoProvince];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_nickName forKey:kGetUserInfoUserInfoNickName];
    [aCoder encodeObject:_city forKey:kGetUserInfoUserInfoCity];
    [aCoder encodeObject:_headImage forKey:kGetUserInfoUserInfoHeadImage];
    [aCoder encodeObject:_tip forKey:kGetUserInfoUserInfoTip];
    [aCoder encodeObject:_town forKey:kGetUserInfoUserInfoTown];
    [aCoder encodeObject:_userName forKey:kGetUserInfoUserInfoUserName];
    [aCoder encodeObject:_sex forKey:kGetUserInfoUserInfoSex];
    [aCoder encodeObject:_province forKey:kGetUserInfoUserInfoProvince];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetUserInfoUserInfo *copy = [[GetUserInfoUserInfo alloc] init];
    
    if (copy) {

        copy.nickName = [self.nickName copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.headImage = [self.headImage copyWithZone:zone];
        copy.tip = [self.tip copyWithZone:zone];
        copy.town = [self.town copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
    }
    
    return copy;
}


@end
