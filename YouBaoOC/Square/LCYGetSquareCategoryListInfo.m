//
//  LCYGetSquareCategoryListInfo.m
//
//  Created by 超逸 李 on 14/10/11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetSquareCategoryListInfo.h"


NSString *const kLCYGetSquareCategoryListInfoCateId = @"cate_id";
NSString *const kLCYGetSquareCategoryListInfoCateName = @"cate_name";
NSString *const kLCYGetSquareCategoryListInfoIsLock = @"is_lock";
NSString *const kLCYGetSquareCategoryListInfoSortKey = @"sort_key";


@interface LCYGetSquareCategoryListInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetSquareCategoryListInfo

@synthesize cateId = _cateId;
@synthesize cateName = _cateName;
@synthesize isLock = _isLock;
@synthesize sortKey = _sortKey;


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
            self.cateId = [self objectOrNilForKey:kLCYGetSquareCategoryListInfoCateId fromDictionary:dict];
            self.cateName = [self objectOrNilForKey:kLCYGetSquareCategoryListInfoCateName fromDictionary:dict];
            self.isLock = [self objectOrNilForKey:kLCYGetSquareCategoryListInfoIsLock fromDictionary:dict];
            self.sortKey = [self objectOrNilForKey:kLCYGetSquareCategoryListInfoSortKey fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.cateId forKey:kLCYGetSquareCategoryListInfoCateId];
    [mutableDict setValue:self.cateName forKey:kLCYGetSquareCategoryListInfoCateName];
    [mutableDict setValue:self.isLock forKey:kLCYGetSquareCategoryListInfoIsLock];
    [mutableDict setValue:self.sortKey forKey:kLCYGetSquareCategoryListInfoSortKey];

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

    self.cateId = [aDecoder decodeObjectForKey:kLCYGetSquareCategoryListInfoCateId];
    self.cateName = [aDecoder decodeObjectForKey:kLCYGetSquareCategoryListInfoCateName];
    self.isLock = [aDecoder decodeObjectForKey:kLCYGetSquareCategoryListInfoIsLock];
    self.sortKey = [aDecoder decodeObjectForKey:kLCYGetSquareCategoryListInfoSortKey];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cateId forKey:kLCYGetSquareCategoryListInfoCateId];
    [aCoder encodeObject:_cateName forKey:kLCYGetSquareCategoryListInfoCateName];
    [aCoder encodeObject:_isLock forKey:kLCYGetSquareCategoryListInfoIsLock];
    [aCoder encodeObject:_sortKey forKey:kLCYGetSquareCategoryListInfoSortKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetSquareCategoryListInfo *copy = [[LCYGetSquareCategoryListInfo alloc] init];
    
    if (copy) {

        copy.cateId = [self.cateId copyWithZone:zone];
        copy.cateName = [self.cateName copyWithZone:zone];
        copy.isLock = [self.isLock copyWithZone:zone];
        copy.sortKey = [self.sortKey copyWithZone:zone];
    }
    
    return copy;
}


@end
