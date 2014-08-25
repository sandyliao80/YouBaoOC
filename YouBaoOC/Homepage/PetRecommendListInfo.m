//
//  PetRecommendListInfo.m
//
//  Created by 超逸 李 on 14/8/25
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "PetRecommendListInfo.h"


NSString *const kPetRecommendListInfoPetId = @"pet_id";
NSString *const kPetRecommendListInfoImagePath = @"image_path";
NSString *const kPetRecommendListInfoTime = @"time";
NSString *const kPetRecommendListInfoImageWidth = @"image_width";
NSString *const kPetRecommendListInfoImageHeight = @"image_height";
NSString *const kPetRecommendListInfoUserId = @"user_id";
NSString *const kPetRecommendListInfoUserImagePath = @"user_image_path";


@interface PetRecommendListInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PetRecommendListInfo

@synthesize petId = _petId;
@synthesize imagePath = _imagePath;
@synthesize time = _time;
@synthesize imageWidth = _imageWidth;
@synthesize imageHeight = _imageHeight;
@synthesize userId = _userId;
@synthesize userImagePath = _userImagePath;


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
            self.petId = [self objectOrNilForKey:kPetRecommendListInfoPetId fromDictionary:dict];
            self.imagePath = [self objectOrNilForKey:kPetRecommendListInfoImagePath fromDictionary:dict];
            self.time = [self objectOrNilForKey:kPetRecommendListInfoTime fromDictionary:dict];
            self.imageWidth = [self objectOrNilForKey:kPetRecommendListInfoImageWidth fromDictionary:dict];
            self.imageHeight = [self objectOrNilForKey:kPetRecommendListInfoImageHeight fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kPetRecommendListInfoUserId fromDictionary:dict];
            self.userImagePath = [self objectOrNilForKey:kPetRecommendListInfoUserImagePath fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.petId forKey:kPetRecommendListInfoPetId];
    [mutableDict setValue:self.imagePath forKey:kPetRecommendListInfoImagePath];
    [mutableDict setValue:self.time forKey:kPetRecommendListInfoTime];
    [mutableDict setValue:self.imageWidth forKey:kPetRecommendListInfoImageWidth];
    [mutableDict setValue:self.imageHeight forKey:kPetRecommendListInfoImageHeight];
    [mutableDict setValue:self.userId forKey:kPetRecommendListInfoUserId];
    [mutableDict setValue:self.userImagePath forKey:kPetRecommendListInfoUserImagePath];

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

    self.petId = [aDecoder decodeObjectForKey:kPetRecommendListInfoPetId];
    self.imagePath = [aDecoder decodeObjectForKey:kPetRecommendListInfoImagePath];
    self.time = [aDecoder decodeObjectForKey:kPetRecommendListInfoTime];
    self.imageWidth = [aDecoder decodeObjectForKey:kPetRecommendListInfoImageWidth];
    self.imageHeight = [aDecoder decodeObjectForKey:kPetRecommendListInfoImageHeight];
    self.userId = [aDecoder decodeObjectForKey:kPetRecommendListInfoUserId];
    self.userImagePath = [aDecoder decodeObjectForKey:kPetRecommendListInfoUserImagePath];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_petId forKey:kPetRecommendListInfoPetId];
    [aCoder encodeObject:_imagePath forKey:kPetRecommendListInfoImagePath];
    [aCoder encodeObject:_time forKey:kPetRecommendListInfoTime];
    [aCoder encodeObject:_imageWidth forKey:kPetRecommendListInfoImageWidth];
    [aCoder encodeObject:_imageHeight forKey:kPetRecommendListInfoImageHeight];
    [aCoder encodeObject:_userId forKey:kPetRecommendListInfoUserId];
    [aCoder encodeObject:_userImagePath forKey:kPetRecommendListInfoUserImagePath];
}

- (id)copyWithZone:(NSZone *)zone
{
    PetRecommendListInfo *copy = [[PetRecommendListInfo alloc] init];
    
    if (copy) {

        copy.petId = [self.petId copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
        copy.imageWidth = [self.imageWidth copyWithZone:zone];
        copy.imageHeight = [self.imageHeight copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.userImagePath = [self.userImagePath copyWithZone:zone];
    }
    
    return copy;
}


@end
