//
//  MainViewController.m
//  FunnyText
//
//  Created by iNghia on 6/20/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "MainViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FUIButton.h>
#import "ColumnTextView.h"
#import "CircleTextView.h"
#import "AnimationTextView.h"

@interface MainViewController ()

@property (nonatomic, retain) AnimationTextView *animationTextView;

@end

@implementation MainViewController
@synthesize animationTextView = m_animationTextView;

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
    // add scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setScrollEnabled:YES];
    [scrollView setUserInteractionEnabled:YES];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2)];
    [self.view addSubview:scrollView];
    // read text
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    NSString *textContent = [NSString stringWithContentsOfFile:filePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Verdana", 20.0f, NULL);
    NSDictionary *attrDictionary =  @{ (NSString*)kCTFontAttributeName: (__bridge id)fontRef,
                                        (NSString*)kCTForegroundColorAttributeName: (id)[[UIColor blackColor] CGColor] };
    CFRelease(fontRef);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textContent attributes:attrDictionary];
    CTFontRef fontRefBold = CTFontCreateWithName((CFStringRef)@"Verdana-Bold", 30.0f, NULL);
    NSDictionary *attrDictionaryBold = @{ (NSString *)kCTFontAttributeName: (__bridge id)fontRefBold,
                                          (NSString *)kCTForegroundColorAttributeName: (id)[[UIColor redColor] CGColor] };
    
    [attrString addAttributes:attrDictionaryBold range:NSMakeRange(91, 13)];
    CFRelease(fontRefBold);
    
    ColumnTextView *cusView = [[ColumnTextView alloc] initWithFrame:CGRectMake(0, 0,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height/2)];
    [cusView setAttString:attrString];
    [scrollView addSubview:cusView];
    // circle text
    CircleTextView *circlceView = [[CircleTextView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2,
                                                                                   self.view.bounds.size.height/2,
                                                                                   self.view.bounds.size.width/2,
                                                                                   self.view.bounds.size.height/2-100.0f)];
    [circlceView setAttString:attrString];
    [scrollView addSubview:circlceView];
    // animation text
    m_animationTextView = [[AnimationTextView alloc] initWithFrame:CGRectMake(0,
                                                                              self.view.bounds.size.height/2,
                                                                              self.view.bounds.size.width/2,
                                                                              self.view.bounds.size.height/2-100.0f)];
    CTFontRef font2Ref = CTFontCreateWithName((CFStringRef)@"Verdana-Bold", 50.0f, NULL);
    NSDictionary *attr2Dictionary =  @{ (NSString*)kCTFontAttributeName: (__bridge id)font2Ref,
                                       (NSString*)kCTForegroundColorAttributeName: (id)[[UIColor blackColor] CGColor] };
    CFRelease(font2Ref);
    NSMutableAttributedString *attr2String = [[NSMutableAttributedString alloc] initWithString:@"funny text" attributes:attr2Dictionary];
    [m_animationTextView setAttrString:attr2String];
    [scrollView addSubview:m_animationTextView];
    // button
    FUIButton *animationBtn = [[FUIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 -50.0f,
                                                                         self.view.bounds.size.height-65.0f,
                                                                         100.0f,
                                                                         45.0f)];
    [animationBtn setTitle:@"Start" forState:UIControlStateNormal];
    animationBtn.buttonColor = [UIColor greenSeaColor];
    animationBtn.cornerRadius = 3.0f;
    animationBtn.shadowColor = [UIColor cloudsColor];
    animationBtn.shadowHeight = 1.0f;
    [animationBtn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:animationBtn];
}

- (void)startAnimation
{
    [m_animationTextView startAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
