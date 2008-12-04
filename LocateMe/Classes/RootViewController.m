/*

File: RootViewController.m
Abstract: Root view used to flip between main and reverse views. Subviews use
delegates to tell this view when to flip between them.

Version: 1.1

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "MainViewController.h"
#import "FlipsideViewController.h"


@implementation RootViewController

@synthesize mainViewController;
@synthesize flipsideViewController;

- (void)loadMainViewController {
	MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = viewController;
	self.mainViewController.flipDelegate = self;
	[viewController release];
}

- (void)loadFlipsideViewController {
	FlipsideViewController *viewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	self.flipsideViewController = viewController;
	self.flipsideViewController.flipDelegate = self;
	[viewController release];
}

- (void)viewDidLoad {
	[self loadMainViewController]; // Don't load the flipside view unless / until necessary
	[self.view addSubview:mainViewController.view];
}


// This method is called when either of the subviews send a delegate message to us.
// It flips the displayed view from the whoever sent the message to the other.
- (void)toggleView:(id)sender {
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}
	
	UIView *mainView = mainViewController.view;
	UIView *flipsideView = flipsideViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:((mainViewController == sender) ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if (mainViewController == sender) {
		[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
		[self.view addSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];

	} else {
		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[self.view addSubview:mainView];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[mainViewController release];
	[flipsideViewController release];
	[super dealloc];
}


@end
