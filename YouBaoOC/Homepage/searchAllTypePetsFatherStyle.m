//
//  searchAllTypePetsFatherStyle.m
//
//  Created by   on 14-7-31
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "searchAllTypePetsFatherStyle.h"


NSString *const ksearchAllTypePetsFatherStyleSpell = @"spell";
NSString *const ksearchAllTypePetsFatherStyleHeadImg = @"head_img";
NSString *const ksearchAllTypePetsFatherStyleCatId = @"cat_id";
NSString *const ksearchAllTypePetsFatherStyleFId = @"f_id";
NSString *const ksearchAllTypePetsFatherStyleName = @"name";


@interface searchAllTypePetsFatherStyle ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation searchAllTypePetsFatherStyle

@synthesize spell = _spell;
@synthesize headImg = _headImg;
@synthesize catId = _catId;
@synthesize fId = _fId;
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
            self.spell = [self objectOrNilForKey:ksearchAllTypePetsFatherStyleSpell fromDictionary:dict];
            self.headImg = [self objectOrNilForKey:ksearchAllTypePetsFatherStyleHeadImg fromDictionary:dict];
            self.catId = [self objectOrNilForKey:ksearchAllTypePetsFatherStyleCatId fromDictionary:dict];
            self.fId = [self objectOrNilForKey:ksearchAllTypePetsFatherStyleFId fromDictionary:dict];
            self.name = [self objectOrNilForKey:ksearchAllTypePetsFatherStyleName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.spell forKey:ksearchAllTypePetsFatherStyleSpell];
    [mutableDict setValue:self.headImg forKey:ksearchAllTypePetsFatherStyleHeadImg];
    [mutableDict setValue:self.catId forKey:ksearchAllTypePetsFatherStyleCatId];
    [mutableDict setValue:self.fId forKey:ksearchAllTypePetsFatherStyleFId];
    [mutableDict setValue:self.name forKey:ksearchAllTypePetsFatherStyleName];

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

    self.spell = [aDecoder decodeObjectForKey:ksearchAllTypePetsFatherStyleSpell];
    self.headImg = [aDecoder decodeObjectForKey:ksearchAllTypePetsFatherStyleHeadImg];
    self.catId = [aDecoder decodeObjectForKey:ksearchAllTypePetsFatherStyleCatId];
    self.fId = [aDecoder decodeObjectForKey:ksearchAllTypePetsFatherStyleFId];
    self.name = [aDecoder decodeObjectForKey:ksearchAllTypePetsFatherStyleName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_spell forKey:ksearchAllTypePetsFatherStyleSpell];
    [aCoder encodeObject:_headImg forKey:ksearchAllTypePetsFatherStyleHeadImg];
    [aCoder encodeObject:_catId forKey:ksearchAllTypePetsFatherStyleCatId];
    [aCoder encodeObject:_fId forKey:ksearchAllTypePetsFatherStyleFId];
    [aCoder encodeObject:_name forKey:ksearchAllTypePetsFatherStyleName];
}

- (id)copyWithZone:(NSZone *)zone
{
    searchAllTypePetsFatherStyle *copy = [[searchAllTypePetsFatherStyle alloc] init];
    
    if (copy) {

        copy.spell = [self.spell copyWithZone:zone];
        copy.headImg = [self.headImg copyWithZone:zone];
        copy.catId = [self.catId copyWithZone:zone];
        copy.fId = [self.fId copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
