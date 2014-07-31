//
//  searchAllTypePetsBase.h
//
//  Created by   on 14-7-31
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface searchAllTypePetsBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *fatherStyle;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
