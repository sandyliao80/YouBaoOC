//
//  GetPetDetailPetInfo.m
//
//  Created by 超逸 李 on 14/9/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetPetDetailPetInfo.h"


NSString *const kGetPetDetailPetInfoPetName = @"pet_name";
NSString *const kGetPetDetailPetInfoSign = @"sign";
NSString *const kGetPetDetailPetInfoIsEntrust = @"is_entrust";
NSString *const kGetPetDetailPetInfoHeadImage = @"head_image";
NSString *const kGetPetDetailPetInfoAge = @"age";
NSString *const kGetPetDetailPetInfoPetCode = @"pet_code";
NSString *const kGetPetDetailPetInfoUserId = @"user_id";
NSString *const kGetPetDetailPetInfoPetSex = @"pet_sex";
NSString *const kGetPetDetailPetInfoCateName = @"cate_name";
NSString *const kGetPetDetailPetInfoFHybridization = @"f_hybridization";
NSString *const kGetPetDetailPetInfoPetId = @"pet_id";
NSString *const kGetPetDetailPetInfoFAdopt = @"f_adopt";


@interface GetPetDetailPetInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetPetDetailPetInfo

@synthesize petName = _petName;
@synthesize sign = _sign;
@synthesize isEntrust = _isEntrust;
@synthesize headImage = _headImage;
@synthesize age = _age;
@synthesize petCode = _petCode;
@synthesize userId = _userId;
@synthesize petSex = _petSex;
@synthesize cateName = _cateName;
@synthesize fHybridization = _fHybridization;
@synthesize petId = _petId;
@synthesize fAdopt = _fAdopt;


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
            self.petName = [self objectOrNilForKey:kGetPetDetailPetInfoPetName fromDictionary:dict];
            self.sign = [self objectOrNilForKey:kGetPetDetailPetInfoSign fromDictionary:dict];
            self.isEntrust = [self objectOrNilForKey:kGetPetDetailPetInfoIsEntrust fromDictionary:dict];
            self.headImage = [self objectOrNilForKey:kGetPetDetailPetInfoHeadImage fromDictionary:dict];
            self.age = [self objectOrNilForKey:kGetPetDetailPetInfoAge fromDictionary:dict];
            self.petCode = [self objectOrNilForKey:kGetPetDetailPetInfoPetCode fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kGetPetDetailPetInfoUserId fromDictionary:dict];
            self.petSex = [self objectOrNilForKey:kGetPetDetailPetInfoPetSex fromDictionary:dict];
            self.cateName = [self objectOrNilForKey:kGetPetDetailPetInfoCateName fromDictionary:dict];
            self.fHybridization = [self objectOrNilForKey:kGetPetDetailPetInfoFHybridization fromDictionary:dict];
            self.petId = [self objectOrNilForKey:kGetPetDetailPetInfoPetId fromDictionary:dict];
            self.fAdopt = [self objectOrNilForKey:kGetPetDetailPetInfoFAdopt fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.petName forKey:kGetPetDetailPetInfoPetName];
    [mutableDict setValue:self.sign forKey:kGetPetDetailPetInfoSign];
    [mutableDict setValue:self.isEntrust forKey:kGetPetDetailPetInfoIsEntrust];
    [mutableDict setValue:self.headImage forKey:kGetPetDetailPetInfoHeadImage];
    [mutableDict setValue:self.age forKey:kGetPetDetailPetInfoAge];
    [mutableDict setValue:self.petCode forKey:kGetPetDetailPetInfoPetCode];
    [mutableDict setValue:self.userId forKey:kGetPetDetailPetInfoUserId];
    [mutableDict setValue:self.petSex forKey:kGetPetDetailPetInfoPetSex];
    [mutableDict setValue:self.cateName forKey:kGetPetDetailPetInfoCateName];
    [mutableDict setValue:self.fHybridization forKey:kGetPetDetailPetInfoFHybridization];
    [mutableDict setValue:self.petId forKey:kGetPetDetailPetInfoPetId];
    [mutableDict setValue:self.fAdopt forKey:kGetPetDetailPetInfoFAdopt];

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

    self.petName = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetName];
    self.sign = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoSign];
    self.isEntrust = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoIsEntrust];
    self.headImage = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoHeadImage];
    self.age = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoAge];
    self.petCode = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetCode];
    self.userId = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoUserId];
    self.petSex = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetSex];
    self.cateName = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoCateName];
    self.fHybridization = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoFHybridization];
    self.petId = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoPetId];
    self.fAdopt = [aDecoder decodeObjectForKey:kGetPetDetailPetInfoFAdopt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_petName forKey:kGetPetDetailPetInfoPetName];
    [aCoder encodeObject:_sign forKey:kGetPetDetailPetInfoSign];
    [aCoder encodeObject:_isEntrust forKey:kGetPetDetailPetInfoIsEntrust];
    [aCoder encodeObject:_headImage forKey:kGetPetDetailPetInfoHeadImage];
    [aCoder encodeObject:_age forKey:kGetPetDetailPetInfoAge];
    [aCoder encodeObject:_petCode forKey:kGetPetDetailPetInfoPetCode];
    [aCoder encodeObject:_userId forKey:kGetPetDetailPetInfoUserId];
    [aCoder encodeObject:_petSex forKey:kGetPetDetailPetInfoPetSex];
    [aCoder encodeObject:_cateName forKey:kGetPetDetailPetInfoCateName];
    [aCoder encodeObject:_fHybridization forKey:kGetPetDetailPetInfoFHybridization];
    [aCoder encodeObject:_petId forKey:kGetPetDetailPetInfoPetId];
    [aCoder encodeObject:_fAdopt forKey:kGetPetDetailPetInfoFAdopt];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetPetDetailPetInfo *copy = [[GetPetDetailPetInfo alloc] init];
    
    if (copy) {

        copy.petName = [self.petName copyWithZone:zone];
        copy.sign = [self.sign copyWithZone:zone];
        copy.isEntrust = [self.isEntrust copyWithZone:zone];
        copy.headImage = [self.headImage copyWithZone:zone];
        copy.age = [self.age copyWithZone:zone];
        copy.petCode = [self.petCode copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.petSex = [self.petSex copyWithZone:zone];
        copy.cateName = [self.cateName copyWithZone:zone];
        copy.fHybridization = [self.fHybridization copyWithZone:zone];
        copy.petId = [self.petId copyWithZone:zone];
        copy.fAdopt = [self.fAdopt copyWithZone:zone];
    }
    
    return copy;
}


@end
