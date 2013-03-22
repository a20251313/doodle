//
//  RJFViewController.m
//  Doodle
//
//  Created by ran on 12-10-24.
//  Copyright (c) 2012年 com.o-popo. All rights reserved.
//

#import "RJFViewController.h"
#import "UIImge-GetSubImage.h"
#import "RJFDraftTbControlViewController.h"
#import "RJFRecommandViewController.h"

#define RECT

@interface RJFViewController ()

@end

@implementation RJFViewController
@synthesize bgImage = m_bgimage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_bCanDraw = YES;
    m_bISMoved = NO;
    m_CanErase = NO;
    canErase = NO;
    self.bgImage = nil;
    firstErase = 0;
    m_arrayStoreTempPoint = [[NSMutableArray alloc] init];
    m_arrStorePainInfo = [[NSMutableArray alloc] init];
    [viweForChoose setBackgroundColor:[UIColor clearColor]];
    [viweForChoose setFrame:CGRectMake(0, 480-viweForChoose.frame.size.height-20, viweForChoose.frame.size.width, viweForChoose.frame.size.height)];
    [btnShowView setHidden:YES];
    [viweForChoose setDelegate:self];
    [self.view addSubview:viweForChoose];
    [viweForChoose InitWithImage:nil];
   
   // CGRect  rect  = CGRectMake(10, 7, 304, 473)
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
   

    if (self.bgImage != nil)
    {
       drawView.image = self.bgImage; 
    }
    
    
    //NSLog(@"image:%@",self.bgImage);
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.bgImage = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ClickAppRecommand:(UIButton *)sender
{
    RJFRecommandViewController  *control = [[[RJFRecommandViewController alloc] initWithNibName:@"RJFRecommandViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:control animated:YES];
}

-(IBAction)ClickShowView:(UIButton *)sender
{
    if (viweForChoose.hidden)
    {
        sender.hidden = NO;
    }else
    {
        sender.hidden = YES;
    }
    [viweForChoose setHidden:!viweForChoose.hidden];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [btnShowView setHidden:NO];
    [viweForChoose setHidden:YES];
    if (!m_bCanDraw)
    {
        [m_arrayStoreTempPoint removeAllObjects];
        return;
    }
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    if (CGRectContainsPoint(drawView.frame, lastPoint))
    {
       // NSLog(@"draw view:%@",drawView);
        [self setClearFunctionEnable:YES];
    }else
    {
        return;
    }
    m_bISMoved = NO;

	if (!canErase)
    {
		UITouch *touch = [touches anyObject];
		lastPoint = [touch locationInView:self.view];
        [m_arrayStoreTempPoint addObject:[NSValue valueWithCGPoint:lastPoint]];
	}
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!m_bCanDraw)
    {
        return;
    }
    m_bISMoved = YES;
	UITouch *touch = [touches anyObject];
	
	CGPoint currentPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(drawView.frame, currentPoint))
    {
        [self setClearFunctionEnable:YES];
    }else
    {
        return;
    }
	
	CGColorRef color = [self getSegmentColor:segmentColor];
    // CGContextRef    context = UIGraphicsGetCurrentContext();
	if (!canErase)
    {
        int linewith = segmentWidth;
        if (m_CanErase)
        {
            color = [self getSegmentColor:0];
            linewith = 4*2;
        }
		UIGraphicsBeginImageContext(drawView.frame.size);
		[drawView.image drawInRect:CGRectMake(0, 0, drawView.frame.size.width, drawView.frame.size.height)];
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), linewith);
		CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color);
		CGContextBeginPath(UIGraphicsGetCurrentContext());
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		drawView.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        lastPoint = currentPoint;
        firstErase = YES;
        [m_arrayStoreTempPoint addObject:[NSValue valueWithCGPoint:currentPoint]];
        
        
	}else
    {
        
        if (firstErase)
        {
            lastPointErase = currentPoint;
        }
        
        UIGraphicsBeginImageContext(drawView.frame.size);
		[drawView.image drawInRect:CGRectMake(0, 0, drawView.frame.size.width, drawView.frame.size.height)];
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeClear);
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), eraseWidth);
		CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor clearColor].CGColor);
		CGContextBeginPath(UIGraphicsGetCurrentContext());
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPointErase.x, lastPointErase.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		drawView.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
        lastPointErase = currentPoint;
        
        firstErase = NO;
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!m_bCanDraw)
    {
        return;
    }
    
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(drawView.frame, lastPoint))
    {
        [self setClearFunctionEnable:YES];
    }else if(![m_arrayStoreTempPoint count])
    {
        // [m_arrayStoreTempPoint removeAllObjects];
        return;
    }
	
	CGColorRef color = [self getSegmentColor:segmentColor];
	if (!canErase)
    {
        int linewith = segmentWidth;
        if (m_CanErase)
        {
            color = [self getSegmentColor:0];
            linewith = 4*2;
        }
        //   CGContextRef    context = UIGraphicsGetCurrentContext();
		UIGraphicsBeginImageContext(drawView.frame.size);
		[drawView.image drawInRect:CGRectMake(0, 0, drawView.frame.size.width, drawView.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), linewith);
		CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color);
		CGContextBeginPath(UIGraphicsGetCurrentContext());
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		drawView.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
        if (m_bISMoved && [m_arrayStoreTempPoint count])
        {
            [m_arrayStoreTempPoint addObject:[NSValue valueWithCGPoint:lastPoint]];
        }else if([m_arrayStoreTempPoint count])
        {
            [m_arrayStoreTempPoint removeAllObjects];
            [m_arrayStoreTempPoint addObject:[NSValue valueWithCGPoint:lastPoint]];
            [m_arrayStoreTempPoint addObject:[NSValue valueWithCGPoint:lastPoint]];
            
            
        }
	}else
    {
        firstErase = YES;
    }
    
    
    if ([m_arrayStoreTempPoint count])
    {
        NSDictionary    *dicdrawInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:segmentWidth],LINEWIDTH,[NSNumber numberWithInt:segmentColor],COLORCHOOSE,[NSArray arrayWithArray:m_arrayStoreTempPoint],POINTS,nil];
        [m_arrayStoreTempPoint removeAllObjects];
        [m_arrStorePainInfo addObject:dicdrawInfo];
        
    }
    
    
    
    
}

-(void)setClearFunctionEnable:(BOOL)bEnable
{

}
-(CGColorRef)getSegmentColor:(int)segment
{
    CGColorRef color = [[UIColor blackColor] CGColor];
	
	switch (segment)
	{
		case 1:
			color=[[UIColor blackColor] CGColor];
			break;
        case 0:
		case 2:
			color=[[UIColor whiteColor] CGColor];
			break;
		case 3:
			color=[[UIColor blueColor] CGColor];
			break;
		case 4:
			color=[[UIColor yellowColor] CGColor];
			break;
		case 5:
			color=[[UIColor orangeColor] CGColor];
			break;
		case 6:
			color=[[UIColor redColor] CGColor];
			break;
		case 7:
			color=[[UIColor purpleColor] CGColor];
			break;
        
            //color = [[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1] CGColor];
            //break;
		default:
			break;
	}
	
	return color;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex] && m_buttonpressed == saveButtonPressed)
    {
       
        [self setButtonAndViewHidden:YES];
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        image = [image getSubImage:drawView.frame];
        UIGraphicsEndImageContext();
        [self writeToLocalfile:image];
        
        // UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        
        //[self.delegate sendDoodleImage:image];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        // drawImage.image = nil;
        // [self setClearFunctionEnable:NO];
        // [m_arrStorePainInfo removeAllObjects];
        
        drawView.image = nil;// [UIImage imageNamed:@"main_bg.png"];
        [self setClearFunctionEnable:NO];
        [m_arrStorePainInfo removeAllObjects];
        [self setButtonAndViewHidden:YES];
        
    }else if (buttonIndex == [alertView cancelButtonIndex] && m_buttonpressed == deletePuttonPressed)
    {
        drawView.image = nil;//[UIImage imageNamed:@"main_bg.png"];
        [self setClearFunctionEnable:NO];
        [m_arrStorePainInfo removeAllObjects];
    }
     [viweForChoose ClickSureAction:1];
    [self setButtonAndViewHidden:NO];
   
}

-(void)writeToLocalfile:(UIImage*)image
{
    
    NSAutoreleasePool   *pool = [[NSAutoreleasePool alloc] init];
    NSFileManager  *fileManger = [NSFileManager defaultManager];
    NSData  *data = UIImageJPEGRepresentation(image, 1);
    NSString    *FilePathDir = IMAGEPATH;
    int i = 0;
    if (![fileManger fileExistsAtPath:FilePathDir])
    {
        NSError  *error = nil;
        [fileManger createDirectoryAtPath:FilePathDir
              withIntermediateDirectories:NO
                               attributes:nil
                                    error:&error];
        if (error)
        {
            NSLog(@"error:%@",[error localizedDescription]);
        }
    }
    NSString    *TempPath = [FilePathDir stringByAppendingFormat:@"/%d.png",i];
    while ([fileManger fileExistsAtPath:TempPath])
    {
        i++;
        TempPath = [FilePathDir stringByAppendingFormat:@"/%d.png",i];
    }
    
    if (![fileManger fileExistsAtPath:TempPath])
    {
        
        if([fileManger createFileAtPath:TempPath contents:data attributes:nil])
        {
             NSLog(@"save sucee");
        }else
        {
            NSLog(@"fail save");
        };
    }else
    {
        NSFileHandle  *fileHandle = [NSFileHandle fileHandleForWritingAtPath:TempPath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle synchronizeFile];
    }
    
     UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    [pool drain];
}

-(void)RefreshChoose:(id)view
{
    
    NSInteger  action = viweForChoose.ActionNumber;
    if (action != m_actionNumber)
    {
        if (action == 4)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"是否清空画板？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
            [alert show];
            [alert release];
            m_buttonpressed = deletePuttonPressed;
            
        }else if(action == 5)
        {
            RJFDraftTbControlViewController  *control = [[[RJFDraftTbControlViewController alloc] initWithNibName:@"RJFDraftTbControlViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:control animated:YES];
             [viweForChoose ClickSureAction:1];
        }else if (action == 6)
        {
            if (![m_arrStorePainInfo count])
            {
                UIActionSheet   *ac = [[[UIActionSheet alloc] initWithTitle:@"亲，你画一下吧！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"嗯，好吧！"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:nil, nil] autorelease];
                [ac showInView:self.view];
                [viweForChoose ClickSureAction:1];
                
                return;
            }
            
            
            
           
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"确认保存？"
                                                        delegate:self
                                               cancelButtonTitle:@"确认"
                                               otherButtonTitles:@"取消", nil];
            [av autorelease];
            [av show];
            m_buttonpressed = saveButtonPressed;
            
        }
        
           
        
    }
    
    segmentColor = viweForChoose.colorNumber;
    segmentWidth = viweForChoose.lineWidth*2;
    eraseWidth = viweForChoose.eraseLinewidth*2;
    m_actionNumber = viweForChoose.ActionNumber;
    if (m_actionNumber == 3)
    {
        m_CanErase = YES;
    }else
    {
        m_CanErase = NO;
    }
    
   // NSLog(@"now linewidth:%d nowcolor:%d now erasewidth:%d",segmentWidth,segmentColor,eraseWidth);
    
}

-(void)setButtonAndViewHidden:(BOOL)bHide
{
    [btnShowView setHidden:bHide];
    [btnAppRecommand setHidden:bHide];
    [btnAbout setHidden:bHide];
    [viweForChoose setHidden:bHide];
    [imageViewHead setHidden:bHide];
}

-(IBAction)showAboutView:(id)sender
{
    m_bCanDraw = NO;
    for (UIView *view in [self.view subviews])
    {
        [view setUserInteractionEnabled:NO];
    }
    
    [self.view addSubview:[self aboutView]];
}
-(void)remoVeAboutView:(id)sender
{
    m_bCanDraw = YES;
    for (UIView *view in [self.view subviews])
    {
        [view setUserInteractionEnabled:YES];
    }
    if ([sender superview])
    {
        [[sender superview] removeFromSuperview];
    }
}
-(UIView *)aboutView
{
    
    CGFloat   fwidth = 240;
    //UIAlertView  *alertView = [[UIAlertView alloc] init];
    UIColor *color = [UIColor colorWithRed:32.0f/255 green:43.0f/255 blue:81.0f/255 alpha:0.8];
    //UIColor *color = [UIColor colorWithRed:32.0f green:43.0f blue:81.0f alpha:1];
    //[alertView release];
    CGFloat fheight = 20;
    CGFloat labelHeight = 20;
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake((320-fwidth)/2, 80, fwidth, 225)];
    [view setBackgroundColor:color];
    UILabel     *label = [[UILabel alloc] initWithFrame:CGRectMake(0, fheight, fwidth, labelHeight)];
    [label setText:@"iDraw"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    [label release];
    
    //UIFont   *font = [UIFont fontWithName:@"Cochin Bold" size:17];
    fheight += labelHeight+5;
    UILabel     *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, fheight, fwidth, labelHeight)];
    [label1 setText:@"版本: 1.1.0"];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont systemFontOfSize:17]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:[UIColor whiteColor]];
    [view addSubview:label1];
    [label1 release];
    
    
    fheight += labelHeight+5;
    UILabel     *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, fheight, fwidth, labelHeight)];
    [label2 setText:@"Copyright© 2012"];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont systemFontOfSize:17]];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:[UIColor whiteColor]];
    [view addSubview:label2];
    [label2 release];
    
    fheight += labelHeight+5;
    UILabel     *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, fheight, fwidth, labelHeight)];
    [label3 setText:@"All Rights Reserved"];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setFont:[UIFont systemFontOfSize:17]];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label3 setTextColor:[UIColor whiteColor]];
    [view addSubview:label3];
    [label3 release];
    
    
    fheight += labelHeight+5;
    UILabel     *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, fheight, fwidth, labelHeight)];
    [label4 setText:@"wap.i366.com"];
    [label4 setBackgroundColor:[UIColor clearColor]];
    [label4 setFont:[UIFont systemFontOfSize:17]];
    [label4 setTextAlignment:NSTextAlignmentCenter];
    [label4 setTextColor:[UIColor whiteColor]];
    [view addSubview:label4];
    [label4 release];
    
    fheight += labelHeight+5+5;
    UILabel     *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, fheight, fwidth, labelHeight)];
    [label5 setText:@"鱼游公司 版权所有"];
    [label5 setBackgroundColor:[UIColor clearColor]];
    [label5 setFont:[UIFont systemFontOfSize:17]];
    [label5 setTextAlignment:NSTextAlignmentCenter];
    [label5 setTextColor:[UIColor whiteColor]];
    [view addSubview:label5];
    [label5 release];
    
    fheight += labelHeight+5;
    UIButton     *button = [[UIButton alloc] initWithFrame:CGRectMake((fwidth-150)/2, fheight, 150, labelHeight*2)];
    [button setTitle:@"关   闭" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(remoVeAboutView:)
     forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button release];
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0f;
    return  [view autorelease];
}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return <#expression#>
//}

-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
#if 0
    NSString *message = nil;
    NSString *title = nil;
    if (!error)
    {
        title = @"成功提示";
        message = @"成功保存到相册";
    } else {
        title = @"失败提示";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
#endif
}

-(void)dealloc
{
    if (m_arrayStoreTempPoint)
    {
        [m_arrayStoreTempPoint removeAllObjects];
        m_arrayStoreTempPoint = nil;
        
    }
    if (m_arrStorePainInfo)
    {
        [m_arrStorePainInfo removeAllObjects];
        m_arrStorePainInfo = nil;
    }
    self.bgImage = nil;
    
    [super dealloc];
}


@end
