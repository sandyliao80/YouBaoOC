//
//  LCYGetSquareListMsg.h
//
//  Created by 超逸 李 on 14/10/16
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetSquareListMsg : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *businessBrief;
@property (nonatomic, strong) NSString *businessImage;
@property (nonatomic, assign) NSInteger businessId;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double businessScore;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
