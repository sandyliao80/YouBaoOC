//
//  LCYGetSquareCategoryBase.m
//
//  Created by 超逸 李 on 14/10/11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetSquareCategoryBase.h"
#import "LCYGetSquareCategoryListInfo.h"


NSString *const kLCYGetSquareCategoryBaseResult = @"result";
NSString *const kLCYGetSquareCategoryBaseListInfo = @"listInfo";


@interface LCYGetSquareCategoryBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetSquareCategoryBase

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
            self.result = [[self objectOrNilForKey:kLCYGetSquareCategoryBaseResult fromDictionary:dict] boolValue];
    NSObject *receivedLCYGetSquareCategoryListInfo = [dict objectForKey:kLCYGetSquareCategoryBaseListInfo];
    NSMutableArray *parsedLCYGetSquareCategoryListInfo = [NSMutableArray array];
    if ([receivedLCYGetSquareCategoryListInfo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYGetSquareCategoryListInfo) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYGetSquareCategoryListInfo addObject:[LCYGetSquareCategoryListInfo modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYGetSquareCategoryListInfo isKindOfClass:[NSDictionary class]]) {
       [parsedLCYGetSquareCategoryListInfo addObject:[LCYGetSquareCategoryListInfo modelObjectWithDictionary:(NSDictionary *)receivedLCYGetSquareCategoryListInfo]];
    }

    self.listInfo = [NSArray arrayWithArray:parsedLCYGetSquareCategoryListInfo];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.result] forKey:kLCYGetSquareCategoryBaseResult];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForListInfo] forKey:kLCYGetSquareCategoryBaseListInfo];

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

    self.result = [aDecoder decodeBoolForKey:kLCYGetSquareCategoryBaseResult];
    self.listInfo = [aDecoder decodeObjectForKey:kLCYGetSquareCategoryBaseListInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_result forKey:kLCYGetSquareCategoryBaseResult];
    [aCoder encodeObject:_listInfo forKey:kLCYGetSquareCategoryBaseListInfo];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetSquareCategoryBase *copy = [[LCYGetSquareCategoryBase alloc] init];
    
    if (copy) {

        copy.result = self.result;
        copy.listInfo = [self.listInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
