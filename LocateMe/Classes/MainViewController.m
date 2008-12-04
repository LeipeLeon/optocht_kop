/*

*/
#import "MainViewController.h"

// Shorthand for getting localized strings, used in formats below for readability
#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

@implementation MainViewController

@synthesize flipDelegate, updateTextView, startStopButton, reloadButton,   spinner, webSite, responseTextView, statusTextView; //, lastWebUpdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		isCurrentlyUpdating = NO;
		firstUpdate = YES;
        sendingRequest = NO;
        lastWebUpdate = [[NSDate date] retain];
        NSLog(@"initWithNib:lastWebUpdate: %@",lastWebUpdate);
	}
	return self;
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
	[updateTextView release];
	[startStopButton release];
    [reloadButton release];
	[spinner release];
	[super dealloc];
}


// Appends some text to the main text view
// If this is the first update, it will replace the existing text
-(void)addTextToLog:(NSString *)text {
	if (firstUpdate) {
		updateTextView.text = text;
		firstUpdate = NO;
	} else {
        NSLog(@"updateTextView.text length: %d", [updateTextView.text length]);
        if ([updateTextView.text length] > 1024) { // haal 512 carakters weg zodat we meer geheugen krijgen
            NSLog(@"updateTextView.text length is groter dan 1024: %d", [updateTextView.text length]);
            NSRange mRange = NSMakeRange(0,512);
            NSMutableString *truncatedText = [[NSMutableString alloc]init];
            [truncatedText appendString:updateTextView.text];
            [truncatedText deleteCharactersInRange:mRange];
            updateTextView.text = truncatedText;
        }
		updateTextView.text = [NSString stringWithFormat:@"%@\n-----------------------------------\n%@", updateTextView.text, text];
		[updateTextView scrollRangeToVisible:NSMakeRange([updateTextView.text length], 0)]; // scroll to the bottom on updates
	}
}

// Called when the view is loading for the first time only
// If you want to do something every time the view appears, use viewWillAppear or viewDidAppear
- (void)viewDidLoad {
	[startStopButton setTitle:NSLocalizedString(@"StartButton", @"Start")];
	[MyCLController sharedInstance].delegate = self;

    // Check to see if the user has disabled location services all together
    // In that case, we just print a message and disable the "Start" button
    if ( ! [MyCLController sharedInstance].locationManager.locationServicesEnabled ) {
        [self addTextToLog:NSLocalizedString(@"NoLocationServices", @"User disabled location services")];
        startStopButton.enabled = NO;
        reloadButton.enabled = NO;
    }
}

#pragma mark ---- control callbacks ----

// Tells the root view, via a delegate, to flip over to the FlipSideView
- (IBAction)infoButtonPressed:(id)sender {
	[self.flipDelegate toggleView:self];
}

// Called when the "start/stop" button is pressed
- (IBAction)startStopButtonPressed:(id)sender {
	if (isCurrentlyUpdating) {
		[[MyCLController sharedInstance].locationManager stopUpdatingLocation];
		isCurrentlyUpdating = NO;
        reloadButton.enabled = NO;
		[startStopButton setTitle:NSLocalizedString(@"StartButton", @"Start")];
        responseTextView.text = @"Stopped";
	} else {
		[[MyCLController sharedInstance].locationManager startUpdatingLocation];
		isCurrentlyUpdating = YES;
		[startStopButton setTitle:NSLocalizedString(@"StopButton", @"Stop")];
        reloadButton.enabled = YES;
        responseTextView.text = @"Starting....";
	}
}
- (IBAction)reloadButtonPressed:(id)sender {
    NSLog(@"reloadButtonPressed!");

    if (self.isSendingRequest) {
        NSLog(@"Connection pending....");
        return;
    }

    CLLocation *location = [MyCLController sharedInstance].locationManager.location;

    [self newStatusUpdate:@"Forced Update."];
	[self newLocationUpdate:[NSString stringWithFormat:LocStr(@"LatLongFormat"), // This format takes 4 args: 2 pairs of the form coordinate + compass direction
                             fabs(location.coordinate.latitude), signbit(location.coordinate.latitude) ? LocStr(@"South") : LocStr(@"North"),
                             fabs(location.coordinate.longitude),	signbit(location.coordinate.longitude) ? LocStr(@"West") : LocStr(@"East")]];
    [self updateWebLocation:MyWebhost withLocation:location];
}

#pragma mark ---- delegate methods for the MyCLController class ----

- (void)newLocationUpdate:(NSString *)text {
	[self addTextToLog:text];
}

-(void)newStatusUpdate:(NSString *)text {
    statusTextView.text = text;
}

- (void)newError:(NSString *)text {
	[self addTextToLog:text];
}

#pragma mark ---- update locations to webserver ----

- (NSTimeInterval)distanceLastWebUpdate {
//	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
//	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    NSLog(@"   lastWebUpdate: %@", [dateFormatter stringFromDate:lastWebUpdate]);
//    
//    NSLog(@"getLastWebUpdate: %@", lastWebUpdate);
//    NSLog(@"getLastWebUpdate: %@", [dateFormatter stringFromDate:[NSDate date]]);
//    NSLog(@"getLastWebUpdate: %.0f", [lastWebUpdate timeIntervalSinceNow]);
//    NSLog(@"getLastWebUpdate: %.0f", [[NSDate date] timeIntervalSinceDate:lastWebUpdate]);
    return [[NSDate date] timeIntervalSinceDate:lastWebUpdate];
}


- (BOOL)isSendingRequest {
    return sendingRequest;
}

- (void)updateLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
    NSLog(@"updateLatitude: %@", latitude);
    NSLog(@"  andLongitude: %@", longitude);

	NSString *FeedURL=[NSString stringWithFormat:@"%@?lat=%@&long=%@&z=", MyWebhost, latitude, longitude];
    NSLog(@"           URL: %@", FeedURL);
    
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:FeedURL]];
	[webSite loadRequest:theRequest];
}

- (void)updateWebLocation:(NSString *)host withLocation:(CLLocation *)newLocation {
    NSString *post = [NSString stringWithFormat:@"location[latitude]=%@&location[longitude]=%@&location[altitude]=%@&location[horizontal_accuracy]=%@&location[vertical_accuracy]=%@", 
                      [NSString stringWithFormat:@"%lf", fabs(newLocation.coordinate.latitude)], 
                      [NSString stringWithFormat:@"%lf", fabs(newLocation.coordinate.longitude)], 
                      [NSString stringWithFormat:@"%lf", fabs(newLocation.altitude)],
                      [NSString stringWithFormat:@"%lf", fabs(newLocation.horizontalAccuracy)],
                      [NSString stringWithFormat:@"%lf", fabs(newLocation.verticalAccuracy)] ];

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];

    [request setURL:[NSURL URLWithString:host]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"beriedataphone" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0f];
    
    NSLog(@"request: %@", request);
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) 
    {
		[spinner startAnimating];
        sendingRequest = YES;
        receivedData = [[NSMutableData data] retain];
        NSLog(@"Connection initiated...");
    } 
    else 
    {
        NSLog(@"No download!");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    NSString *aStr = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    NSLog(@"Returned String: %@",aStr);
    // release the connection, and the data object
    [receivedData release];
    responseTextView.text = aStr;
    lastWebUpdate = [[NSDate date] retain];
    [spinner stopAnimating];
    conn = nil;
    sendingRequest = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed: %@", [error localizedDescription]);
    responseTextView.text = [NSString stringWithFormat:@"Connection Failed: %@", [error localizedDescription]];
    [spinner stopAnimating];
    conn = nil;
    sendingRequest = NO;
}

@end
