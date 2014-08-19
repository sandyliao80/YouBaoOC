//
//  EncyDogCatCategoryCellTable.m
//  YouBaoOC
//
//  Created by developer on 14-8-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncyDogCatCategoryCellTable.h"
#import "EN_PreDefine.h"
@implementation EncyDogCatCategoryCellTable

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drowArcBethWithHeight:5];
}

- (void)drowArcBethWithHeight:(float)height
{
    UIScreen *screen = [UIScreen mainScreen];
    float width = screen.bounds.size.width;
    float widthUnit = width/19;
    float widthAnchor = widthUnit/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, height);
    for(int i = 1;i<=19;i++)
    {
        CGPoint pointAncho;
        CGPoint pointSub;
        if(i%2==0)
        {
            pointAncho = CGPointMake(i*widthUnit-widthAnchor, height-5);
            pointSub   = CGPointMake(i*widthUnit,height );
        }
        else
        {
            pointAncho = CGPointMake(i*widthUnit-widthAnchor,height+5);
            pointSub   = CGPointMake( i*widthUnit,height);
        }
        CGContextAddQuadCurveToPoint(context,pointAncho.x, pointAncho.y, pointSub.x, pointSub.y);
    }

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:65.0/255.0 green:134.0/255.0 blue:174.0/255.0 alpha:1].CGColor);
    
    CGContextAddLineToPoint(context,width, self.frame.size.height-height);
    float heights = self.frame.size.height-height;
    for(int i = 1;i<=19;i++)
    {
        CGPoint pointAncho;
        CGPoint pointSub;
        if(i%2==0)
        {
            pointAncho = CGPointMake(width-i*widthUnit+widthAnchor, heights+5);
            pointSub   = CGPointMake(width-i*widthUnit,heights );
        }
        else
        {
            pointAncho = CGPointMake(width-i*widthUnit+widthAnchor,heights-5);
            pointSub   = CGPointMake(width-i*widthUnit,heights);
        }
        CGContextAddQuadCurveToPoint(context,pointAncho.x, pointAncho.y, pointSub.x, pointSub.y);
    }
    CGContextAddLineToPoint(context, 0, height);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:65.0/255.0 green:134.0/255.0 blue:174.0/255.0 alpha:1].CGColor);
    CGContextFillPath(context);
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
