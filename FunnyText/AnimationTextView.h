//
//  AnimationTextView.h
//  FunnyText
//
//  Created by iNghia on 6/21/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface AnimationTextView : UIView

@property (nonatomic, retain) NSAttributedString *attrString;

-(void)startAnimation;

@end
