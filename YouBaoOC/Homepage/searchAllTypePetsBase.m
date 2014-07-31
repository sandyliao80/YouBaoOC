//
//  searchAllTypePetsBase.m
//
//  Created by   on 14-7-31
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "searchAllTypePetsBase.h"
#import "searchAllTypePetsFatherStyle.h"


NSString *const ksearchAllTypePetsBaseFatherStyle = @"fatherStyle";


@interface searchAllTypePetsBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation searchAllTypePetsBase

@synthesize fatherStyle = _fatherStyle;


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
    NSObject *receivedsearchAllTypePetsFatherStyle = [dict objectForKey:ksearchAllTypePetsBaseFatherStyle];
    NSMutableArray *parsedsearchAllTypePetsFatherStyle = [NSMutableArray array];
    if ([receivedsearchAllTypePetsFatherStyle isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedsearchAllTypePetsFatherStyle) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedsearchAllTypePetsFatherStyle addObject:[searchAllTypePetsFatherStyle modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedsearchAllTypePetsFatherStyle isKindOfClass:[NSDictionary class]]) {
       [parsedsearchAllTypePetsFatherStyle addObject:[searchAllTypePetsFatherStyle modelObjectWithDictionary:(NSDictionary *)receivedsearchAllTypePetsFatherStyle]];
    }

    self.fatherStyle = [NSArray arrayWithArray:parsedsearchAllTypePetsFatherStyle];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForFatherStyle = [NSMutableArray array];
    for (NSObject *subArrayObject in self.fatherStyle) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFatherStyle addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFatherStyle addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFatherStyle] forKey:ksearchAllTypePetsBaseFatherStyle];

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

    self.fatherStyle = [aDecoder decodeObjectForKey:ksearchAllTypePetsBaseFatherStyle];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_fatherStyle forKey:ksearchAllTypePetsBaseFatherStyle];
}

- (id)copyWithZone:(NSZone *)zone
{
    searchAllTypePetsBase *copy = [[searchAllTypePetsBase alloc] init];
    
    if (copy) {

        copy.fatherStyle = [self.fatherStyle copyWithZone:zone];
    }
    
    return copy;
}


@end
