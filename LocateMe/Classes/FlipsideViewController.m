/*

File: FlipsideViewController.m
Abstract: Controller class for the "flipside" view, which contains all the
controls for settings.

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

#import "FlipsideViewController.h"
#import "AccuracyPickerItem.h"

@implementation FlipsideViewController

@synthesize flipDelegate, filterControls;
@synthesize accuracyPicker, distanceFilterSwitch, distanceFilterSlider, distanceFilterValueLabel;
@synthesize distanceFilterSliderLabel1, distanceFilterSliderLabel2, distanceFilterSliderLabel3, distanceFilterSliderLabel4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// This array is used to keep the values and associated strings for our picker view
		// The AccuracyPickerItem class is a helper class defined in its own source file
		pickerItems = [[NSArray alloc] initWithObjects:[[[AccuracyPickerItem alloc] initWithName:NSLocalizedString(@"AccuracyBest", @"Best") value:kCLLocationAccuracyBest] autorelease],
					   [[[AccuracyPickerItem alloc] initWithName:NSLocalizedString(@"Accuracy10", @"10 meters") value:kCLLocationAccuracyNearestTenMeters] autorelease],
					   [[[AccuracyPickerItem alloc] initWithName:NSLocalizedString(@"Accuracy100", @"100 meters") value:kCLLocationAccuracyHundredMeters] autorelease],
					   [[[AccuracyPickerItem alloc] initWithName:NSLocalizedString(@"Acurracy1000", @"1 kilometer") value:kCLLocationAccuracyKilometer] autorelease],
					   [[[AccuracyPickerItem alloc] initWithName:NSLocalizedString(@"Accuracy3000", @"3 kilometers") value:kCLLocationAccuracyThreeKilometers] autorelease], nil];
	}
	return self;
}

- (void)viewDidLoad {
	// Special color for "reverse" views
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];		
	
	// This array contains all the controls toggled by the "Distance Filter" switch
	// This allows us to easily enable / disable the controls when the state of the switch changes
	// We do this here instead of in the init because the objects are nil while in the init method
	self.filterControls = [NSArray arrayWithObjects:distanceFilterSlider, distanceFilterValueLabel, distanceFilterSliderLabel1, distanceFilterSliderLabel2, distanceFilterSliderLabel3, distanceFilterSliderLabel4, nil];
}

- (void)viewWillAppear:(BOOL)animated {
	// Set up the controls to the right initial values, based on the current state of the CoreLocation object
	[self setControlStatesFromSource:[MyCLController sharedInstance]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait); // Portrait mode only
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[accuracyPicker release];
	[distanceFilterSwitch release];
	[distanceFilterSlider release];
	[distanceFilterValueLabel release];
	[distanceFilterSliderLabel1 release];
	[distanceFilterSliderLabel2 release];
	[distanceFilterSliderLabel3 release];
	[distanceFilterSliderLabel4 release];
    
	[filterControls release];
	[pickerItems release];
	[super dealloc];
}

#pragma mark ---- UIPickerViewDataSource delegate methods ----

// returns the number of columns to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// returns the number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [pickerItems count];
}

#pragma mark ---- UIPickerViewDelegate delegate methods ----

// returns the title of each row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	AccuracyPickerItem *currentItem = [pickerItems objectAtIndex:row];
	return currentItem.displayName;
}

// gets called when the user settles on a row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	AccuracyPickerItem *currentItem = [pickerItems objectAtIndex:row];
	accuracyToSet = currentItem.accuracyValue;
}

#pragma mark ---- Other control callbacks ----

// Causes the new settings to take effect
// Tells the root view via a delegate to flip back over to the main view
- (IBAction)doneButtonPressed:(id)sender {
	// This is where we actually set the values that the user has chosen. Some apps
	// set the value immediately whenever the user "settles" on a value in a control
	// (such as didSelectRow). We choose to only actually commit the values once the
	// "Done" button has been tapped, and only if they differ from the previous state.
	if (accuracyToSet != previousAccuracy) {
		[MyCLController sharedInstance].locationManager.desiredAccuracy = accuracyToSet;
	}
	if (filterToSet != previousFilter) {
		[MyCLController sharedInstance].locationManager.distanceFilter = filterToSet;
	}

	// Tell the root view to flip back over to the main view
	[self.flipDelegate toggleView:self];
}

// Toggles the "enabled" state all of the controls associated with the filter value
- (void) setFilterControlsEnabled:(BOOL)state {
	for (UIControl *control in filterControls) {
		control.enabled = state;
	}
}

// Called when the switch is flipped
- (IBAction)switchAction:(id)sender {
	BOOL newState = [sender isOn];
	
	// Controls are disabled if switch is off
	[self setFilterControlsEnabled:newState];
	
	// If the switch is on, distance filter is current slider value, otherwise set it to "none"
	if ( newState ) {
		[self sliderValueChanged:self];
	} else {
		filterToSet = kCLDistanceFilterNone;
	}
}

// Takes the value of the slider and puts it in a label underneath it
- (void) updateSliderLabel {
	double value = pow(10, [distanceFilterSlider value]);
	distanceFilterValueLabel.text = [NSString stringWithFormat:@"%.0f %@", value, (value < 1.5) ? NSLocalizedString(@"MeterSingular", @"meter") : NSLocalizedString(@"MeterPlural", @"meters")];
}

// Called when the slider is moved, with live updating
- (IBAction)sliderValueChanged:(id)sender {
	// The distance filter slider is an exponential scale, base 10.
	// Slider returns a value in the range 0.0 to 3.0 (set in Interface Builder).
	// Corresponds to a range of 1 to 1000, exponentially.
	filterToSet = pow(10, distanceFilterSlider.value);
	[self updateSliderLabel];
}

// Sets the state of the controls based on the state of the location manager
- (void) setControlStatesFromSource:(MyCLController *) clDelegate {
	// Current values from the source object
	previousAccuracy = accuracyToSet = clDelegate.locationManager.desiredAccuracy;
	previousFilter = filterToSet = clDelegate.locationManager.distanceFilter;
	
	// Set up accuracy controls
	for (AccuracyPickerItem *currentItem in pickerItems) {
		if (currentItem.accuracyValue == previousAccuracy) {
			[accuracyPicker selectRow:[pickerItems indexOfObject:currentItem] inComponent:0 animated:NO];
		}
	}
	
	// Set up filter controls
	// Since the slider is exponential (base 10), converting the other way is done with a base 10 logarithm.
	// If the filter is set to "none", we choose a default value of 10 (log10 of which is 1, hard coded below).
	[distanceFilterSwitch setOn:(previousFilter != kCLDistanceFilterNone) animated:NO];
	[distanceFilterSlider setValue:((previousFilter == kCLDistanceFilterNone) ? 1 : log10(fabs(previousFilter))) animated:NO];
	[self updateSliderLabel];
	[self setFilterControlsEnabled:[distanceFilterSwitch isOn]];
}	

@end
