//
//  GetUserInfoUserInfo.h
//
//  Created by 超逸 李 on 14/8/15
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GetUserInfoUserInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, assign) id tip;
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *province;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
