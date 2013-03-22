//
//  ;
//  Doodle
//
//  Created by ran on 12-10-24.
//  Copyright (c) 2012年 com.o-popo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNRREFRESHDELEGATE <NSObject>

-(void)RefreshChoose:(id)view;
@end


@interface RJFViewForchoose : UIView
{
   // IBOutlet  UIButton    *btnAction;
    //IBOutlet  UIButton    *btnChoose;
    NSInteger    m_lineWidth;
    NSInteger    m_EraseWidth;
    NSInteger    m_ColorChoose;
    NSInteger    m_ActionClick;
    
    id<BNRREFRESHDELEGATE> delegate;
}
@property(readwrite) NSInteger lineWidth;
@property(readwrite) NSInteger colorNumber;;
@property(readwrite) NSInteger ActionNumber;
@property(readwrite) NSInteger eraseLinewidth;
@property(assign) id<BNRREFRESHDELEGATE> delegate;

-(IBAction)ClickAction:(UIButton *)sender;
-(IBAction)clickChoose:(UIButton *)sender;
-(void)InitWithImage:(id)Thread;
-(void)ClickSureAction:(NSInteger)action;


@end
