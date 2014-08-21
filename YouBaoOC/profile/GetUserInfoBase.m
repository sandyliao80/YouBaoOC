//
//  GetUserInfoBase.m
//
//  Created by 超逸 李 on 14/8/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetUserInfoBase.h"
#import "GetUserInfoUserInfo.h"
#import "GetUserInfoPetInfo.h"


NSString *const kGetUserInfoBaseResult = @"result";
NSString *const kGetUserInfoBaseUserInfo = @"userInfo";
NSString *const kGetUserInfoBasePetInfo = @"petInfo";


@interface GetUserInfoBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetUserInfoBase

@synthesize result = _result;
@synthesize userInfo = _userInfo;
@synthesize petInfo = _petInfo;


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
            self.result = [[self objectOrNilForKey:kGetUserInfoBaseResult fromDictionary:dict] boolValue];
            self.userInfo = [GetUserInfoUserInfo modelObjectWithDictionary:[dict objectForKey:kGetUserInfoBaseUserInfo]];
    NSObject *receivedGetUserInfoPetInfo = [dict objectForKey:kGetUserInfoBasePetInfo];
    NSMutableArray *parsedGetUserInfoPetInfo = [NSMutableArray array];
    if ([receivedGetUserInfoPetInfo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedGetUserInfoPetInfo) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedGetUserInfoPetInfo addObject:[GetUserInfoPetInfo modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedGetUserInfoPetInfo isKindOfClass:[NSDictionary class]]) {
       [parsedGetUserInfoPetInfo addObject:[GetUserInfoPetInfo modelObjectWithDictionary:(NSDictionary *)receivedGetUserInfoPetInfo]];
    }

    self.petInfo = [NSArray arrayWithArray:parsedGetUserInfoPetInfo];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.result] forKey:kGetUserInfoBaseResult];
    [mutableDict setValue:[self.userInfo dictionaryRepresentation] forKey:kGetUserInfoBaseUserInfo];
    NSMutableArray *tempArrayForPetInfo = [NSMutableArray array];
    for (NSObject *subArrayObject in self.petInfo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPetInfo addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPetInfo addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPetInfo] forKey:kGetUserInfoBasePetInfo];

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

    self.result = [aDecoder decodeBoolForKey:kGetUserInfoBaseResult];
    self.userInfo = [aDecoder decodeObjectForKey:kGetUserInfoBaseUserInfo];
    self.petInfo = [aDecoder decodeObjectForKey:kGetUserInfoBasePetInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_result forKey:kGetUserInfoBaseResult];
    [aCoder encodeObject:_userInfo forKey:kGetUserInfoBaseUserInfo];
    [aCoder encodeObject:_petInfo forKey:kGetUserInfoBasePetInfo];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetUserInfoBase *copy = [[GetUserInfoBase alloc] init];
    
    if (copy) {

        copy.result = self.result;
        copy.userInfo = [self.userInfo copyWithZone:zone];
        copy.petInfo = [self.petInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
