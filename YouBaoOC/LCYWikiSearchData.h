//
//  LCYWikiSearchData.h
//
//  Created by 超逸 李 on 14/12/4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYWikiSearchData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *cateId;
@property (nonatomic, strong) NSString *encyCollect;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *encyId;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *cateName;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *encyRead;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
