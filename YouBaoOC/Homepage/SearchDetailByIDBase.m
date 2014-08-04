//
//  SearchDetailByIDBase.m
//
//  Created by   on 14-8-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SearchDetailByIDBase.h"
#import "SearchDetailByIDChildStyle.h"


NSString *const kSearchDetailByIDBaseChildStyle = @"childStyle";


@interface SearchDetailByIDBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SearchDetailByIDBase

@synthesize childStyle = _childStyle;


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
    NSObject *receivedSearchDetailByIDChildStyle = [dict objectForKey:kSearchDetailByIDBaseChildStyle];
    NSMutableArray *parsedSearchDetailByIDChildStyle = [NSMutableArray array];
    if ([receivedSearchDetailByIDChildStyle isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSearchDetailByIDChildStyle) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSearchDetailByIDChildStyle addObject:[SearchDetailByIDChildStyle modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSearchDetailByIDChildStyle isKindOfClass:[NSDictionary class]]) {
       [parsedSearchDetailByIDChildStyle addObject:[SearchDetailByIDChildStyle modelObjectWithDictionary:(NSDictionary *)receivedSearchDetailByIDChildStyle]];
    }

    self.childStyle = [NSArray arrayWithArray:parsedSearchDetailByIDChildStyle];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForChildStyle = [NSMutableArray array];
    for (NSObject *subArrayObject in self.childStyle) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForChildStyle addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForChildStyle addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForChildStyle] forKey:kSearchDetailByIDBaseChildStyle];

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

    self.childStyle = [aDecoder decodeObjectForKey:kSearchDetailByIDBaseChildStyle];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_childStyle forKey:kSearchDetailByIDBaseChildStyle];
}

- (id)copyWithZone:(NSZone *)zone
{
    SearchDetailByIDBase *copy = [[SearchDetailByIDBase alloc] init];
    
    if (copy) {

        copy.childStyle = [self.childStyle copyWithZone:zone];
    }
    
    return copy;
}


@end
