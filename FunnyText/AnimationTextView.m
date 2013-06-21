//
//  AnimationTextView.m
//  FunnyText
//
//  Created by iNghia on 6/21/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "AnimationTextView.h"

@interface AnimationTextView ()

@property (nonatomic, assign) float curX;
@property (nonatomic, assign) BOOL moving;
@property (nonatomic, retain) NSMutableArray *glyphMatrix;

@end

@implementation AnimationTextView
@synthesize attrString = m_attrString;
@synthesize curX = m_curX;
@synthesize moving = m_moving;
@synthesize glyphMatrix = m_glyphMarix;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        m_glyphMarix = [[NSMutableArray alloc] init];
        m_curX = 20.0f;
        m_moving = NO;
    }
    return self;
}

- (void)setAttrString:(NSAttributedString *)attrString {
    m_attrString = attrString;
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)m_attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);
    
    for (CFIndex runIndex = 0; runIndex < runCount; runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CFIndex runGlyphCount = CTRunGetGlyphCount(run);
        CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            // get width
            CFRange glyphRange = CFRangeMake(runGlyphIndex, 1);
            // calculate position
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            CGAffineTransform curMatrix = textMatrix;
            curMatrix = CGAffineTransformTranslate(curMatrix, m_curX + position.x, position.y);
            curMatrix = CGAffineTransformRotate(curMatrix, M_PI_4);
            [m_glyphMarix addObject:[NSValue valueWithCGAffineTransform:curMatrix]];
        }
    }
    CFRelease(line);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    // draw
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)m_attrString);
    //m_curX += 0.1f;
    CGPoint textPosition = CGPointMake(m_curX, self.bounds.size.height/2);
    
    CFIndex glyphCount = CTLineGetGlyphCount(line);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);
    NSLog(@"First Line: glyph = %d, run = %d¥n", (int)glyphCount, (int)runCount);
    
    CGContextSetTextPosition(context, textPosition.x, textPosition.y);
    int index = 0;
    for (CFIndex runIndex = 0; runIndex < runCount; runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CFIndex runGlyphCount = CTRunGetGlyphCount(run);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        // set font
        CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
        CGContextSetFont(context, cgFont);
        CGContextSetFontSize(context, CTFontGetSize(runFont));
        // run matrix
        //CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            // get width
            CFRange glyphRange = CFRangeMake(runGlyphIndex, 1);
            //CGFloat glyphWidth = CTRunGetTypographicBounds((CTRunRef)run, CFRangeMake(runGlyphIndex, 1), NULL, NULL, NULL);
            // calculate position
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            NSInteger currentIndex = [[NSNumber numberWithInt:index] integerValue];
            CGAffineTransform curMatrix = [[m_glyphMarix objectAtIndex:currentIndex] CGAffineTransformValue];
            if(m_moving) {
                float vel = ((float)rand()/RAND_MAX)*100.0f;
                curMatrix = CGAffineTransformTranslate(curMatrix, 50.0f+vel, vel);
                float angle = ((float)rand()/RAND_MAX)*M_PI;
                curMatrix = CGAffineTransformScale(curMatrix, 1.5, 1.5);
                curMatrix = CGAffineTransformRotate(curMatrix, angle);
                [m_glyphMarix setObject:[NSValue valueWithCGAffineTransform:curMatrix] atIndexedSubscript:currentIndex];
            }
            //curMatrix = CGAffineTransformTranslate(curMatrix, m_curX + position.x, position.y);
            //curMatrix = CGAffineTransformRotate(curMatrix, M_PI_4);
            CGContextSetTextMatrix(context, curMatrix);
            // draw
            CGContextShowGlyphs(context, &glyph, 1);
            index++;
        }
        CFRelease(cgFont);
    }
    CFRelease(line);
    m_moving = NO;
}

- (void)startAnimation
{
    NSLog(@"Start Animation¥n");
    // animation from here
    m_moving = YES;
    [self setNeedsDisplay];
}

- (void)endAnimation
{
    NSLog(@"End Animation¥n");
}

@end
