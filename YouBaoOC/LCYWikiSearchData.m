//
//  LCYWikiSearchData.m
//
//  Created by 超逸 李 on 14/12/4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYWikiSearchData.h"


NSString *const kLCYWikiSearchDataAuthor = @"author";
NSString *const kLCYWikiSearchDataCateId = @"cate_id";
NSString *const kLCYWikiSearchDataEncyCollect = @"ency_collect";
NSString *const kLCYWikiSearchDataTypeId = @"type_id";
NSString *const kLCYWikiSearchDataTitle = @"title";
NSString *const kLCYWikiSearchDataEncyId = @"ency_id";
NSString *const kLCYWikiSearchDataKeyword = @"keyword";
NSString *const kLCYWikiSearchDataCateName = @"cate_name";
NSString *const kLCYWikiSearchDataHeadImg = @"head_img";
NSString *const kLCYWikiSearchDataEncyRead = @"ency_read";


@interface LCYWikiSearchData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYWikiSearchData

@synthesize author = _author;
@synthesize cateId = _cateId;
@synthesize encyCollect = _encyCollect;
@synthesize typeId = _typeId;
@synthesize title = _title;
@synthesize encyId = _encyId;
@synthesize keyword = _keyword;
@synthesize cateName = _cateName;
@synthesize headImg = _headImg;
@synthesize encyRead = _encyRead;


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
            self.author = [self objectOrNilForKey:kLCYWikiSearchDataAuthor fromDictionary:dict];
            self.cateId = [self objectOrNilForKey:kLCYWikiSearchDataCateId fromDictionary:dict];
            self.encyCollect = [self objectOrNilForKey:kLCYWikiSearchDataEncyCollect fromDictionary:dict];
            self.typeId = [self objectOrNilForKey:kLCYWikiSearchDataTypeId fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLCYWikiSearchDataTitle fromDictionary:dict];
            self.encyId = [self objectOrNilForKey:kLCYWikiSearchDataEncyId fromDictionary:dict];
            self.keyword = [self objectOrNilForKey:kLCYWikiSearchDataKeyword fromDictionary:dict];
            self.cateName = [self objectOrNilForKey:kLCYWikiSearchDataCateName fromDictionary:dict];
            self.headImg = [self objectOrNilForKey:kLCYWikiSearchDataHeadImg fromDictionary:dict];
            self.encyRead = [self objectOrNilForKey:kLCYWikiSearchDataEncyRead fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.author forKey:kLCYWikiSearchDataAuthor];
    [mutableDict setValue:self.cateId forKey:kLCYWikiSearchDataCateId];
    [mutableDict setValue:self.encyCollect forKey:kLCYWikiSearchDataEncyCollect];
    [mutableDict setValue:self.typeId forKey:kLCYWikiSearchDataTypeId];
    [mutableDict setValue:self.title forKey:kLCYWikiSearchDataTitle];
    [mutableDict setValue:self.encyId forKey:kLCYWikiSearchDataEncyId];
    [mutableDict setValue:self.keyword forKey:kLCYWikiSearchDataKeyword];
    [mutableDict setValue:self.cateName forKey:kLCYWikiSearchDataCateName];
    [mutableDict setValue:self.headImg forKey:kLCYWikiSearchDataHeadImg];
    [mutableDict setValue:self.encyRead forKey:kLCYWikiSearchDataEncyRead];

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

    self.author = [aDecoder decodeObjectForKey:kLCYWikiSearchDataAuthor];
    self.cateId = [aDecoder decodeObjectForKey:kLCYWikiSearchDataCateId];
    self.encyCollect = [aDecoder decodeObjectForKey:kLCYWikiSearchDataEncyCollect];
    self.typeId = [aDecoder decodeObjectForKey:kLCYWikiSearchDataTypeId];
    self.title = [aDecoder decodeObjectForKey:kLCYWikiSearchDataTitle];
    self.encyId = [aDecoder decodeObjectForKey:kLCYWikiSearchDataEncyId];
    self.keyword = [aDecoder decodeObjectForKey:kLCYWikiSearchDataKeyword];
    self.cateName = [aDecoder decodeObjectForKey:kLCYWikiSearchDataCateName];
    self.headImg = [aDecoder decodeObjectForKey:kLCYWikiSearchDataHeadImg];
    self.encyRead = [aDecoder decodeObjectForKey:kLCYWikiSearchDataEncyRead];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_author forKey:kLCYWikiSearchDataAuthor];
    [aCoder encodeObject:_cateId forKey:kLCYWikiSearchDataCateId];
    [aCoder encodeObject:_encyCollect forKey:kLCYWikiSearchDataEncyCollect];
    [aCoder encodeObject:_typeId forKey:kLCYWikiSearchDataTypeId];
    [aCoder encodeObject:_title forKey:kLCYWikiSearchDataTitle];
    [aCoder encodeObject:_encyId forKey:kLCYWikiSearchDataEncyId];
    [aCoder encodeObject:_keyword forKey:kLCYWikiSearchDataKeyword];
    [aCoder encodeObject:_cateName forKey:kLCYWikiSearchDataCateName];
    [aCoder encodeObject:_headImg forKey:kLCYWikiSearchDataHeadImg];
    [aCoder encodeObject:_encyRead forKey:kLCYWikiSearchDataEncyRead];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYWikiSearchData *copy = [[LCYWikiSearchData alloc] init];
    
    if (copy) {

        copy.author = [self.author copyWithZone:zone];
        copy.cateId = [self.cateId copyWithZone:zone];
        copy.encyCollect = [self.encyCollect copyWithZone:zone];
        copy.typeId = [self.typeId copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.encyId = [self.encyId copyWithZone:zone];
        copy.keyword = [self.keyword copyWithZone:zone];
        copy.cateName = [self.cateName copyWithZone:zone];
        copy.headImg = [self.headImg copyWithZone:zone];
        copy.encyRead = [self.encyRead copyWithZone:zone];
    }
    
    return copy;
}


@end
