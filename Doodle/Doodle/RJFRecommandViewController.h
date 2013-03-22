//
//  RJFRecommandViewController.h
//  Texas-pokes
//
//  Created by ran on 12-10-8.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "RJFAppDownload.h"
@interface RJFRecommandViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BNRDOWNAPPINFO>
{
    IBOutlet       UIButton     *btnBack;
    IBOutlet       UITableView  *m_tableView;
    NSMutableArray              *m_arrStoreDatasource;
    RJFAppDownload              *m_appDownload;
    
    NSString                    *m_strHost;
    unsigned int                m_ifilePort;
    UIAlertView                 *m_av;
}
@property(copy)NSString         *fileHost;
@property(readwrite) unsigned int           fileport;
-(IBAction)ClickBack:(id)sender;
@end
