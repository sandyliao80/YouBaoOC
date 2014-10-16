//
//  LCYGetSquareListMsg.m
//
//  Created by 超逸 李 on 14/10/16
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetSquareListMsg.h"


NSString *const kLCYGetSquareListMsgBusinessBrief = @"business_brief";
NSString *const kLCYGetSquareListMsgBusinessImage = @"business_image";
NSString *const kLCYGetSquareListMsgBusinessId = @"business_id";
NSString *const kLCYGetSquareListMsgBusinessName = @"business_name";
NSString *const kLCYGetSquareListMsgDistance = @"distance";
NSString *const kLCYGetSquareListMsgBusinessScore = @"business_score";


@interface LCYGetSquareListMsg ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetSquareListMsg

@synthesize businessBrief = _businessBrief;
@synthesize businessImage = _businessImage;
@synthesize businessId = _businessId;
@synthesize businessName = _businessName;
@synthesize distance = _distance;
@synthesize businessScore = _businessScore;


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
            self.businessBrief = [self objectOrNilForKey:kLCYGetSquareListMsgBusinessBrief fromDictionary:dict];
            self.businessImage = [self objectOrNilForKey:kLCYGetSquareListMsgBusinessImage fromDictionary:dict];
            self.businessId = [[self objectOrNilForKey:kLCYGetSquareListMsgBusinessId fromDictionary:dict] integerValue];
            self.businessName = [self objectOrNilForKey:kLCYGetSquareListMsgBusinessName fromDictionary:dict];
            self.distance = [[self objectOrNilForKey:kLCYGetSquareListMsgDistance fromDictionary:dict] doubleValue];
            self.businessScore = [[self objectOrNilForKey:kLCYGetSquareListMsgBusinessScore fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.businessBrief forKey:kLCYGetSquareListMsgBusinessBrief];
    [mutableDict setValue:self.businessImage forKey:kLCYGetSquareListMsgBusinessImage];
    [mutableDict setValue:[NSNumber numberWithInteger:self.businessId] forKey:kLCYGetSquareListMsgBusinessId];
    [mutableDict setValue:self.businessName forKey:kLCYGetSquareListMsgBusinessName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.distance] forKey:kLCYGetSquareListMsgDistance];
    [mutableDict setValue:[NSNumber numberWithDouble:self.businessScore] forKey:kLCYGetSquareListMsgBusinessScore];

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

    self.businessBrief = [aDecoder decodeObjectForKey:kLCYGetSquareListMsgBusinessBrief];
    self.businessImage = [aDecoder decodeObjectForKey:kLCYGetSquareListMsgBusinessImage];
    self.businessId = [aDecoder decodeIntegerForKey:kLCYGetSquareListMsgBusinessId];
    self.businessName = [aDecoder decodeObjectForKey:kLCYGetSquareListMsgBusinessName];
    self.distance = [aDecoder decodeDoubleForKey:kLCYGetSquareListMsgDistance];
    self.businessScore = [aDecoder decodeDoubleForKey:kLCYGetSquareListMsgBusinessScore];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_businessBrief forKey:kLCYGetSquareListMsgBusinessBrief];
    [aCoder encodeObject:_businessImage forKey:kLCYGetSquareListMsgBusinessImage];
    [aCoder encodeInteger:_businessId forKey:kLCYGetSquareListMsgBusinessId];
    [aCoder encodeObject:_businessName forKey:kLCYGetSquareListMsgBusinessName];
    [aCoder encodeDouble:_distance forKey:kLCYGetSquareListMsgDistance];
    [aCoder encodeDouble:_businessScore forKey:kLCYGetSquareListMsgBusinessScore];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetSquareListMsg *copy = [[LCYGetSquareListMsg alloc] init];
    
    if (copy) {

        copy.businessBrief = [self.businessBrief copyWithZone:zone];
        copy.businessImage = [self.businessImage copyWithZone:zone];
        copy.businessId = self.businessId;
        copy.businessName = [self.businessName copyWithZone:zone];
        copy.distance = self.distance;
        copy.businessScore = self.businessScore;
    }
    
    return copy;
}


@end
