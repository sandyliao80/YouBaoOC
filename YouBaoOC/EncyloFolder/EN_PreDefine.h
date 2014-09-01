//
//  EN_PreDefine.h
//  YouBaoOC
//
//  Created by developer on 14-8-5.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#ifndef YouBaoOC_EN_PreDefine_h
#define YouBaoOC_EN_PreDefine_h
#define Screen_height   [[UIScreen mainScreen] bounds].size.height /**< 获取屏幕高度 */
#define Screen_width    [[UIScreen mainScreen] bounds].size.width  /**< 获取屏幕宽度 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) /**< 判断是iphone5 */
#define CURRENTVERSION [[[UIDevice currentDevice] systemVersion] floatValue] /**< 获取当前iOS版本 */
#define isRetina [[UIScreen mainScreen]scale]==2 /**< 判断是retaina */

#define ENCY_HOSTURL @"http://115.29.46.22/pet/"   /** <获取图片的地址 */
#define ZXY_HOSTURL  @"http://115.29.46.22/pet/index.php/Api/"/** <获取数据 */
#define ZXY_PETSTYLE @"/PetStyle/searchAllTypePets"             /** <宠物类型 */
#define ZXY_SUBPETSTYLE @"/PetStyle/searchDetailByID"
#define ZXY_GETTODYPUSH @"/Ency/getTodayEncy" /** <每日推送 */
#define ZXY_GETMORE     @"/Ency/searchEncy" /** <更多*/
#define ZXY_GETTYPE     @"/EncyType/getMinorCategory" /** <获取类型 */
#define ZXY_TYPEHTML    @"/Ency/category_article/cate_id/" /** <获取宠物种类html*/
#define ZXY_ENCYHTML    @"/Ency/ency_article/ency_id/"  /** <获取百科的html */
#define ZXY_ENCYLB      @"/Ency/getAd" /** <获取百科的LB */
#define ZXY_ISCOLLECT   @"Ency/is_collect" /** <判断有没有收藏*/
#define ZXY_Select      @"Ency/setCollect" /** <收藏*/
#define ZXY_Favo        @"Ency/getCollectArticle" /** <获得收藏列表*/

#define BLUEINSI  [UIColor colorWithRed:221.0/255.0 green:245.0/255.0 blue:254.0/255.0 alpha:1];
#define ORIGINSI  [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
#define EN_BLUECAT [UIColor colorWithRed:65.0/255.0 green:134.0/255.0 blue:174.0/255.0 alpha:1];
#endif
