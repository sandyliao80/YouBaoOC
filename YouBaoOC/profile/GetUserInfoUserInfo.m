//
//  GetUserInfoUserInfo.m
//
//  Created by 超逸 李 on 14/8/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetUserInfoUserInfo.h"


NSString *const kGetUserInfoUserInfoUserName = @"user_name";
NSString *const kGetUserInfoUserInfoWechat = @"wechat";
NSString *const kGetUserInfoUserInfoProvince = @"province";
NSString *const kGetUserInfoUserInfoTelephone = @"telephone";
NSString *const kGetUserInfoUserInfoSex = @"sex";
NSString *const kGetUserInfoUserInfoFQq = @"f_qq";
NSString *const kGetUserInfoUserInfoCity = @"city";
NSString *const kGetUserInfoUserInfoFTip = @"f_tip";
NSString *const kGetUserInfoUserInfoFCellphone = @"f_cellphone";
NSString *const kGetUserInfoUserInfoTown = @"town";
NSString *const kGetUserInfoUserInfoEmail = @"email";
NSString *const kGetUserInfoUserInfoFTelephone = @"f_telephone";
NSString *const kGetUserInfoUserInfoHeadImage = @"head_image";
NSString *const kGetUserInfoUserInfoTip = @"tip";
NSString *const kGetUserInfoUserInfoFWeibo = @"f_weibo";
NSString *const kGetUserInfoUserInfoWeibo = @"weibo";
NSString *const kGetUserInfoUserInfoNickName = @"nick_name";
NSString *const kGetUserInfoUserInfoFAddress = @"f_address";
NSString *const kGetUserInfoUserInfoQq = @"qq";
NSString *const kGetUserInfoUserInfoFLocation = @"f_location";
NSString *const kGetUserInfoUserInfoAddress = @"address";
NSString *const kGetUserInfoUserInfoFWechat = @"f_wechat";


@interface GetUserInfoUserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetUserInfoUserInfo

@synthesize userName = _userName;
@synthesize wechat = _wechat;
@synthesize province = _province;
@synthesize telephone = _telephone;
@synthesize sex = _sex;
@synthesize fQq = _fQq;
@synthesize city = _city;
@synthesize fTip = _fTip;
@synthesize fCellphone = _fCellphone;
@synthesize town = _town;
@synthesize email = _email;
@synthesize fTelephone = _fTelephone;
@synthesize headImage = _headImage;
@synthesize tip = _tip;
@synthesize fWeibo = _fWeibo;
@synthesize weibo = _weibo;
@synthesize nickName = _nickName;
@synthesize fAddress = _fAddress;
@synthesize qq = _qq;
@synthesize fLocation = _fLocation;
@synthesize address = _address;
@synthesize fWechat = _fWechat;


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
            self.userName = [self objectOrNilForKey:kGetUserInfoUserInfoUserName fromDictionary:dict];
            self.wechat = [self objectOrNilForKey:kGetUserInfoUserInfoWechat fromDictionary:dict];
            self.province = [self objectOrNilForKey:kGetUserInfoUserInfoProvince fromDictionary:dict];
            self.telephone = [self objectOrNilForKey:kGetUserInfoUserInfoTelephone fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kGetUserInfoUserInfoSex fromDictionary:dict];
            self.fQq = [self objectOrNilForKey:kGetUserInfoUserInfoFQq fromDictionary:dict];
            self.city = [self objectOrNilForKey:kGetUserInfoUserInfoCity fromDictionary:dict];
            self.fTip = [self objectOrNilForKey:kGetUserInfoUserInfoFTip fromDictionary:dict];
            self.fCellphone = [self objectOrNilForKey:kGetUserInfoUserInfoFCellphone fromDictionary:dict];
            self.town = [self objectOrNilForKey:kGetUserInfoUserInfoTown fromDictionary:dict];
            self.email = [self objectOrNilForKey:kGetUserInfoUserInfoEmail fromDictionary:dict];
            self.fTelephone = [self objectOrNilForKey:kGetUserInfoUserInfoFTelephone fromDictionary:dict];
            self.headImage = [self objectOrNilForKey:kGetUserInfoUserInfoHeadImage fromDictionary:dict];
            self.tip = [self objectOrNilForKey:kGetUserInfoUserInfoTip fromDictionary:dict];
            self.fWeibo = [self objectOrNilForKey:kGetUserInfoUserInfoFWeibo fromDictionary:dict];
            self.weibo = [self objectOrNilForKey:kGetUserInfoUserInfoWeibo fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kGetUserInfoUserInfoNickName fromDictionary:dict];
            self.fAddress = [self objectOrNilForKey:kGetUserInfoUserInfoFAddress fromDictionary:dict];
            self.qq = [self objectOrNilForKey:kGetUserInfoUserInfoQq fromDictionary:dict];
            self.fLocation = [self objectOrNilForKey:kGetUserInfoUserInfoFLocation fromDictionary:dict];
            self.address = [self objectOrNilForKey:kGetUserInfoUserInfoAddress fromDictionary:dict];
            self.fWechat = [self objectOrNilForKey:kGetUserInfoUserInfoFWechat fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userName forKey:kGetUserInfoUserInfoUserName];
    [mutableDict setValue:self.wechat forKey:kGetUserInfoUserInfoWechat];
    [mutableDict setValue:self.province forKey:kGetUserInfoUserInfoProvince];
    [mutableDict setValue:self.telephone forKey:kGetUserInfoUserInfoTelephone];
    [mutableDict setValue:self.sex forKey:kGetUserInfoUserInfoSex];
    [mutableDict setValue:self.fQq forKey:kGetUserInfoUserInfoFQq];
    [mutableDict setValue:self.city forKey:kGetUserInfoUserInfoCity];
    [mutableDict setValue:self.fTip forKey:kGetUserInfoUserInfoFTip];
    [mutableDict setValue:self.fCellphone forKey:kGetUserInfoUserInfoFCellphone];
    [mutableDict setValue:self.town forKey:kGetUserInfoUserInfoTown];
    [mutableDict setValue:self.email forKey:kGetUserInfoUserInfoEmail];
    [mutableDict setValue:self.fTelephone forKey:kGetUserInfoUserInfoFTelephone];
    [mutableDict setValue:self.headImage forKey:kGetUserInfoUserInfoHeadImage];
    [mutableDict setValue:self.tip forKey:kGetUserInfoUserInfoTip];
    [mutableDict setValue:self.fWeibo forKey:kGetUserInfoUserInfoFWeibo];
    [mutableDict setValue:self.weibo forKey:kGetUserInfoUserInfoWeibo];
    [mutableDict setValue:self.nickName forKey:kGetUserInfoUserInfoNickName];
    [mutableDict setValue:self.fAddress forKey:kGetUserInfoUserInfoFAddress];
    [mutableDict setValue:self.qq forKey:kGetUserInfoUserInfoQq];
    [mutableDict setValue:self.fLocation forKey:kGetUserInfoUserInfoFLocation];
    [mutableDict setValue:self.address forKey:kGetUserInfoUserInfoAddress];
    [mutableDict setValue:self.fWechat forKey:kGetUserInfoUserInfoFWechat];

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

    self.userName = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoUserName];
    self.wechat = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoWechat];
    self.province = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoProvince];
    self.telephone = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoTelephone];
    self.sex = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoSex];
    self.fQq = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFQq];
    self.city = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoCity];
    self.fTip = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFTip];
    self.fCellphone = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFCellphone];
    self.town = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoTown];
    self.email = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoEmail];
    self.fTelephone = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFTelephone];
    self.headImage = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoHeadImage];
    self.tip = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoTip];
    self.fWeibo = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFWeibo];
    self.weibo = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoWeibo];
    self.nickName = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoNickName];
    self.fAddress = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFAddress];
    self.qq = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoQq];
    self.fLocation = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFLocation];
    self.address = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoAddress];
    self.fWechat = [aDecoder decodeObjectForKey:kGetUserInfoUserInfoFWechat];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userName forKey:kGetUserInfoUserInfoUserName];
    [aCoder encodeObject:_wechat forKey:kGetUserInfoUserInfoWechat];
    [aCoder encodeObject:_province forKey:kGetUserInfoUserInfoProvince];
    [aCoder encodeObject:_telephone forKey:kGetUserInfoUserInfoTelephone];
    [aCoder encodeObject:_sex forKey:kGetUserInfoUserInfoSex];
    [aCoder encodeObject:_fQq forKey:kGetUserInfoUserInfoFQq];
    [aCoder encodeObject:_city forKey:kGetUserInfoUserInfoCity];
    [aCoder encodeObject:_fTip forKey:kGetUserInfoUserInfoFTip];
    [aCoder encodeObject:_fCellphone forKey:kGetUserInfoUserInfoFCellphone];
    [aCoder encodeObject:_town forKey:kGetUserInfoUserInfoTown];
    [aCoder encodeObject:_email forKey:kGetUserInfoUserInfoEmail];
    [aCoder encodeObject:_fTelephone forKey:kGetUserInfoUserInfoFTelephone];
    [aCoder encodeObject:_headImage forKey:kGetUserInfoUserInfoHeadImage];
    [aCoder encodeObject:_tip forKey:kGetUserInfoUserInfoTip];
    [aCoder encodeObject:_fWeibo forKey:kGetUserInfoUserInfoFWeibo];
    [aCoder encodeObject:_weibo forKey:kGetUserInfoUserInfoWeibo];
    [aCoder encodeObject:_nickName forKey:kGetUserInfoUserInfoNickName];
    [aCoder encodeObject:_fAddress forKey:kGetUserInfoUserInfoFAddress];
    [aCoder encodeObject:_qq forKey:kGetUserInfoUserInfoQq];
    [aCoder encodeObject:_fLocation forKey:kGetUserInfoUserInfoFLocation];
    [aCoder encodeObject:_address forKey:kGetUserInfoUserInfoAddress];
    [aCoder encodeObject:_fWechat forKey:kGetUserInfoUserInfoFWechat];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetUserInfoUserInfo *copy = [[GetUserInfoUserInfo alloc] init];
    
    if (copy) {

        copy.userName = [self.userName copyWithZone:zone];
        copy.wechat = [self.wechat copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.telephone = [self.telephone copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.fQq = [self.fQq copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.fTip = [self.fTip copyWithZone:zone];
        copy.fCellphone = [self.fCellphone copyWithZone:zone];
        copy.town = [self.town copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.fTelephone = [self.fTelephone copyWithZone:zone];
        copy.headImage = [self.headImage copyWithZone:zone];
        copy.tip = [self.tip copyWithZone:zone];
        copy.fWeibo = [self.fWeibo copyWithZone:zone];
        copy.weibo = [self.weibo copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.fAddress = [self.fAddress copyWithZone:zone];
        copy.qq = [self.qq copyWithZone:zone];
        copy.fLocation = [self.fLocation copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.fWechat = [self.fWechat copyWithZone:zone];
    }
    
    return copy;
}


@end
