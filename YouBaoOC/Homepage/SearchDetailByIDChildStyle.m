//
//  SearchDetailByIDChildStyle.m
//
//  Created by   on 14-8-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SearchDetailByIDChildStyle.h"


NSString *const kSearchDetailByIDChildStyleSpell = @"spell";
NSString *const kSearchDetailByIDChildStyleHeadImg = @"head_img";
NSString *const kSearchDetailByIDChildStyleCatId = @"cat_id";
NSString *const kSearchDetailByIDChildStyleFId = @"f_id";
NSString *const kSearchDetailByIDChildStyleName = @"name";


@interface SearchDetailByIDChildStyle ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SearchDetailByIDChildStyle

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
            self.spell = [self objectOrNilForKey:kSearchDetailByIDChildStyleSpell fromDictionary:dict];
            self.headImg = [self objectOrNilForKey:kSearchDetailByIDChildStyleHeadImg fromDictionary:dict];
            self.catId = [self objectOrNilForKey:kSearchDetailByIDChildStyleCatId fromDictionary:dict];
            self.fId = [self objectOrNilForKey:kSearchDetailByIDChildStyleFId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSearchDetailByIDChildStyleName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.spell forKey:kSearchDetailByIDChildStyleSpell];
    [mutableDict setValue:self.headImg forKey:kSearchDetailByIDChildStyleHeadImg];
    [mutableDict setValue:self.catId forKey:kSearchDetailByIDChildStyleCatId];
    [mutableDict setValue:self.fId forKey:kSearchDetailByIDChildStyleFId];
    [mutableDict setValue:self.name forKey:kSearchDetailByIDChildStyleName];

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

    self.spell = [aDecoder decodeObjectForKey:kSearchDetailByIDChildStyleSpell];
    self.headImg = [aDecoder decodeObjectForKey:kSearchDetailByIDChildStyleHeadImg];
    self.catId = [aDecoder decodeObjectForKey:kSearchDetailByIDChildStyleCatId];
    self.fId = [aDecoder decodeObjectForKey:kSearchDetailByIDChildStyleFId];
    self.name = [aDecoder decodeObjectForKey:kSearchDetailByIDChildStyleName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_spell forKey:kSearchDetailByIDChildStyleSpell];
    [aCoder encodeObject:_headImg forKey:kSearchDetailByIDChildStyleHeadImg];
    [aCoder encodeObject:_catId forKey:kSearchDetailByIDChildStyleCatId];
    [aCoder encodeObject:_fId forKey:kSearchDetailByIDChildStyleFId];
    [aCoder encodeObject:_name forKey:kSearchDetailByIDChildStyleName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SearchDetailByIDChildStyle *copy = [[SearchDetailByIDChildStyle alloc] init];
    
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
