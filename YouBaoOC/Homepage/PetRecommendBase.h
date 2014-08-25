//
//  PetRecommendBase.h
//
//  Created by 超逸 李 on 14/8/25
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PetRecommendBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSArray *listInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
