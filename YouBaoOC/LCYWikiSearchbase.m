//
//  LCYWikiSearchbase.m
//
//  Created by 超逸 李 on 14/12/4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYWikiSearchbase.h"
#import "LCYWikiSearchData.h"


NSString *const kLCYWikiSearchbaseData = @"data";


@interface LCYWikiSearchbase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYWikiSearchbase

@synthesize data = _data;


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
    NSObject *receivedLCYWikiSearchData = [dict objectForKey:kLCYWikiSearchbaseData];
    NSMutableArray *parsedLCYWikiSearchData = [NSMutableArray array];
    if ([receivedLCYWikiSearchData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYWikiSearchData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYWikiSearchData addObject:[LCYWikiSearchData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYWikiSearchData isKindOfClass:[NSDictionary class]]) {
       [parsedLCYWikiSearchData addObject:[LCYWikiSearchData modelObjectWithDictionary:(NSDictionary *)receivedLCYWikiSearchData]];
    }

    self.data = [NSArray arrayWithArray:parsedLCYWikiSearchData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kLCYWikiSearchbaseData];

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

    self.data = [aDecoder decodeObjectForKey:kLCYWikiSearchbaseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kLCYWikiSearchbaseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYWikiSearchbase *copy = [[LCYWikiSearchbase alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
