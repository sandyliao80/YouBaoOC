//
//  PetRecommendListInfo.h
//
//  Created by 超逸 李 on 14/8/25
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PetRecommendListInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *petId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *imageWidth;
@property (nonatomic, strong) NSString *imageHeight;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userImagePath;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
