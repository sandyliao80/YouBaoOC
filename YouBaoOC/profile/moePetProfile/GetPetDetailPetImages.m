//
//  GetPetDetailPetImages.m
//
//  Created by 超逸 李 on 14/9/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetPetDetailPetImages.h"


NSString *const kGetPetDetailPetImagesPetId = @"pet_id";
NSString *const kGetPetDetailPetImagesCutHeight = @"cut_height";
NSString *const kGetPetDetailPetImagesPetImg = @"pet_img";
NSString *const kGetPetDetailPetImagesId = @"id";
NSString *const kGetPetDetailPetImagesCutImg = @"cut_img";
NSString *const kGetPetDetailPetImagesImgWidth = @"img_width";
NSString *const kGetPetDetailPetImagesImgHeight = @"img_height";
NSString *const kGetPetDetailPetImagesCutWidth = @"cut_width";
NSString *const kGetPetDetailPetImagesAddTime = @"add_time";


@interface GetPetDetailPetImages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetPetDetailPetImages

@synthesize petId = _petId;
@synthesize cutHeight = _cutHeight;
@synthesize petImg = _petImg;
@synthesize petImagesIdentifier = _petImagesIdentifier;
@synthesize cutImg = _cutImg;
@synthesize imgWidth = _imgWidth;
@synthesize imgHeight = _imgHeight;
@synthesize cutWidth = _cutWidth;
@synthesize addTime = _addTime;


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
            self.petId = [self objectOrNilForKey:kGetPetDetailPetImagesPetId fromDictionary:dict];
            self.cutHeight = [self objectOrNilForKey:kGetPetDetailPetImagesCutHeight fromDictionary:dict];
            self.petImg = [self objectOrNilForKey:kGetPetDetailPetImagesPetImg fromDictionary:dict];
            self.petImagesIdentifier = [self objectOrNilForKey:kGetPetDetailPetImagesId fromDictionary:dict];
            self.cutImg = [self objectOrNilForKey:kGetPetDetailPetImagesCutImg fromDictionary:dict];
            self.imgWidth = [self objectOrNilForKey:kGetPetDetailPetImagesImgWidth fromDictionary:dict];
            self.imgHeight = [self objectOrNilForKey:kGetPetDetailPetImagesImgHeight fromDictionary:dict];
            self.cutWidth = [self objectOrNilForKey:kGetPetDetailPetImagesCutWidth fromDictionary:dict];
            self.addTime = [self objectOrNilForKey:kGetPetDetailPetImagesAddTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.petId forKey:kGetPetDetailPetImagesPetId];
    [mutableDict setValue:self.cutHeight forKey:kGetPetDetailPetImagesCutHeight];
    [mutableDict setValue:self.petImg forKey:kGetPetDetailPetImagesPetImg];
    [mutableDict setValue:self.petImagesIdentifier forKey:kGetPetDetailPetImagesId];
    [mutableDict setValue:self.cutImg forKey:kGetPetDetailPetImagesCutImg];
    [mutableDict setValue:self.imgWidth forKey:kGetPetDetailPetImagesImgWidth];
    [mutableDict setValue:self.imgHeight forKey:kGetPetDetailPetImagesImgHeight];
    [mutableDict setValue:self.cutWidth forKey:kGetPetDetailPetImagesCutWidth];
    [mutableDict setValue:self.addTime forKey:kGetPetDetailPetImagesAddTime];

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

    self.petId = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesPetId];
    self.cutHeight = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesCutHeight];
    self.petImg = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesPetImg];
    self.petImagesIdentifier = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesId];
    self.cutImg = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesCutImg];
    self.imgWidth = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesImgWidth];
    self.imgHeight = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesImgHeight];
    self.cutWidth = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesCutWidth];
    self.addTime = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesAddTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_petId forKey:kGetPetDetailPetImagesPetId];
    [aCoder encodeObject:_cutHeight forKey:kGetPetDetailPetImagesCutHeight];
    [aCoder encodeObject:_petImg forKey:kGetPetDetailPetImagesPetImg];
    [aCoder encodeObject:_petImagesIdentifier forKey:kGetPetDetailPetImagesId];
    [aCoder encodeObject:_cutImg forKey:kGetPetDetailPetImagesCutImg];
    [aCoder encodeObject:_imgWidth forKey:kGetPetDetailPetImagesImgWidth];
    [aCoder encodeObject:_imgHeight forKey:kGetPetDetailPetImagesImgHeight];
    [aCoder encodeObject:_cutWidth forKey:kGetPetDetailPetImagesCutWidth];
    [aCoder encodeObject:_addTime forKey:kGetPetDetailPetImagesAddTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetPetDetailPetImages *copy = [[GetPetDetailPetImages alloc] init];
    
    if (copy) {

        copy.petId = [self.petId copyWithZone:zone];
        copy.cutHeight = [self.cutHeight copyWithZone:zone];
        copy.petImg = [self.petImg copyWithZone:zone];
        copy.petImagesIdentifier = [self.petImagesIdentifier copyWithZone:zone];
        copy.cutImg = [self.cutImg copyWithZone:zone];
        copy.imgWidth = [self.imgWidth copyWithZone:zone];
        copy.imgHeight = [self.imgHeight copyWithZone:zone];
        copy.cutWidth = [self.cutWidth copyWithZone:zone];
        copy.addTime = [self.addTime copyWithZone:zone];
    }
    
    return copy;
}


@end
