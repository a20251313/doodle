//
//  RJFDraftTbControlViewController.m
//  Doodle
//
//  Created by ran on 12-9-5.
//  Copyright (c) 2012年 ran. All rights reserved.
//

#import "RJFDraftTbControlViewController.h"
#import "UIImge-GetSubImage.h"
#import "publicDefine.h"
#import "SingImageTouch.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "RJFViewController.h"

@interface RJFDraftTbControlViewController ()

@end

@implementation RJFDraftTbControlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        m_arrayStoreImage = [[NSMutableArray alloc] init];
      //  m_timeSince1970 = 0;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSAutoreleasePool   *pool = [[NSAutoreleasePool alloc] init];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"图  稿";
    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    CGSize  size = self.navigationController.navigationBar.frame.size;
    image = [image imageByScalingAndCroppingForSize:size];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationItem.leftBarButtonItem = [self barbuttonItemWithImage:@"back.png" withTarget:@selector(back:)];
    
    
    NSFileManager   *fileManger = [NSFileManager defaultManager];
    NSArray         *subPath = [fileManger subpathsAtPath:IMAGEPATH];
    for (NSString  *strInfo in subPath)
    {
        strInfo = [IMAGEPATH stringByAppendingFormat:@"/%@",strInfo];
        if ([strInfo hasSuffix:@".png"])
        {
            NSData  *data = [[NSData alloc] initWithContentsOfFile:strInfo];
            UIImage *image = [UIImage imageWithData:data];
            [data release];
            [m_arrayStoreImage addObject:[NSDictionary dictionaryWithObjectsAndKeys:image,@"IMAGE",strInfo,@"PATH",nil]];
            // NSLog(@"att:%@",[fileManger attributesOfItemAtPath:strInfo error:nil]);
        }
    }
    m_controlType = DraftTableType;
    m_tableView.separatorStyle = UITableViewCellAccessoryNone;
    [pool drain];
    //self.navigationItem.rightBarButtonItem = [self barbuttonItemWithImage:@"delete.png" withTarget:@selector(delete:)];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)delete:(id)sender
{
    
    
    
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:@"确认删除?"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:@"取消", nil] autorelease];
    [av show];
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        NSAutoreleasePool   *pool = [[NSAutoreleasePool alloc] init];
        NSDictionary    *dicInfo = [m_arrayStoreImage objectAtIndex:m_index];
        NSFileManager   *fileManger = [NSFileManager defaultManager];
        NSString *strPath = [dicInfo valueForKey:@"PATH"];
        NSError  *error = nil;
        [fileManger removeItemAtPath:strPath error:&error];
        /*if ([fileManger removeItemAtPath:strPath error:&error])
         {
         UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"提示"
         message:@"删除成功"
         delegate:nil
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil, nil] autorelease];
         [av show];
         [m_arrayStoreImage removeObjectAtIndex:m_index];
         [self back:nil];
         }else
         {
         UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"错误提示"
         message:@"删除失败！"
         delegate:nil
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil, nil] autorelease];
         [av show];
         
         }*/
        
        [m_arrayStoreImage removeObjectAtIndex:m_index];
        [self back:nil];
        [pool drain];
        
    }
}
-(void)back:(id)sender
{
    if (m_controlType == DraftTableType)
    {
          self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [m_tableView setHidden:NO];
        [m_tableView reloadData];
        m_imageViewbg.image = nil;
        self.navigationItem.rightBarButtonItem = nil;
        m_controlType = DraftTableType;
    }
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![m_arrayStoreImage count])
    {
        return 0;
    }
    int count = [m_arrayStoreImage count]/3;
    count++;
    if ([m_arrayStoreImage count]%3 == 0)
    {
        count--;
        
    }
    return count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"11"];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"] autorelease];
        
        CGFloat xPoint = 8;
        CGFloat yPoint = 5;
        CGFloat fwidth = 85;
        CGFloat fmargth = 25;
        for (int i = 0; i < 3; i++)
        {
            SingImageTouch *imageView = [[SingImageTouch alloc] initWithFrame:CGRectMake(xPoint+fwidth*i+fmargth*i, yPoint, fwidth, fwidth)
                                                                    imagePath:nil
                                                                        image:nil];
            
            imageView.tag = i+1;
            // imageView.hidden = YES;
            [cell.contentView addSubview:imageView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [imageView release];
        }
    }
    
    UIView  *cellview = [cell contentView];
    NSUInteger count = [m_arrayStoreImage count];
    
    for (int i = 0; i < 3; i++)
    {
        SingImageTouch  *view = (SingImageTouch *)[cellview viewWithTag:i+1];
        if (indexPath.row*3+i <= count-1)
        {
            NSDictionary    *dicInfo = [m_arrayStoreImage objectAtIndex:indexPath.row*3+i];
            [view setHidden:NO];
            view.subImageView.image = [dicInfo valueForKey:@"IMAGE"];
            view.imagePath = [dicInfo valueForKey:@"PATH"];
            view.delegate = self;
            //NSLog(@"%ld",sizeof(view.subImageView.image));
        }else
        {
            [view setHidden:YES];
        }
        
        
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
-(void)dealloc
{
    if (m_arrayStoreImage)
    {
        [m_arrayStoreImage removeAllObjects];
        [m_arrayStoreImage release];
        m_arrayStoreImage = nil;
    }
    
    if (m_tableView)
    {
        [m_tableView release];
        m_tableView = nil;
    }
    if (m_imageViewbg)
    {
        [m_imageViewbg release];
        m_imageViewbg = nil;
    }
    self.navigationItem.leftBarButtonItem = nil;
    [super dealloc];
}

-(void)TouchTheImageView:(NSDictionary *)dicInfo
{
    NSAutoreleasePool   *pool = [[NSAutoreleasePool alloc] init];
    NSString *strPath = [dicInfo valueForKey:@"PATH"];
    for (NSDictionary *dicInfotemp in m_arrayStoreImage)
    {
        NSString *strPathTemp = [dicInfotemp valueForKey:@"PATH"];
        if ([strPath isEqualToString:strPathTemp])
        {
            [m_tableView setHidden:YES];
            m_imageViewbg.image = [dicInfotemp valueForKey:@"IMAGE"];
            self.navigationItem.rightBarButtonItem = [self barbuttonItemWithImage:@"rubbsh.png" withTarget:@selector(delete:)];
            m_index = [m_arrayStoreImage indexOfObject:dicInfotemp];
            m_controlType = DeleteType;
        }
    }
    [pool drain];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
  
    if (m_controlType == DeleteType)
    {
    
      //  NSTimeInterval  timeInt = [[NSDate date] timeIntervalSince1970];
      //  if (timeInt-m_timeSince1970 < 1)
     //   {
            for (RJFViewController  *control in [self.navigationController viewControllers])
            {
                if ([control isKindOfClass:[RJFViewController class]])
                {
                    [(RJFViewController*)control setBgImage:[m_imageViewbg.image retain]];
                  //  NSLog(@"control:%@ image:%@",control,m_imageViewbg.image);
                }
                //NSLog(@"111control:%@",control);
            }
         self.navigationController.navigationBar.hidden = YES;
         [self.navigationController popViewControllerAnimated:YES];
   //     }else
    //    {
    //        m_timeSince1970 = timeInt;
   //     }
        
    }
}
//- (void) fetchPhotosFromPhotoAlbum
//{
//    dispatch_semaphore_t sem = nil;
//    BOOL working = NO;
//    NSLog(@"准备扫描图片库, 等待访问信号");
//    
//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    
//    NSLog(@"------ 扫描设置中(锁定扫描库)");
//    
//    working = YES;
//    
//    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    NSMutableArray* tempUrlListArray = [[NSMutableArray alloc] init];    //临时url集合
//    
//    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror)
//    {
//        
//        NSLog(@"error occour =%@", [myerror localizedDescription]);
//        
//
//    };
//    
//    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop)
//    {
//        
//        //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//        
//        if (result!=NULL) {
//            //we can get all the things in the  defaultRepresentation  such as size info in UTI
//            
//        }
//        
//        //NSLog(@"find: %@", url);
//        
//        //just fetching photos
//        if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
//        {
//            
//            NSURL *url = [[result defaultRepresentation] url];
//            
//            [tempUrlListArray addObject:url];
//        }
//        
//        //[pool release];
//    };
//    
//    ALAssetsLibraryGroupsEnumerationResultsBlock
//    libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
//        
//        
//        if (group != nil)
//        {
//            [group enumerateAssetsUsingBlock:groupEnumerAtion];
//        }
//        else
//        {
//            NSLog(@"------ 扫描结束");
// 
//            
//            dispatch_semaphore_signal(sem);
//            
//
//            
//            [tempUrlListArray release];//释放临时url集合
//        }
//        
//    };
//    
////    //异步的
////    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary | ALAssetsGroupSavedPhotos
////                                usingBlock:libraryGroupsEnumeration
////                              failureBlock:failureblock];
//    
//    
//    
//    NSLog(@"------ 扫描设置结束, 等待扫描任务启动");
//    
//    //[pool release];
//}


//- (void) getImage:(NSArray *)arrUrl
//{
//    
//    for (int i=0; i < [arrUrl count]; i ++) {
//        
//    
//        
//        
//        
//        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
//        
//        NSURL *url=[NSURL URLWithString:[arrUrl objectAtIndex:i]];
//        
//        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
//        {
//            
//            UIImage *img=[UIImage imageWithCGImage:asset.thumbnail];
//            
//           // [m_arrayStoreImage addObject:<#(id)#>];
//            [m_arrayStoreImage addObject:[NSDictionary dictionaryWithObjectsAndKeys:image,@"IMAGE",strInfo,@"PATH",nil]];
//            
//        }failureBlock:^(NSError *error) {
//            
//            NSLog(@"error=%@",error);
//            
//        }
//         
//         ];
//}

@end
