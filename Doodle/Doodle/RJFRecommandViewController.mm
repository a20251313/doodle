//
//  RJFRecommandViewController.m
//  Texas-pokes
//
//  Created by ran on 12-10-8.
//
//

#import "RJFRecommandViewController.h"
#import "RjfDownPicImageView.h"
#import "UIImge-GetSubImage.h"

#if 0
#define APPSERVERHOST           @"192.168.1.110"
#define APPSERVERPORT            57800
#else
#define APPSERVERHOST          @"apps.bbitoo.cn"
#define APPSERVERPORT            57800
#endif
//#include "appcenter.h"



@interface RJFRecommandViewController ()

@end

@implementation RJFRecommandViewController
@synthesize fileHost = m_strHost;
@synthesize fileport = m_ifilePort;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        m_arrStoreDatasource = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}
-(UIBarButtonItem *)barbuttonItemWithImage:(NSString *)imageName withTarget:(SEL)target
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 36)];
    // imageView.image = [UIImage imageNamed:@"button_bg.png"];
    imageView.userInteractionEnabled = YES;
    UIButton    *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 36)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //btnDraft.backgroundColor = [UIColor blueColor];
    [imageView addSubview:btn];
    [btn addTarget:self
            action:target forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[[UIBarButtonItem alloc] initWithCustomView:imageView] autorelease];
    [btn release];
    [imageView release];
    return barItem;
    
    
}

- (void)viewDidLoad
{
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"精彩应用推荐";
    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    CGSize  size = self.navigationController.navigationBar.frame.size;
    image = [image imageByScalingAndCroppingForSize:size];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    m_av = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:@"加载应用程序信息中！请稍候"
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil, nil] autorelease];
    CGFloat  fwidth = 80;
    UIActivityIndicatorView  *aci = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(95, 50, fwidth, fwidth)];
    [aci startAnimating];
    [m_av addSubview:aci];
    [aci release];
    [m_av show];
    
    self.navigationItem.leftBarButtonItem = [self barbuttonItemWithImage:@"back.png" withTarget:@selector(back:)];
   // m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)back:(id)sender
{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(void)dealloc
{
    if (btnBack)
    {
        [btnBack release];
        btnBack = nil;
    }
    if (m_tableView)
    {
        [m_tableView release];
        m_tableView = nil;
    }
    if (m_arrStoreDatasource)
    {
        [m_arrStoreDatasource removeAllObjects];
        [m_arrStoreDatasource release];
        m_arrStoreDatasource = nil;
    }
    if (m_appDownload)
    {
        [m_appDownload release];
        m_appDownload = nil;
    }
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveNotiFromServer:)
//                                                 name:BNRRECEIVEMESSAGEFROMSERVER
//                                               object:nil];
//    BasisZipAndUnzip   *basiz = [[BasisZipAndUnzip alloc] initWithSize:40];
//    UserInfo  *shareUser = [UserInfo shareInstance];
//    RJFTcpSocket  *socket = [RJFTcpSocket shareWithTag:RESOURCESOCKEtTAG];
//    size_t  size = 0;
//    [socket SendCharMessage:[basiz syncWithRequest:REQ_RECOMMENDATION
//                                            userID:shareUser.userID
//                                       structArray:NULL
//                                      structNumber:1
//                                          dataSize:&size]
//                       size:[basiz dataSize]];
//    
//    
//    //    DZPK_CLIENT_REQ_RECOMMEND_APP  appinfo = {2,shareUser.userID,10,0,DZPKPRODUCTID};
//    //
//    //    [socket SendCharMessage:[basiz syncWithRequest:REQ_RECOMMEND_APP
//    //                                            userID:shareUser.userID
//    //                                       structArray:&appinfo
//    //                                      structNumber:1
//    //                                          dataSize:&size] size:[basiz dataSize]];
//    
//    
//    [basiz release];
//    basiz = nil;
  //  ShowHUD(@"加载应用程序信息中，请稍候", self);
    m_appDownload = [[RJFAppDownload alloc] initWithHost:APPSERVERHOST
                                                    Port:APPSERVERPORT
                                                Delagate:self
                                                     tag:0];
    NSLog(@"appdowninfo:%@",m_appDownload);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [m_appDownload disConnect];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrStoreDatasource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"q"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"q"] autorelease];
        CGFloat   Xpoint = 5;
        CGFloat   XSep = 5;
        RjfDownPicImageView   *imageView  = [[RjfDownPicImageView alloc] initWithFrame:CGRectMake(Xpoint, 5, 50, 50)];
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        Xpoint += 50+XSep;
        
        UIFont  *font = [UIFont systemFontOfSize:12];
        UILabel  *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(Xpoint-5, 2, 100, 30)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setTextAlignment:NSTextAlignmentRight];
        [labelTitle setTextColor:[UIColor blackColor]];
        labelTitle.tag = 2;
        [labelTitle setFont:[UIFont systemFontOfSize:16]];
        [cell.contentView addSubview:labelTitle];
        [labelTitle release];
        
        
        UILabel  *labelSize = [[UILabel alloc] initWithFrame:CGRectMake(Xpoint, 35, 100, 20)];
        [labelSize setFont:font];
        [labelSize setBackgroundColor:[UIColor clearColor]];
        [labelSize setTextColor:[UIColor darkTextColor]];
        labelSize.tag = 3;
        [cell.contentView addSubview:labelSize];
        [labelSize release];
        
        Xpoint += 100+XSep;
        UILabel  *labelVersion = [[UILabel alloc] initWithFrame:CGRectMake(Xpoint, 3, 70, 25)];
        [labelVersion setBackgroundColor:[UIColor clearColor]];
        labelVersion.tag = 4;
        [labelVersion setFont:font];
        [cell.contentView addSubview:labelVersion];
        [labelVersion setTextColor:[UIColor blackColor]];
        [labelVersion release];
        
        UILabel  *labelUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(Xpoint-25, 3+25+3, 100, 25)];
        [labelUpdateTime setBackgroundColor:[UIColor clearColor]];
        labelUpdateTime.tag = 5;
        [labelUpdateTime setFont:font];
        [cell.contentView addSubview:labelUpdateTime];
        [labelUpdateTime setTextColor:[UIColor darkTextColor]];
        [labelUpdateTime release];
      //  Xpoint += 90+XSep;
        
//        UILabel  *labelDownload = [[UILabel alloc] initWithFrame:CGRectMake(Xpoint, 3+12.5, 70, 25)];
//        labelDownload.tag = 5;
//        [labelDownload setFont:font];
//        [labelDownload setBackgroundColor:[UIColor clearColor]];
//        [labelDownload setTextColor:[UIColor blackColor]];
//        [cell.contentView addSubview:labelDownload];
//        [labelDownload release];
        
        
        Xpoint += 76+XSep;
        UIButton  *btnDoload = [[UIButton alloc] initWithFrame:CGRectMake(Xpoint, 12.5, 65, 35)];
        btnDoload.tag = 6;
        [btnDoload addTarget:self
                      action:@selector(downApp:)
            forControlEvents:UIControlEventTouchUpInside];
        [btnDoload setTitle:@"下载" forState:UIControlStateNormal];
        [btnDoload setBackgroundImage:[UIImage imageNamed:@"button_green.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnDoload];
        [btnDoload release];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    UIView  *view = [cell contentView];
    NSDictionary  *dicInfo = [m_arrStoreDatasource objectAtIndex:indexPath.row];
    
    RjfDownPicImageView  *imageView = (RjfDownPicImageView *)[view viewWithTag:1];
    [imageView StartDownPic:[dicInfo valueForKey:SOFTARELOGO] requestID:DOWNAPPPICID fileServer:self.fileHost port:self.fileport];
   // imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dicInfo valueForKey:SOFTARELOGO]]]];
    
    
    UILabel  *label =(UILabel *)[view viewWithTag:2];
    [label setText:[dicInfo valueForKey:SOFTAREDESPRICTION]];
    label = (UILabel *)[view viewWithTag:3];
    
    [label setText:[NSString stringWithFormat:@"大小:%@KB",[dicInfo valueForKey:SOFTARESIZE]]];
    label = (UILabel *)[view viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"版本：%@",[dicInfo valueForKey:SOFTAREVERSION]]];
    label = (UILabel *)[view viewWithTag:5];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dicInfo valueForKey:SOFTAREUPDATETIME] floatValue]];
    NSDateFormatter  *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:@"yy/mm/dd"];
    NSString *strDate = [forma stringFromDate:date];
    [forma release];

    NSLog(@"date:%@",strDate);
    [label setText:[NSString stringWithFormat:@"更新日期:%@",strDate]];
//    label.text = [NSString stringWithFormat:@"下载：%@",[dicInfo valueForKey:SOFTAREDOWNNUMBER]];
    
    
    return cell;
}

-(void)downApp:(UIButton*)sender
{
    CGPoint point = sender.center;
    point = [m_tableView convertPoint:point fromView:sender.superview];
    NSIndexPath* indexpath = [m_tableView indexPathForRowAtPoint:point];
    NSDictionary  *dicInfo = [m_arrStoreDatasource objectAtIndex:indexpath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dicInfo valueForKey:SOFTAREURL]]];
    
    
}
-(IBAction)ClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}




-(void)receiveAppInfo:(NSDictionary *)dicInfo
{
    
    [m_av dismissWithClickedButtonIndex:0 animated:YES];
    if (dicInfo == nil)
    {
        UIAlertView  *av = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"当前没有可以推荐的应用！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil] autorelease];
        [av show];
        return;
        
    }
    if ([dicInfo valueForKey:@"FILEHOST"])
    {
        self.fileHost = [dicInfo valueForKey:@"FILEHOST"];
    }
    if ([dicInfo valueForKey:@"FILEPORT"])
    {
        self.fileport = [[dicInfo valueForKey:@"FILEPORT"] intValue];
    }
    [m_arrStoreDatasource removeAllObjects];
    [m_arrStoreDatasource addObjectsFromArray:[dicInfo valueForKey:@"ARRAY"]];
    [m_tableView reloadData];
  
}
@end
