//
//  PetRecommendBase.m
//
//  Created by 超逸 李 on 14/8/25
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "PetRecommendBase.h"
#import "PetRecommendListInfo.h"


NSString *const kPetRecommendBaseResult = @"result";
NSString *const kPetRecommendBaseListInfo = @"list_info";


@interface PetRecommendBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PetRecommendBase

@synthesize result = _result;
@synthesize listInfo = _listInfo;


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
            self.result = [[self objectOrNilForKey:kPetRecommendBaseResult fromDictionary:dict] boolValue];
    NSObject *receivedPetRecommendListInfo = [dict objectForKey:kPetRecommendBaseListInfo];
    NSMutableArray *parsedPetRecommendListInfo = [NSMutableArray array];
    if ([receivedPetRecommendListInfo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPetRecommendListInfo) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPetRecommendListInfo addObject:[PetRecommendListInfo modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPetRecommendListInfo isKindOfClass:[NSDictionary class]]) {
       [parsedPetRecommendListInfo addObject:[PetRecommendListInfo modelObjectWithDictionary:(NSDictionary *)receivedPetRecommendListInfo]];
    }

    self.listInfo = [NSArray arrayWithArray:parsedPetRecommendListInfo];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.result] forKey:kPetRecommendBaseResult];
    NSMutableArray *tempArrayForListInfo = [NSMutableArray array];
    for (NSObject *subArrayObject in self.listInfo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForListInfo addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForListInfo addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForListInfo] forKey:kPetRecommendBaseListInfo];

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

    self.result = [aDecoder decodeBoolForKey:kPetRecommendBaseResult];
    self.listInfo = [aDecoder decodeObjectForKey:kPetRecommendBaseListInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_result forKey:kPetRecommendBaseResult];
    [aCoder encodeObject:_listInfo forKey:kPetRecommendBaseListInfo];
}

- (id)copyWithZone:(NSZone *)zone
{
    PetRecommendBase *copy = [[PetRecommendBase alloc] init];
    
    if (copy) {

        copy.result = self.result;
        copy.listInfo = [self.listInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
