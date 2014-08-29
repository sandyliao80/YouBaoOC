//
//  EncyTabThreeCell.m
//  YouBaoOC
//
//  Created by 周效宇 on 14-8-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyTabThreeCell.h"
@interface EncyTabThreeCell()
{
    
    IBOutletCollection(UIButton) NSArray *allBtns;
    
    IBOutletCollection(UIImageView) NSArray *allImages;
}

- (IBAction)selectOneBtn:(id)sender;
@end
@implementation EncyTabThreeCell

- (void)awakeFromNib {
    // Initialization code
    [self initImageSlide];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
            if([self.delegate respondsToSelector:@selector(selectTabBtn:)])
            {
                [self.delegate selectTabBtn:oneBtn.tag];
            }
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
