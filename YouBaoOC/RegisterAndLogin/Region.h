//
//  Region.h
//  YouBaoOC
//
//  Created by Licy on 14-7-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Region : NSManagedObject

@property (nonatomic, retain) NSNumber * agency_id;
@property (nonatomic, retain) NSNumber * parent_id;
@property (nonatomic, retain) NSNumber * region_id;
@property (nonatomic, retain) NSString * region_name;
@property (nonatomic, retain) NSNumber * region_type;

@end
