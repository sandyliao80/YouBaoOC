//
//  SearchDetailByIDChildStyle.h
//
//  Created by   on 14-8-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SearchDetailByIDChildStyle : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *spell;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *catId;
@property (nonatomic, strong) NSString *fId;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
