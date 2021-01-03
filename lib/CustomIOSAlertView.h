#import <UIKit/UIKit.h>

@protocol CustomIOSAlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView
                       clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomIOSAlertView : UIView <CustomIOSAlertViewDelegate>

@property(nonatomic, retain)
    UIView *parentView; // The parent view this 'dialog' is attached to
@property(nonatomic, retain) UIView *dialogView; // Dialog's container view
@property(nonatomic, retain) UIView
    *containerView; // Container within the dialog (place your ui elements here)

@property(nonatomic, assign) id<CustomIOSAlertViewDelegate> delegate;
@property(nonatomic, retain) NSArray *buttonTitles;
@property(nonatomic, assign) BOOL useMotionEffects;
@property(nonatomic, assign)
    BOOL closeOnTouchUpOutside; // Closes the AlertView when finger is lifted
                                // outside the bounds.

@property(copy) void (^onButtonTouchUpInside)
    (CustomIOSAlertView *alertView, int buttonIndex);

- (id)init;

- (void)show;
- (void)close;

- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;

- (void)setOnButtonTouchUpInside:
    (void (^)(CustomIOSAlertView *alertView,
              int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)dealloc;

@end
