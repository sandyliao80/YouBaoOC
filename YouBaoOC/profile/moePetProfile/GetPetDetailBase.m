//
//  GetPetDetailBase.m
//
//  Created by 超逸 李 on 14/8/26
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetPetDetailBase.h"
#import "GetPetDetailPetImages.h"
#import "GetPetDetailPetInfo.h"


NSString *const kGetPetDetailBaseResult = @"result";
NSString *const kGetPetDetailBasePetImages = @"pet_images";
NSString *const kGetPetDetailBasePetInfo = @"pet_info";


@interface GetPetDetailBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetPetDetailBase

@synthesize result = _result;
@synthesize petImages = _petImages;
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
            self.result = [[self objectOrNilForKey:kGetPetDetailBaseResult fromDictionary:dict] boolValue];
    NSObject *receivedGetPetDetailPetImages = [dict objectForKey:kGetPetDetailBasePetImages];
    NSMutableArray *parsedGetPetDetailPetImages = [NSMutableArray array];
    if ([receivedGetPetDetailPetImages isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedGetPetDetailPetImages) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedGetPetDetailPetImages addObject:[GetPetDetailPetImages modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedGetPetDetailPetImages isKindOfClass:[NSDictionary class]]) {
       [parsedGetPetDetailPetImages addObject:[GetPetDetailPetImages modelObjectWithDictionary:(NSDictionary *)receivedGetPetDetailPetImages]];
    }

    self.petImages = [NSArray arrayWithArray:parsedGetPetDetailPetImages];
            self.petInfo = [GetPetDetailPetInfo modelObjectWithDictionary:[dict objectForKey:kGetPetDetailBasePetInfo]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.result] forKey:kGetPetDetailBaseResult];
    NSMutableArray *tempArrayForPetImages = [NSMutableArray array];
    for (NSObject *subArrayObject in self.petImages) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPetImages addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPetImages addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPetImages] forKey:kGetPetDetailBasePetImages];
    [mutableDict setValue:[self.petInfo dictionaryRepresentation] forKey:kGetPetDetailBasePetInfo];

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

    self.result = [aDecoder decodeBoolForKey:kGetPetDetailBaseResult];
    self.petImages = [aDecoder decodeObjectForKey:kGetPetDetailBasePetImages];
    self.petInfo = [aDecoder decodeObjectForKey:kGetPetDetailBasePetInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_result forKey:kGetPetDetailBaseResult];
    [aCoder encodeObject:_petImages forKey:kGetPetDetailBasePetImages];
    [aCoder encodeObject:_petInfo forKey:kGetPetDetailBasePetInfo];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetPetDetailBase *copy = [[GetPetDetailBase alloc] init];
    
    if (copy) {

        copy.result = self.result;
        copy.petImages = [self.petImages copyWithZone:zone];
        copy.petInfo = [self.petInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
