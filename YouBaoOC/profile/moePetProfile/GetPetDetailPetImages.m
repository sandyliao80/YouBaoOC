//
//  GetPetDetailPetImages.m
//
//  Created by 超逸 李 on 14/8/26
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetPetDetailPetImages.h"


NSString *const kGetPetDetailPetImagesImageId = @"image_id";
NSString *const kGetPetDetailPetImagesImageWidth = @"image_width";
NSString *const kGetPetDetailPetImagesImagePath = @"image_path";
NSString *const kGetPetDetailPetImagesImageHeight = @"image_height";


@interface GetPetDetailPetImages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetPetDetailPetImages

@synthesize imageId = _imageId;
@synthesize imageWidth = _imageWidth;
@synthesize imagePath = _imagePath;
@synthesize imageHeight = _imageHeight;


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
            self.imageId = [self objectOrNilForKey:kGetPetDetailPetImagesImageId fromDictionary:dict];
            self.imageWidth = [self objectOrNilForKey:kGetPetDetailPetImagesImageWidth fromDictionary:dict];
            self.imagePath = [self objectOrNilForKey:kGetPetDetailPetImagesImagePath fromDictionary:dict];
            self.imageHeight = [self objectOrNilForKey:kGetPetDetailPetImagesImageHeight fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.imageId forKey:kGetPetDetailPetImagesImageId];
    [mutableDict setValue:self.imageWidth forKey:kGetPetDetailPetImagesImageWidth];
    [mutableDict setValue:self.imagePath forKey:kGetPetDetailPetImagesImagePath];
    [mutableDict setValue:self.imageHeight forKey:kGetPetDetailPetImagesImageHeight];

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

    self.imageId = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesImageId];
    self.imageWidth = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesImageWidth];
    self.imagePath = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesImagePath];
    self.imageHeight = [aDecoder decodeObjectForKey:kGetPetDetailPetImagesImageHeight];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_imageId forKey:kGetPetDetailPetImagesImageId];
    [aCoder encodeObject:_imageWidth forKey:kGetPetDetailPetImagesImageWidth];
    [aCoder encodeObject:_imagePath forKey:kGetPetDetailPetImagesImagePath];
    [aCoder encodeObject:_imageHeight forKey:kGetPetDetailPetImagesImageHeight];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetPetDetailPetImages *copy = [[GetPetDetailPetImages alloc] init];
    
    if (copy) {

        copy.imageId = [self.imageId copyWithZone:zone];
        copy.imageWidth = [self.imageWidth copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.imageHeight = [self.imageHeight copyWithZone:zone];
    }
    
    return copy;
}


@end
