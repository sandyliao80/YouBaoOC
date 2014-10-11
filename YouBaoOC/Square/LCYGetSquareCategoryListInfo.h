//
//  LCYGetSquareCategoryListInfo.h
//
//  Created by 超逸 李 on 14/10/11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetSquareCategoryListInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *cateId;
@property (nonatomic, strong) NSString *cateName;
@property (nonatomic, strong) NSString *isLock;
@property (nonatomic, strong) NSString *sortKey;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
