//
//  RJFViewController.h
//  Doodle
//
//  Created by ran on 12-10-24.
//  Copyright (c) 2012年 com.o-popo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJFViewForchoose.h"
#import <QuartzCore/QuartzCore.h>
#import "publicDefine.h"
typedef enum
{
    deletePuttonPressed,
    saveButtonPressed,
}ButtonPressedType;



typedef enum
{
    JFsegmentColorTypeDefultColor = 0,  //default is white color
    JFsegmentColorTypeblackColor = 1,
    JFsegmentColorTypewhiteColor = 2,
    JFsegmentColorTypeblueColor = 3,
    JFsegmentColorTypeyellowColor = 4,
    JFsegmentColorTypeorangeColor = 5,
    JFsegmentColorTyperedColor = 6,
    JFsegmentColorTypepurpleColor = 7,
    
}JFsegmentColorType;

@interface RJFViewController : UIViewController<BNRREFRESHDELEGATE>
{
    IBOutlet   RJFViewForchoose    *viweForChoose;
    IBOutlet   UIButton   *btnAbout;
    IBOutlet   UIButton   *btnAppRecommand;
    IBOutlet   UIButton   *btnShowView;
    IBOutlet   UIImageView *imageViewHead;
    IBOutlet   UIImageView *drawView;
   
    
    BOOL        m_bISMoved;
    BOOL        m_bCanDraw;
    NSMutableArray  *m_arrayStoreTempPoint;
    NSMutableArray  *m_arrStorePainInfo;
    
    CGPoint lastPoint;
    CGPoint lastPointErase;
    
	BOOL canErase;
    BOOL firstErase;
    JFsegmentColorType segmentColor;
	int segmentWidth;
	int eraseWidth;
    int m_actionNumber;
    BOOL  m_CanErase;
    ButtonPressedType  m_buttonpressed;
    UIImage            *m_bgimage;
}

@property(copy)UIImage    *bgImage;
-(IBAction)showAboutView:(UIButton *)sender;
-(IBAction)ClickAppRecommand:(UIButton *)sender;
-(IBAction)ClickShowView:(UIButton *)sender;

@end
