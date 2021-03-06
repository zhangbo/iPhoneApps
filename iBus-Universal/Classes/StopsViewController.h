//
//  StopsViewController.h
//  iPhoneTransit
//
//  Created by Zhenwang Yao on 18/08/08.
//  Copyright 2008 Zhenwang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BusStop;
@class BusArrival;
@class StopsViewController;

@interface StopsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView			*stopsTableView;
	NSMutableArray		*stopsOfInterest;
	NSMutableDictionary *stopsDictionary;
	NSMutableArray		*routesOfInterest;
	BOOL				needReset;
}

- (NSArray *) stopsOfInterest;
- (void) setStopsOfInterest: (NSArray *)stops;

- (void) reset;
- (void) reload;
- (void) needsReload;
- (void) alertOnEmptyStopsOfInterest;

- (void) arrivalsUpdated: (NSArray *)results;

@end

NSString* RawTo24H(NSString* raw);
NSString* RawTo12H(NSString* raw);
extern int currentTimeFormat;
