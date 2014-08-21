//
//  GetUserInfoPetInfo.m
//
//  Created by 超逸 李 on 14/8/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetUserInfoPetInfo.h"


NSString *const kGetUserInfoPetInfoPetId = @"pet_id";
NSString *const kGetUserInfoPetInfoFAdopt = @"f_adopt";
NSString *const kGetUserInfoPetInfoHeadImage = @"head_image";
NSString *const kGetUserInfoPetInfoPetSex = @"pet_sex";
NSString *const kGetUserInfoPetInfoAge = @"age";
NSString *const kGetUserInfoPetInfoFHybridization = @"f_hybridization";
NSString *const kGetUserInfoPetInfoPetName = @"pet_name";
NSString *const kGetUserInfoPetInfoIsEntrust = @"is_entrust";
NSString *const kGetUserInfoPetInfoName = @"name";


@interface GetUserInfoPetInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetUserInfoPetInfo

@synthesize petId = _petId;
@synthesize fAdopt = _fAdopt;
@synthesize headImage = _headImage;
@synthesize petSex = _petSex;
@synthesize age = _age;
@synthesize fHybridization = _fHybridization;
@synthesize petName = _petName;
@synthesize isEntrust = _isEntrust;
@synthesize name = _name;


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
            self.petId = [self objectOrNilForKey:kGetUserInfoPetInfoPetId fromDictionary:dict];
            self.fAdopt = [self objectOrNilForKey:kGetUserInfoPetInfoFAdopt fromDictionary:dict];
            self.headImage = [self objectOrNilForKey:kGetUserInfoPetInfoHeadImage fromDictionary:dict];
            self.petSex = [self objectOrNilForKey:kGetUserInfoPetInfoPetSex fromDictionary:dict];
            self.age = [self objectOrNilForKey:kGetUserInfoPetInfoAge fromDictionary:dict];
            self.fHybridization = [self objectOrNilForKey:kGetUserInfoPetInfoFHybridization fromDictionary:dict];
            self.petName = [self objectOrNilForKey:kGetUserInfoPetInfoPetName fromDictionary:dict];
            self.isEntrust = [self objectOrNilForKey:kGetUserInfoPetInfoIsEntrust fromDictionary:dict];
            self.name = [self objectOrNilForKey:kGetUserInfoPetInfoName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.petId forKey:kGetUserInfoPetInfoPetId];
    [mutableDict setValue:self.fAdopt forKey:kGetUserInfoPetInfoFAdopt];
    [mutableDict setValue:self.headImage forKey:kGetUserInfoPetInfoHeadImage];
    [mutableDict setValue:self.petSex forKey:kGetUserInfoPetInfoPetSex];
    [mutableDict setValue:self.age forKey:kGetUserInfoPetInfoAge];
    [mutableDict setValue:self.fHybridization forKey:kGetUserInfoPetInfoFHybridization];
    [mutableDict setValue:self.petName forKey:kGetUserInfoPetInfoPetName];
    [mutableDict setValue:self.isEntrust forKey:kGetUserInfoPetInfoIsEntrust];
    [mutableDict setValue:self.name forKey:kGetUserInfoPetInfoName];

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

    self.petId = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoPetId];
    self.fAdopt = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoFAdopt];
    self.headImage = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoHeadImage];
    self.petSex = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoPetSex];
    self.age = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoAge];
    self.fHybridization = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoFHybridization];
    self.petName = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoPetName];
    self.isEntrust = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoIsEntrust];
    self.name = [aDecoder decodeObjectForKey:kGetUserInfoPetInfoName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_petId forKey:kGetUserInfoPetInfoPetId];
    [aCoder encodeObject:_fAdopt forKey:kGetUserInfoPetInfoFAdopt];
    [aCoder encodeObject:_headImage forKey:kGetUserInfoPetInfoHeadImage];
    [aCoder encodeObject:_petSex forKey:kGetUserInfoPetInfoPetSex];
    [aCoder encodeObject:_age forKey:kGetUserInfoPetInfoAge];
    [aCoder encodeObject:_fHybridization forKey:kGetUserInfoPetInfoFHybridization];
    [aCoder encodeObject:_petName forKey:kGetUserInfoPetInfoPetName];
    [aCoder encodeObject:_isEntrust forKey:kGetUserInfoPetInfoIsEntrust];
    [aCoder encodeObject:_name forKey:kGetUserInfoPetInfoName];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetUserInfoPetInfo *copy = [[GetUserInfoPetInfo alloc] init];
    
    if (copy) {

        copy.petId = [self.petId copyWithZone:zone];
        copy.fAdopt = [self.fAdopt copyWithZone:zone];
        copy.headImage = [self.headImage copyWithZone:zone];
        copy.petSex = [self.petSex copyWithZone:zone];
        copy.age = [self.age copyWithZone:zone];
        copy.fHybridization = [self.fHybridization copyWithZone:zone];
        copy.petName = [self.petName copyWithZone:zone];
        copy.isEntrust = [self.isEntrust copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
