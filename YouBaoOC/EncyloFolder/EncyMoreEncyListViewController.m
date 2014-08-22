//
//  EncyMoreEncyListViewController.m
//  YouBaoOC
//
//  Created by developer on 14-8-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyMoreEncyListViewController.h"
#import "UIViewController+HideTabBar.h"
@interface EncyMoreEncyListViewController ()
{
    NSString *_petID;
    IBOutletCollection(UIButton) NSArray *allBtns;
    
    IBOutletCollection(UIImageView) NSArray *allImages;
}
- (IBAction)selectOneBtn:(id)sender;
@end

@implementation EncyMoreEncyListViewController
-(id)initWithPetId:(NSString *)petID
{
    if(self = [super initWithNibName:@"EncyMoreEncyListViewController" bundle:nil])
    {
        _petID = petID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initImageSlide];
    [self hideTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setNaviLeftItem];
    //self.view.backgroundColor = BLUEINSI;
}

- (void)initImageSlide
{
    for(UIImageView *slideView in allImages)
    {
        if(slideView.tag == 1002)
        {
            slideView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:105.0/255.0 alpha:1];
        }
        else
        {
            slideView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:135.0/255.0 blue:175.0/255.0 alpha:1];
        }
    }
}

- (void)leftItemAction
{
    [self showTabBarWithSelector];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectOneBtn:(id)sender
{
    UIButton *selectedBtn = (UIButton *)sender;
    for(UIButton *oneBtn in allBtns)
    {
        if(oneBtn == selectedBtn)
        {
            [oneBtn setSelected:YES];
            [oneBtn setUserInteractionEnabled:NO];
            NSInteger index = [allBtns indexOfObject:oneBtn];
            UIImageView *currentView = [allImages objectAtIndex:index];
            currentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:105.0/255.0 alpha:1];
        }
        else
        {
            [oneBtn setSelected:NO];
            [oneBtn setUserInteractionEnabled:YES];
            NSInteger index = [allBtns indexOfObject:oneBtn];
            UIImageView *currentView = [allImages objectAtIndex:index];
            currentView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:135.0/255.0 blue:175.0/255.0 alpha:1];
        }
    }
}
@end
