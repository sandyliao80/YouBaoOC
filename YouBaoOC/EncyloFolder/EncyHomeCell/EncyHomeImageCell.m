//
//  EncyHomeImageCell.m
//  YouBaoOC
//
//  Created by developer on 14-8-6.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyHomeImageCell.h"
#import "ZXYScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "EN_PreDefine.h"
#import "EncyDetailPetWeb.h"
#import "ZXYNETHelper.h"
@interface EncyHomeImageCell()<ZXYScrollDataSource,ZXYScrollDelegate>
{
    NSMutableArray *allDataForShow;
}
@end

@implementation EncyHomeImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    if(!allDataForShow)
    {
        allDataForShow = [[NSMutableArray alloc] init];
    }
    NSLog(@"%f,%f",self.zxyScroll.frame.size.width,self.zxyScroll.frame.size.height);
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",ZXY_HOSTURL,ZXY_ENCYLB];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[operation responseString]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        if([dic objectForKey:@"data"]!=[NSNull null])
        {
            if(allDataForShow.count)
            {
                [allDataForShow removeAllObjects];
            }
            NSArray *datas = [dic objectForKey:@"data"];
            for(NSDictionary *tempDic in datas)
            {
                [allDataForShow addObject:tempDic];
            }
            [self.zxyScroll reloadDataImage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.zxyScroll.dataSource = self;
    self.zxyScroll.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)shouldTurnAutoWithTime
{
    return YES;
}//定时滚动
-(NSTimeInterval)turnTimeInterVal
{
    return 3;
};//滚动间隔
-(BOOL)shouldClickAtIndex:(NSInteger)index
{
    return YES;
}//是否可以进行点击事件
- (NSInteger)numberOfPages
{
    return allDataForShow.count;
}//页数
- (UIView *)viewAtIndexPage:(NSInteger)index
{
    NSDictionary *currentDic = [allDataForShow objectAtIndex:index];
    UIImageView *currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 119)];
    NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ENCY_HOSTURL,[currentDic objectForKey:@"image"]]];
    [currentImage sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"en_Home"]];
    return currentImage;
}

- (void)afterClickAtIndex:(NSInteger)index
{
    NSDictionary *currentDic = [allDataForShow objectAtIndex:index];
    if([self.delegate respondsToSelector:@selector(selectADImageWithEncy_ID:)])
    {
        [self.delegate selectADImageWithEncy_ID:[currentDic objectForKey:@"ency_id"]];
    }
}
@end
