//
//  GetPetDetailBase.h
//
//  Created by 超逸 李 on 14/9/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetPetDetailPetInfo;

@interface GetPetDetailBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSArray *petImages;
@property (nonatomic, strong) GetPetDetailPetInfo *petInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
