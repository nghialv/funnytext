//
//  CircleTextView.m
//  FunnyText
//
//  Created by iNghia on 6/21/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "CircleTextView.h"
#import <CoreText/CoreText.h>

@implementation CircleTextView
@synthesize attString = m_attString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /// drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    // create a CTFramesetter and an instance of CTTypesetter is automatically created
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)m_attString);
    // create path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path,
                 NULL,
                 self.bounds.size.width/2,
                 self.bounds.size.height/2,
                 MIN(self.bounds.size.width/2, self.bounds.size.height/2),
                 -M_PI,
                 M_PI,
                 YES);
    // draw
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(frame);
}


@end
