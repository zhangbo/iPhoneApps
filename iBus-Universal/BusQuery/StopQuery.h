//
//  StopQuery-CSV.h
//  DataProcess
//
//  Created by Zhenwang Yao on 21/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <sqlite3.h>
#import "BusStop.h"

@interface StopQuery : NSObject{
	sqlite3 *database;
}

//Create an object with the stop file
+ (id) initWithFile:(NSString *) stopFile;
- (BOOL) openStopFile: (NSString *)stopFile;

//Query
- (BusStop *) getRandomStop;
- (BusStop *) stopOfId: (NSString *) sid;
- (NSArray *) queryStopWithPosition:(CGPoint) pos within:(double)distInKm;
- (NSArray *) queryStopWithName:(NSString *) stopName;
- (NSArray *) queryStopWithNames:(NSArray *) stopNames;
- (NSArray *) queryStopWithIds:(NSArray *) stopIds;

@end
