//
//  CustomView.m
//  FunnyText
//
//  Created by iNghia on 6/20/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
@synthesize attString = m_attString;
@synthesize colMargin = m_colMargin;
@synthesize numOfColumns = m_numOfColumns;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        m_colMargin = 10.0f;
        m_numOfColumns = 2;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 150, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextRotateCTM(context, M_PI_2/5);
    
    // create a CTFramesetter and an instance of CTTypesetter is automatically created
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)m_attString);
    // create columnPaths
    CFMutableArrayRef columnPaths = CFArrayCreateMutable(kCFAllocatorDefault,
                                                   m_numOfColumns,
                                                   &kCFTypeArrayCallBacks);
    float colWidth = self.bounds.size.width/m_numOfColumns;
    float colHeight = self.bounds.size.height;
    for(int i=0; i<m_numOfColumns; i++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(i*colWidth + m_colMargin,
                                            0.0f + m_colMargin,
                                            colWidth - 2*m_colMargin,
                                            colHeight - 2*m_colMargin));
        CFArrayInsertValueAtIndex(columnPaths, i, path);
        CFRelease(path);
    }
    // draw
    CFIndex startIndex = 0;
    for (int i=0; i<m_numOfColumns; i++) {
        CGPathRef path = (CGPathRef)CFArrayGetValueAtIndex(columnPaths, i);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        // start the next frame
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    CFRelease(framesetter);
    CFRelease(columnPaths);
}


@end
