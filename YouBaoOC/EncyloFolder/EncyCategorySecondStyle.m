//
//  EncyCategorySecondStyle.m
//  YouBaoOC
//
//  Created by developer on 14-8-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyCategorySecondStyle.h"
#import "EncyAllNeedHeader.h"
#import "EncyCategoryCell.h"
@interface EncyCategorySecondStyle ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *allDataForShow;
    ZXYFileOperation *fileOperate;
    ZXYDownLoadImage *imageDown;
    ZXYProvider *dataProvider;
}

@end

@implementation EncyCategorySecondStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [allDataForShow count];
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"en_categoryIdentifier";
    EncyCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *arrNib = [[NSBundle mainBundle] loadNibNamed:@"EncyCategoryCell" owner:self options:0];
        for(id oneObject in arrNib)
        {
            if([oneObject isKindOfClass:[EncyCategoryCell class]])
            {
                cell = (EncyCategoryCell *)oneObject;
            }
        }
    }
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = BLUEINSI;
    }
    else
    {
        cell.backgroundColor = ORIGINSI;
    }

    return cell;
}
@end
