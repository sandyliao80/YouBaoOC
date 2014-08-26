//
//  GetPetDetailPetImages.h
//
//  Created by 超逸 李 on 14/8/26
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GetPetDetailPetImages : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, strong) NSString *imageWidth;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *imageHeight;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
