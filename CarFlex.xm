#import <UIKit/UIKit.h>
#include <dlfcn.h>
#include <rootless.h>

@interface DBIconView : UIView
- (void)showFlexWindow:(UILongPressGestureRecognizer *)recognizerl;
@end

@interface _DBCornerRadiusWindow : UIWindow
@end

@interface FLEXManager : NSObject
+ (FLEXManager *)sharedManager;
- (UIWindow *)explorerWindow;
- (void)showExplorer;
@end

%group Tweak
%hook DBIconView
- (void)didMoveToWindow {
	%orig;
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showFlexWindow:)];
    longPress.minimumPressDuration = 2.0;
    [self addGestureRecognizer:longPress];
}
%new
- (void)showFlexWindow:(UILongPressGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		_DBCornerRadiusWindow *targetWindow;
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for (UIWindow *window in windows) {
			if ([window isKindOfClass:%c(_DBCornerRadiusWindow)]) {
				targetWindow = (_DBCornerRadiusWindow *)window;
			}
		}
		FLEXManager *manager = [%c(FLEXManager) sharedManager];
		[manager showExplorer];
		[[manager explorerWindow] setWindowScene:[targetWindow windowScene]];
	}
}
%end
%end

%ctor {
	dlopen(ROOT_PATH("/Library/MobileSubstrate/DynamicLibraries/libFLEX.dylib"), RTLD_LAZY);
	%init(Tweak);
}