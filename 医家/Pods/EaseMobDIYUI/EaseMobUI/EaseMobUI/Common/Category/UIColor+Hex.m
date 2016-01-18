
#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+(UIColor *) colorWithHexRGB:(NSInteger)hexRGB {
    Byte blue = hexRGB & 0xFF;
    Byte green = (hexRGB >> 8) & 0xFF;
    Byte red = (hexRGB >> 16) & 0xFF;
    
    return  [UIColor colorWithRed: (CGFloat)red / 255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:1.0f];
}

+(UIColor * )colorWithHexRGB:(NSInteger)hexRGB Alpha:(CGFloat)alpha {
    Byte blue = hexRGB & 0xFF;
    Byte green = (hexRGB >> 8) & 0xFF;
    Byte red = (hexRGB >> 16) & 0xFF;
    
    return  [UIColor colorWithRed: (CGFloat)red / 255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:alpha];
}

+(UIColor *) colorWithHexARGB:(NSInteger)hexARGB {
    NSInteger rgb = 0xFFFFFF & hexARGB;
    NSInteger alpha = (hexARGB >> 24) & 0xFF;
    
    return  [UIColor colorWithHexRGB:rgb Alpha:alpha];
}

+ (UIColor *)colorWithHEX:(NSString *)HEXColorStr alpha:(CGFloat)alphaValue{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[HEXColorStr substringWithRange:range]] scanHexInt:&red];
    
    range.location = 3;
    [[NSScanner scannerWithString:[HEXColorStr substringWithRange:range]] scanHexInt:&green];
    
    range.location = 5;
    [[NSScanner scannerWithString:[HEXColorStr substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alphaValue];
}

@end
