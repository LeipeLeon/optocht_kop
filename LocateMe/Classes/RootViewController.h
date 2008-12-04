/*

File: RootViewController.h
Abstract: Root view used to flip between main and reverse views. Subviews use
delegates to tell this view when to flip between them.

Version: 1.1


*/


// This protocol is used to tell the root view to flip between views
@protocol MyFlipControllerDelegate <NSObject>
@required
-(void)toggleView:(id)sender;
@end

@class MainViewController;
@class FlipsideViewController;

@interface RootViewController : UIViewController <MyFlipControllerDelegate> {
	MainViewController *mainViewController;
	FlipsideViewController *flipsideViewController;
}

@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;

@end
