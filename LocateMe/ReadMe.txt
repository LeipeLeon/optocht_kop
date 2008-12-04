### LocateMe ###

================================================================================
DESCRIPTION:

The LocateMe application demonstrates how to use the CLLocationManager class to determine the user's current location. It demonstrates starting and stopping updates, error handling, and changing location parameters.

The most important class in this application is MyCLController. This class conforms to the CLLocationManagerDelegate protocol so that it receives updates from CoreLocation. It also uses a simple protocol of its own (MyCLControllerDelegate) to send text to the MainViewController so that the text can be displayed.

The FlipSideViewController shows how to get and set options in the CLLocationManager, using the properties of the MyCLController wrapper class.

The MainViewController shows how to check if LocationServices are available, using the locationServicesEnabled property of the CLLocationManager class. See the viewDidLoad method for more info.

Notes:

Even if you have the distance filter set, you may still get updates whenever the accuracy improves, even if the new coordinates are not outside your specified distance.

Updates can sometimes be reported with timestamps that are not in chronological order. See the note in MyCLController.m for more info. In general, clients will be interested in whichever measurement is the most accurate.

Also note that you can sometimes get updates with timestamps prior to the time that the application was launched. This is just the most recent location data available. More updates will come in as the application runs.

================================================================================
BUILD REQUIREMENTS:

Mac OS X v10.5.3, Xcode 3.1, iPhone OS 2.0

================================================================================
RUNTIME REQUIREMENTS:

Mac OS X v10.5.3, iPhone OS 2.0

================================================================================
PACKAGING LIST:

MainViewController.h
MainViewControler.m
Controller class for the "main" view (visible at app start).

FlipsideViewController.h
FlipsideViewController.m
Controller class for the "flipside" view, which contains all the controls for settings.

AccuracyPickerItem.h
AccuracyPickerItem.m
Helper class for the UIPicker in the flipside view. Each object contains a CLLocationAccuracy value and a description string.

LocateMeAppDelegate.h
LocateMeAppDelegate.m
App delegate. Creates window and root view

RootViewController.h
RootViewController.m
Root view used to flip between main and reverse views. Subviews use delegates to tell this view when to flip between them.

MyCLController.h
MyClController.m
Singleton class used to talk to CoreLocation and send results back to the app's view controllers.

main.m
The main entry point for the LocateMe application.

================================================================================
CHANGES FROM PREVIOUS VERSIONS:

Version 1.1
- Updated for and tested with iPhone OS 2.0. First public release.
- Fixed date error.

Version 1.0
- First version.

================================================================================
Copyright (C) 2008 Apple Inc. All rights reserved.