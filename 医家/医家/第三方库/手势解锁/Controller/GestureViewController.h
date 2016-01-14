
#import <UIKit/UIKit.h>

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureViewController : UIViewController

/**
 *  判断是否是Model
 */
@property (nonatomic)BOOL isNAV;
/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@end
