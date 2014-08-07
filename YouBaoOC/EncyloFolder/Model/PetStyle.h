//
//  PetStyle.h
//  YouBaoOC
//
//  Created by developer on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PetStyle : NSManagedObject

@property (nonatomic, retain) NSString * cat_id;
@property (nonatomic, retain) NSString * f_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSString * head_img;
@property (nonatomic, retain) NSString * head_imgS;

@end
