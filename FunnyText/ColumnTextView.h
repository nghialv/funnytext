//
//  ColumnTextView.h
//  FunnyText
//
//  Created by iNghia on 6/20/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface ColumnTextView : UIView

@property (nonatomic, retain) NSAttributedString *attString;
@property (nonatomic, assign) float colMargin;
@property (nonatomic, assign) int numOfColumns;

@end
