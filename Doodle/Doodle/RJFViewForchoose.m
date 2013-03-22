//
//  RJFViewForchoose.m
//  Doodle
//
//  Created by ran on 12-10-24.
//  Copyright (c) 2012年 com.o-popo. All rights reserved.
//

#import "RJFViewForchoose.h"
#define LINEWITTH  @"LINEWITH"
#define ERASEWITTH  @"ERASEWITTH"
#define COLORNUMBER  @"COLORNUMBER"
#define ACTIONNUMBER  @"ACTIONNUMBER"
@implementation RJFViewForchoose


@synthesize lineWidth = m_lineWidth;
@synthesize colorNumber = m_ColorChoose;
@synthesize ActionNumber = m_ActionClick;
@synthesize eraseLinewidth = m_EraseWidth;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      
        // Initialization code
    }
    return self;
}


-(void)InitWithImage:(id)Thread
{
    [self setInitImage:nil];
    [self SetChooseImageAccordTag:1];
    
    id linewidth = [[NSUserDefaults standardUserDefaults] valueForKey:LINEWITTH];
    id erasewidth = [[NSUserDefaults standardUserDefaults] valueForKey:ERASEWITTH];
    id colorNumber = [[NSUserDefaults standardUserDefaults] valueForKey:COLORNUMBER];
    id actionNumber = [[NSUserDefaults standardUserDefaults] valueForKey:ACTIONNUMBER];
    if (linewidth && erasewidth && colorNumber)
    {
        m_lineWidth = [linewidth intValue];
        m_ColorChoose = [colorNumber intValue];
        m_ActionClick = [actionNumber intValue];
        m_EraseWidth = [erasewidth intValue];
        for (UIButton *btn in [self subviews])
        {
            if (btn.tag == m_ActionClick)
            {
                [self ClickAction:btn];
                break;
            }
            
        }
    }else
    {
        m_lineWidth = 3;
        m_EraseWidth = 3;
        m_ColorChoose = 3;
        for (UIButton *btn in [self subviews])
        {
            if (btn.tag == 1)
            {
                [self ClickAction:btn];
                break;
            }
            
        }
        
    }
   
    
}

-(void)writeTofile
{
    [[NSUserDefaults standardUserDefaults] setInteger:m_ActionClick forKey:ACTIONNUMBER];
    [[NSUserDefaults standardUserDefaults] setInteger:m_lineWidth  forKey:LINEWITTH];
    [[NSUserDefaults standardUserDefaults] setInteger:m_ColorChoose  forKey:COLORNUMBER];
    [[NSUserDefaults standardUserDefaults] setInteger:m_EraseWidth  forKey:ERASEWITTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)ClickAction:(UIButton *)sender
{
    for (UIButton *btn in  [self subviews])
    {
        [btn setHidden:NO];
    }
    [self setInitImage:nil];
    [self SetChooseImageAccordTag:sender.tag];
    m_ActionClick = sender.tag;
   
    NSString   *strImageName = nil;
    NSString   *strTempName = nil;
    UIButton   *btnHasChoose = nil;;
    switch (sender.tag)
    {
        case 1:
            strImageName = @"pen_pressed.png";
            btnHasChoose = (UIButton *)[self viewWithTag:10+m_lineWidth];
            [btnHasChoose setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"line%d_pressed",m_lineWidth]] forState:UIControlStateNormal];
            break;
        case 2:
            strImageName = @"brush_pressed.png";
            
            switch (m_ColorChoose)
        {
            case 1:
                strTempName = @"color_black_pressed.png";
                break;
            case 2:
                strTempName = @"color_white_pressed.png";
                break;
            case 3:
                strTempName = @"color_blue_pressed.png";
                break;
            case 4:
                strTempName = @"color_yellow_pressed.png";
                break;
            case 5:
                strTempName = @"color_orange_pressed.png";
                break;
            case 6:
                strTempName = @"color_red_pressed.png";
                break;
            case 7:
                strTempName = @"color_purple_pressed.png";
                break;
            }
            btnHasChoose = (UIButton *)[self viewWithTag:10+m_ColorChoose];
            [btnHasChoose setBackgroundImage:[UIImage imageNamed:strTempName] forState:UIControlStateNormal];
            
            break;
        case 3:
            strImageName = @"erase_pressed.png";
//            btnHasChoose = (UIButton *)[self viewWithTag:10+m_EraseWidth];
//            [btnHasChoose setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"line%d_pressed.png",m_EraseWidth]] forState:UIControlStateNormal];
            break;
        case 4:
            strImageName = @"delete_pressed.png";
            break;
        case 5:
            strImageName = @"imagelib_pressed.png";
            break;
        case 6:
            strImageName = @"save_pressed.png";
            break;
            
        default:
            break;
    }
    [sender setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
    if (delegate && [delegate respondsToSelector:@selector(RefreshChoose:)])
    {
        [self writeTofile];
        [delegate RefreshChoose:self];
    }
    //NSLog(@"tag:%d",sender.tag);
}
-(IBAction)clickChoose:(UIButton *)sender
{
    
    [self SetChooseImageAccordTag:m_ActionClick];
    NSString   *strImageName = nil;
    switch (m_ActionClick)
    {
        case 1:
            m_lineWidth = sender.tag%10;
            strImageName = [NSString stringWithFormat:@"line%d_pressed.png",sender.tag%10];
         //   [sender setCenter:CGPointMake(sender.center.x, 79.5)];
         //   [sender setBounds:CGRectMake(0, 0, 38, 34)];
             //[sender setFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y, 38, 34)];
            break;
        case 2:
            m_ColorChoose = sender.tag%10;
            
            switch (sender.tag)
            {
                case 11:
                    strImageName = @"color_black_pressed.png";
                    break;
                case 12:
                    strImageName = @"color_white_pressed.png";
                    break;
                case 13:
                    strImageName = @"color_blue_pressed.png";
                    break;
                case 14:
                    strImageName = @"color_yellow_pressed.png";
                    break;
                case 15:
                    strImageName = @"color_orange_pressed.png";
                    break;
                case 16:
                    strImageName = @"color_red_pressed.png";
                    break;
                case 17:
                    strImageName = @"color_purple_pressed.png";
                    break;
                    
                default:
                    break;
            }
          //  [sender setCenter:CGPointMake(sender.center.x, 90)];
          //  [sender setBounds:CGRectMake(0, 0, 45, 28)];
            break;
        default:
            break;
    }
   // NSLog(@"tag:%d",sender.tag);
    if (strImageName != nil)
    {
         [sender setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
    }

      //  NSLog(@"before sender frame:%@ center:%@",sender,[NSValue valueWithCGPoint:sender.center]);
        // [sender setBounds:CGRectMake(0, 0, 45, 28)];
        // [sender setCenter:CGPointMake(sender.center.x+5, sender.center.y+5)];
        //NSLog(@"after sender frame:%@ center:%@",sender,[NSValue valueWithCGPoint:sender.center]);
    
   
    if (delegate && [delegate respondsToSelector:@selector(RefreshChoose:)])
    {
        [self writeTofile];
        [delegate RefreshChoose:self];
    }
   
}

-(void)setInitImage:(id)Thread
{
    for (UIButton  *btn in [self subviews])
    {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag < 10)
        {
            NSString  *strImageName = nil;
            switch (btn.tag)
            {
                case 1:
                    strImageName = @"pen.png";
                    break;
                case 2:
                    strImageName = @"brush.png";
                    break;
                case 3:
                    strImageName = @"erase.png";
                    break;
                case 4:
                    strImageName = @"delete.png";
                    break;
                case 5:
                    strImageName = @"imagelib.png";
                    break;
                case 6:
                    strImageName = @"save.png";
                    break;
                default:
                    break;
            }
            
            UIImage *image = [UIImage imageNamed:strImageName];
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setHidden:NO];
         //   NSLog(@"image:%@ name:%@ tag:%d",image,strImageName,btn.tag);
        }
    }
}

-(void)SetChooseImageAccordTag:(NSInteger)tag
{
    
    NSString   *strImageName = nil;
    switch (tag)
    {
        case 1:
      
            for (UIButton *btn in [self subviews])
            {
                if ([btn isKindOfClass:[UIButton class]] &&  btn.tag > 10)
                {
                    strImageName = [NSString stringWithFormat:@"line%d.png",btn.tag%10];
                    [btn setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
                    [btn setTitle:@"" forState:UIControlStateNormal];
                     [btn setCenter:CGPointMake(btn.center.x, 79.5)];
                    [btn setBounds:CGRectMake(0, 0, 38, 34)];
                    //[btn setFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, 38, 34)];
                    
                }
            }
            break;
        case 2:
            for (UIButton *btn in [self subviews])
            {
                if ([btn isKindOfClass:[UIButton class]] && btn.tag > 10)
                {
                    switch (btn.tag)
                    {
                        case 11:
                            strImageName = @"color_black.png";
                            break;
                        case 12:
                            strImageName = @"color_white.png";
                            break;
                        case 13:
                            strImageName = @"color_blue.png";
                            break;
                        case 14:
                            strImageName = @"color_yellow.png";
                            break;
                        case 15:
                            strImageName = @"color_orange.png";
                            break;
                        case 16:
                            strImageName = @"color_red.png";
                            break;
                        case 17:
                            strImageName = @"color_purple.png";
                            break;
                            
                        default:
                            break;
                    }
                  //  [btn setFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, 42.5, 21.5)];
                    [btn setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    [btn setHidden:NO];
                    
                  //  [btn setCenter:CGPointMake(btn.center.x, 45)];
                   // [btn setBounds:CGRectMake(0, 0, 42.5, 21.5)];
                    // NSLog(@"bounsd:%@",[NSValue valueWithCGRect:btn.bounds]);
                    
                }
            }
            break;
        default:
            for (UIButton *btn in [self subviews])
            {
                if ([btn isKindOfClass:[UIButton class]] && btn.tag > 10)
                {
                    // [btn setBackgroundImage:nil forState:UIControlStateNormal];
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    [btn setHidden:YES];
                    
                }
            }
            
            break;
    }

}
-(void)ClickSureAction:(NSInteger)action
{
    for (UIButton *btnAction in [self subviews])
    {
        if (btnAction.tag == action && [btnAction isKindOfClass:[UIButton class]])
        {
            [self ClickAction:btnAction];
            break;
        }
    }
}

@end
