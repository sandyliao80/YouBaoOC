//
//  LCYGetSquareListBase.m
//
//  Created by 超逸 李 on 14/10/16
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetSquareListBase.h"
#import "LCYGetSquareListMsg.h"


NSString *const kLCYGetSquareListBaseResult = @"result";
NSString *const kLCYGetSquareListBaseMsg = @"msg";


@interface LCYGetSquareListBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetSquareListBase

@synthesize result = _result;
@synthesize msg = _msg;


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
            self.result = [[self objectOrNilForKey:kLCYGetSquareListBaseResult fromDictionary:dict] boolValue];
    NSObject *receivedLCYGetSquareListMsg = [dict objectForKey:kLCYGetSquareListBaseMsg];
    NSMutableArray *parsedLCYGetSquareListMsg = [NSMutableArray array];
    if ([receivedLCYGetSquareListMsg isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYGetSquareListMsg) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYGetSquareListMsg addObject:[LCYGetSquareListMsg modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYGetSquareListMsg isKindOfClass:[NSDictionary class]]) {
       [parsedLCYGetSquareListMsg addObject:[LCYGetSquareListMsg modelObjectWithDictionary:(NSDictionary *)receivedLCYGetSquareListMsg]];
    }

    self.msg = [NSArray arrayWithArray:parsedLCYGetSquareListMsg];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.result] forKey:kLCYGetSquareListBaseResult];
    NSMutableArray *tempArrayForMsg = [NSMutableArray array];
    for (NSObject *subArrayObject in self.msg) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMsg addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMsg addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMsg] forKey:kLCYGetSquareListBaseMsg];

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

    self.result = [aDecoder decodeBoolForKey:kLCYGetSquareListBaseResult];
    self.msg = [aDecoder decodeObjectForKey:kLCYGetSquareListBaseMsg];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_result forKey:kLCYGetSquareListBaseResult];
    [aCoder encodeObject:_msg forKey:kLCYGetSquareListBaseMsg];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetSquareListBase *copy = [[LCYGetSquareListBase alloc] init];
    
    if (copy) {

        copy.result = self.result;
        copy.msg = [self.msg copyWithZone:zone];
    }
    
    return copy;
}


@end
