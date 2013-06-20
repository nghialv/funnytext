//
//  MainViewController.m
//  FunnyText
//
//  Created by iNghia on 6/20/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "MainViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "CustomView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    NSString *textContent = [NSString stringWithContentsOfFile:filePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Verdana", 20.0f, NULL);
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)fontRef,
                                    (NSString *)kCTFontAttributeName,
                                    (id)[[UIColor blackColor] CGColor],
                                    (NSString *)kCTForegroundColorAttributeName, NULL];
    CFRelease(fontRef);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textContent attributes:attrDictionary];
    CTFontRef fontRefBold = CTFontCreateWithName((CFStringRef)@"Verdana-Bold", 30.0f, NULL);
    NSDictionary *attrDictionaryBold = [NSDictionary dictionaryWithObjectsAndKeys:
                                        (__bridge id)fontRefBold,
                                        (NSString *)kCTFontAttributeName,
                                        (id)[[UIColor redColor] CGColor],
                                        (NSString *)kCTForegroundColorAttributeName, nil];
    [attrString addAttributes:attrDictionaryBold range:NSMakeRange(0, 12)];
    CFRelease(fontRefBold);
    
    CustomView *cusView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height/2)];
    [cusView setAttString:attrString];
    [self.view addSubview:cusView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
