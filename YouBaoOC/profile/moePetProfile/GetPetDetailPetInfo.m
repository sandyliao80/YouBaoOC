//
//  GetPetDetailPetInfo.m
//
//  Created by 超逸 李 on 14/8/19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetPetDetailPetInfo.h"


NSString *const kGetPetDetailPetInfoPetId = @"pet_id";
NSString *const kGetPetDetailPetInfoFAdopt = @"f_adopt";
NSString *const kGetPetDetailPetInfoPetSex = @"pet_sex";
NSString *const kGetPetDetailPetInfoFHybridization = @"f_hybridization";
NSString *const kGetPetDetailPetInfoAge = @"age";
NSString *const kGetPetDetailPetInfoIsEntrust = @"is_entrust";
NSString *const kGetPetDetailPetInfoPetName = @"pet_name";
NSString *const kGetPetDetailPetInfoPetCode = @"pet_code";
NSString *const kGetPetDetailPetInfoUserId = @"user_id";
NSString *const kGetPetDetailPetInfoHeadImage = @"head_image";
NSString *const kGetPetDetailPetInfoSign = @"sign";


@interface GetPetDetailPetInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetPetDetailPetInfo

@synthesize petId = _petId;
@synthesize fAdopt = _fAdopt;
@synthesize petSex = _petSex;
@synthesize fHybridization = _fHybridization;
@synthesize age = _age;
@synthesize isEntrust = _isEntrust;
@synthesize petName = _petName;
@synthesize petCode = _petCode;
@synthesize userId = _userId;
@synthesize headImage = _headImage;
@synthesize sign = _sign;


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
            self.petId = [self objectOrNilForKey:kGetPetDetailPetInfoPetId fromDictionary:dict];
            self.fAdopt = [self objectOrNilForKey:kGetPetDetailPetInfoFAdopt fromDictionary:dict];
            self.petSex = [self objectOrNilForKey:kGetPetDetailPetInfoPetSex fromDictionary:dict];
            self.fHybridization = [self objectOrNilForKey:kGetPetDetailPetInfoFHybridization fromDictionary:dict];
            self.age = [self objectOrNilForKey:kGetPetDetailPetInfoAge fromDictionary:dict];
            self.isEntrust = [self objectOrNilForKey:kGetPetDetailPetInfoIsEntrust fromDictionary:dict];
            self.petName = [self objectOrNilForKey:kGetPetDetailPetInfoPetName fromDictionary:dict];
            self.petCode = [self objectOrNilForKey:kGetPetDetailPetInfoPetCode fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kGetPetDetailPetInfoUserId fromDictionary:dict];
            self.headImage = [self objectOrNilForKey:kGetPetDetailPetInfoHeadImage fromDictionary:dict];
            self.sign = [self objectOrNilForKey:kGetPetDetailPetInfoSign fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.petId forKey:kGetPetDetailPetInfoPetId];
    [mutableDict setValue:self.fAdopt forKey:kGetPetDetailPetInfoFAdopt];
    [mutableDict setValue:self.petSex forKey:kGetPetDetailPetInfoPetSex];
    [mutableDict setValue:self.fHybridization forKey:kGetPetDetailPetInfoFHybridization];
    [mutableDict setValue:self.age forKey:kGetPetDetailPetInfoAge];
    [mutableDict setValue:self.isEntrust forKey:kGetPetDetailPetInfoIsEntrust];
    [mutableDict setValue:self.petName forKey:kGetPetDetailPetInfoPetName];
    [mutableDict setValue:self.petCode forKey:kGetPetDetailPetInfoPetCode];
    [mutableDict setValue:self.userId forKey:kGetPetDetailPetInfoUserId];
    [mutableDict setValue:self.headImage forKey:kGetPetDetailPetInfoHeadImage];
    [mutableDict setValue:self.sign forKey:kGetPetDetailPetInfoSign];

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

    self.petId = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetId];
    self.fAdopt = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoFAdopt];
    self.petSex = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetSex];
    self.fHybridization = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoFHybridization];
    self.age = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoAge];
    self.isEntrust = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoIsEntrust];
    self.petName = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetName];
    self.petCode = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetCode];
    self.userId = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoUserId];
    self.headImage = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoHeadImage];
    self.sign = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoSign];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_petId forKey:kGetPetDetailPetInfoPetId];
    [aCoder encodeObject:_fAdopt forKey:kGetPetDetailPetInfoFAdopt];
    [aCoder encodeObject:_petSex forKey:kGetPetDetailPetInfoPetSex];
    [aCoder encodeObject:_fHybridization forKey:kGetPetDetailPetInfoFHybridization];
    [aCoder encodeObject:_age forKey:kGetPetDetailPetInfoAge];
    [aCoder encodeObject:_isEntrust forKey:kGetPetDetailPetInfoIsEntrust];
    [aCoder encodeObject:_petName forKey:kGetPetDetailPetInfoPetName];
    [aCoder encodeObject:_petCode forKey:kGetPetDetailPetInfoPetCode];
    [aCoder encodeObject:_userId forKey:kGetPetDetailPetInfoUserId];
    [aCoder encodeObject:_headImage forKey:kGetPetDetailPetInfoHeadImage];
    [aCoder encodeObject:_sign forKey:kGetPetDetailPetInfoSign];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetPetDetailPetInfo *copy = [[GetPetDetailPetInfo alloc] init];
    
    if (copy) {

        copy.petId = [self.petId copyWithZone:zone];
        copy.fAdopt = [self.fAdopt copyWithZone:zone];
        copy.petSex = [self.petSex copyWithZone:zone];
        copy.fHybridization = [self.fHybridization copyWithZone:zone];
        copy.age = [self.age copyWithZone:zone];
        copy.isEntrust = [self.isEntrust copyWithZone:zone];
        copy.petName = [self.petName copyWithZone:zone];
        copy.petCode = [self.petCode copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.headImage = [self.headImage copyWithZone:zone];
        copy.sign = [self.sign copyWithZone:zone];
    }
    
    return copy;
}


@end
