/*

File: MyCLController.h
Abstract: Singleton class used to talk to CoreLocation and send results back to
the app's view controllers.

*/
//static NSString *MyWebhost = @"http://192.168.134.197:3000/locations/";
//static NSString *MyWebhost = @"http://webserver.vda-groep.nl/locations/";
//static NSString *MyWebhost = @"http://leipeleon.dyndns.org/optocht/locations/create/";
static NSString *MyWebhost = @"http://kop.pampus-lollebroek.nl/locations/create/";

// This protocol is used to send the text for location updates back to another view controller
@protocol MyCLControllerDelegate <NSObject>
@required
-(void)newLocationUpdate:(NSString *)text;
-(void)newStatusUpdate:(NSString *)text;
-(void)newError:(NSString *)text;
-(void)updateLatitude:(NSString *)latitude andLongitude:(NSString *)longitude;
-(void)updateWebLocation:(NSString *)host withLocation:(CLLocation *)newLocation;
-(BOOL)isSendingRequest;
-(NSTimeInterval)distanceLastWebUpdate;
@end


// Class definition
@interface MyCLController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <MyCLControllerDelegate> delegate;
@property (readonly, nonatomic) CLLocation *location;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

+ (MyCLController *)sharedInstance;

@end

