//
//  ArrivalCell.m
//  iBus-Universal
//
//  Created by Zhenwang Yao on 20/09/08.
//  Copyright 2008 Zhenwang Yao. All rights reserved.
//

#import "ArrivalCell.h"
#import "StopsViewController.h"
#import "BusArrival.h"
#import "General.h"

#define POS_ROUTE_WIDTH		50
#define POS_ROUTE_HEIGHT	50
#define POS_ROUTE_LEFT		10
#define POS_ROUTE_TOP		10
#define POS_TEXT_HEIGHT		18
#define POS_TEXT_WIDTH		200 //160
#define POS_TEXT_LEFT		70
#define POS_TEXT_TOP		10
#define POS_ICON_LEFT		250
#define POS_ICON_TOP		10
#define POS_ICON_SIZE		50

UIImage *favoriteIconImage = nil;

@implementation ArrivalCell

+ (NSInteger) height
{
	return 70; // POS_TEXT_HEIGHT * 3;
}

- (void) dealloc
{
	[busRoute release];
	[busSign release];
	[arrivalTime1 release];
	[arrivalTime2 release];
	[super dealloc];
}

//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier owner:(UIViewController *)owner
{
	self = [super initWithFrame: frame reuseIdentifier:reuseIdentifier];	
	if (!self)
		return nil;
	
	ownerView = owner;

	CGRect ctrlFrame = CGRectMake(POS_ROUTE_LEFT, POS_ROUTE_TOP, POS_ROUTE_WIDTH, POS_ROUTE_HEIGHT);
	//busRoute = [[UILabel alloc] initWithFrame:ctrlFrame];	
	busRoute = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	busRoute.frame = ctrlFrame;
	busRoute.userInteractionEnabled = NO;
	//busRoute.backgroundColor = [UIColor clearColor];
	//busRoute.opaque = NO;
	//busRoute.textAlignment = UITextAlignmentCenter;
	//busRoute.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	//busRoute.textColor = [UIColor whiteColor];
	//busRoute.backgroundColor = [UIColor blueColor];
	[busRoute setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	//stopName.highlightedTextColor = [UIColor blackColor];
	busRoute.titleLabel.font = [UIFont systemFontOfSize:20];
	
	
	ctrlFrame = CGRectMake(POS_TEXT_LEFT, POS_TEXT_TOP, POS_TEXT_WIDTH, POS_TEXT_HEIGHT);
	busSign = [[UILabel alloc] initWithFrame:ctrlFrame];	
	busSign.backgroundColor = [UIColor clearColor];
	busSign.opaque = NO;
	busSign.textAlignment = UITextAlignmentCenter;
	busSign.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	busSign.textColor = [UIColor blueColor];
	//stopName.highlightedTextColor = [UIColor blackColor];
	busSign.font = [UIFont systemFontOfSize:14];
	
	ctrlFrame.origin.y = ctrlFrame.origin.y + ctrlFrame.size.height;
	arrivalTime1 = [[UILabel alloc] initWithFrame:ctrlFrame];	
	arrivalTime1.backgroundColor = [UIColor clearColor];
	arrivalTime1.opaque = NO;
	arrivalTime1.textColor = [UIColor redColor];
	arrivalTime1.textAlignment = UITextAlignmentRight;
	arrivalTime1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	arrivalTime1.font = [UIFont systemFontOfSize:12];
	
	ctrlFrame.origin.y = ctrlFrame.origin.y +  + ctrlFrame.size.height;
	arrivalTime2 = [[UILabel alloc] initWithFrame:ctrlFrame];	
	arrivalTime2.backgroundColor = [UIColor clearColor];
	arrivalTime2.opaque = NO;
	arrivalTime2.textAlignment = UITextAlignmentRight;
	arrivalTime2.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	arrivalTime2.font = [UIFont systemFontOfSize:12];
	
	self.opaque = NO;
	//self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[self.contentView addSubview:busRoute];
	[self.contentView addSubview:busSign];
	[self.contentView addSubview:arrivalTime1];
	[self.contentView addSubview:arrivalTime2];
	
	//[busRoute release];
	//[busSign release];
	//[arrivalTime1 release];
	//[arrivalTime2 release];
	
	//if (favoriteButton)
	//{
	//	[favoriteButton addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	//	[self.contentView addSubview:favoriteButton];
	//	[favoriteButton release];
	//}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	return [self initWithFrame:frame reuseIdentifier:reuseIdentifier owner:nil];
}

- (BusArrival *) firstArrival
{
	if (theArrivals)
		if ([theArrivals count] > 0)
			return [theArrivals objectAtIndex:0];
	
	return nil;
}

- (void) setArrivals: (id) arrivals
{
	[theArrivals autorelease];
	theArrivals = [arrivals retain];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];	
	
	BusArrival *anArrival = nil;
	if ([arrivals count])
	{
		anArrival = [arrivals objectAtIndex:0];
		[busSign setText:[NSString stringWithFormat:@"%@", [anArrival busSign]]];		
		//[busRoute setText:[NSString stringWithFormat:@"%@", [anArrival route]]];
		int fontSize = 20 - 3 * ((int)([[anArrival route] length]/4));
		busRoute.titleLabel.font = [UIFont systemFontOfSize:fontSize];
		[busRoute setTitle:[NSString stringWithFormat:@"%@", [anArrival route]] forState:UIControlStateNormal];
	}
	else
	{
		[busSign setText:@"Unknown"];
		[busRoute setTitle:@"?" forState:UIControlStateNormal];	
	}
	
	if (anArrival == nil)
	{
		[arrivalTime1 setText:@"--:--"];
		[arrivalTime2 setText:@"--:--"];
		return;
	}
	
	if (anArrival.flag)
	{
		[arrivalTime1 setText:@"--:--"];
		[arrivalTime2 setText:@"--:--"];
	}
	else
	{
		/* Notes that the arrival time got from server may be in 
		 *   the format of: --:--:--
		 */
		//[arrivalTime1 setText:[anArrival arrivalTime]];
		if (currentTimeFormat == TIME_12H)
			[arrivalTime1 setText:RawTo12H([anArrival arrivalTime])];
		else 
			[arrivalTime1 setText:RawTo24H([anArrival arrivalTime])];
	}
	
	if ([arrivals count] >= 2)
	{
		anArrival = [arrivals objectAtIndex:1];
		//[arrivalTime1 setText:[anArrival arrivalTime]];
		if (currentTimeFormat == TIME_12H)
			[arrivalTime2 setText:RawTo12H([anArrival arrivalTime])];
		else 
			[arrivalTime2 setText:RawTo24H([anArrival arrivalTime])];
	}
	else
	{
		[arrivalTime2 setText:@"--:--"];
	}
}

@end
