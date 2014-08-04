//
//  SearchDetailByIDBase.h
//
//  Created by   on 14-8-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SearchDetailByIDBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *childStyle;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
