//
//  RJFDraftTbControlViewController.h
//  Doodle
//
//  Created by ran on 12-9-5.
//  Copyright (c) 2012年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingImageTouch.h"
typedef enum
{
    DraftTableType,
    DeleteType
}ControlType;

@interface RJFDraftTbControlViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchViewDelegate,UIAlertViewDelegate>
{
    IBOutlet    UITableView       *m_tableView;
    IBOutlet    UIImageView       *m_imageViewbg;
    NSMutableArray                *m_arrayStoreImage;
    ControlType                   m_controlType;
    NSUInteger                    m_index;
    
  //  NSTimeInterval               m_timeSince1970;
}

@end
