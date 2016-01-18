
#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *) colorWithHexRGB:(NSInteger) hexRGB;
+ (UIColor *) colorWithHexRGB:(NSInteger) hexRGB Alpha:(CGFloat) alpha;
+ (UIColor *) colorWithHexARGB:(NSInteger) hexARGB;
+ (UIColor *)colorWithHEX:(NSString *)HEXColorStr alpha:(CGFloat)alphaValue;

@end
