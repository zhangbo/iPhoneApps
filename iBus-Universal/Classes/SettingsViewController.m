//
//  SettingsAppDelegate.m
//  Settings
//
//  Created by Zhenwang Yao on 18/08/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "SettingsViewController.h"
#import "CitySelectViewController.h"
#import "TransitApp.h"

extern float searchRange;
extern int   numberOfResults;
extern BOOL  globalTestMode;

enum SettingTableSections
{
	kUICity_Section = 0,
	kUIRange_Section,
	kUIRecent_Section,
	kUIAbout_Section,
	kUISetting_Section_Num
};

@implementation SettingsViewController

//@synthesize searchRange, numberOfRecentStops;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		// Initialization code
	}
	return self;
}

// Implement loadView if you want to create a view hierarchy programmatically
/*
- (void)loadView
{
}
*/
 
- (void)viewDidAppear:(BOOL)animated
{
	[settingView reloadData];
}

// Implement viewDidLoad if you need to do additional setup after loading the view.
- (void)viewDidLoad
{
	//searchRange = 0.1;
	//numberOfRecentStops = 2;
	[super viewDidLoad];
		
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	searchRange = [defaults floatForKey:UserSavedSearchRange];
	numberOfResults = [defaults integerForKey:UserSavedSearchResultsNum];
	
	rangeSlider.value = searchRange;
	recentSlider.value = numberOfResults;
	
	NSMutableString *content =[NSMutableString  stringWithString: @"<html> Author: Zhenwang Yao <br><br>"];
	[content appendString:@"This is an application based on <a href=\"http://code.google.com/transit/spec/transit_feed_specification.html\">Google Transit Feed Specification (GTFS)</a> data. Web service is provided by "];
	[content appendString:@"<a href=\"http://developer.trimet.org/\">Trimet</a>."];
	[content appendString:@"<br><br>Great thanks to them!"];
	[content appendString:@"<br><br>The author does not guarantee accurancy of the information, and future availability of the service."];
	[content appendString:@"<br><br>Enjoy!!<br>"];
	[content appendString:@"</html>"];
	[aboutWebCell loadHTMLString:content baseURL:nil];
	
	self.navigationItem.title = @"Setting";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
	//[super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc 
{
	[super dealloc];
}

#pragma mark Response to User Input

- (IBAction) rangeChanged:(id) sender
{
	searchRange = [rangeSlider value]; 
	
	UITableViewCell *cellToUpdate = [settingView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: 1 inSection:kUIRange_Section]];
	[cellToUpdate editAction];
	cellToUpdate.text = [NSString stringWithFormat: @"Search closest stops within %.1f (Km).", searchRange];
}

- (IBAction) resultNumChanged:(id) sender
{
	numberOfResults = [recentSlider value];
	UITableViewCell *cellToUpdate = [settingView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: 1 inSection:kUIRecent_Section]];
	[cellToUpdate editAction];
	cellToUpdate.text = [NSString stringWithFormat: @"You may see at most %d stop(s) in results", numberOfResults];
}

- (IBAction) rangeChangedFinial:(id) sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setFloat:searchRange forKey:UserSavedSearchRange];
}

- (IBAction) resultNumChangedFinal:(id) sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:numberOfResults forKey:UserSavedSearchResultsNum];
}

#pragma mark UITableView Delegate Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return kUISetting_Section_Num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == kUICity_Section)
		return 1;
	else
		return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
	{
		CGRect cellBound;
		if (indexPath.section == kUICity_Section)
		{
			return 44;
		}
		else if ( indexPath.section == kUIRange_Section )
		{
			cellBound = [rangeCell bounds];
			return cellBound.size.height;
		}
		else if ( indexPath.section == kUIRecent_Section )
		{
			cellBound = [recentCell bounds];
			return cellBound.size.height;
		}
		else
		{
			cellBound = [aboutCell bounds];
			return cellBound.size.height;
		}
	}
	
	else
		return [[UIFont fontWithName:@"HelveticaBold" size:12] capHeight] + 32;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	switch (section) {
		case kUICity_Section:
			title = @"Current City";
			break;
		case kUIRange_Section:
			title = @"Search Range";
			break;
		case kUIRecent_Section:
			title = @"Search Results";
			break;
		case kUIAbout_Section:
			title = @"About & Disclaimer";
			break;
		default:
			break;
	}
	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger row = [indexPath row];
	
	if (row == 0)
	{
		if (indexPath.section == kUICity_Section)
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitySelectionCell"];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CitySelectionCell"] autorelease]; 
				cell.font = [UIFont systemFontOfSize:14];
			}
			NSAssert([[UIApplication sharedApplication] isKindOfClass:[TransitApp class]], @"Application mismatch!");
			cell.text = [(TransitApp *)[UIApplication sharedApplication] currentCity];
			return cell;
		}
		else if ( indexPath.section == kUIRange_Section )
			return rangeCell;
		else if ( indexPath.section == kUIRecent_Section )
			return recentCell;
		else
			return aboutCell;
	}
	else if (row == 1)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewCell"];
		if (cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SettingViewCell"] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			//[cell setSeparatorStyle: UITableViewCellSeparatorStyleNone];
			cell.font = [UIFont systemFontOfSize:12];
		}
		if ( indexPath.section == kUIRange_Section )
		{
			cell.text = [NSString stringWithFormat: @"Search closest stops within %.1f (Km).", searchRange];
		}
		else if ( indexPath.section == kUIRecent_Section)
		{
			cell.text = [NSString stringWithFormat: @"You may see at most %d stop(s) in results", numberOfResults];					
		}
		else
		{		
			cell.textAlignment = UITextAlignmentCenter;
			cell.text = @"Copyright @ 2008 Zhenwang Yao";
		}
		return cell;
	}
	else
		return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kUICity_Section)
	{
		CitySelectViewController *selectionVC = [[CitySelectViewController alloc] initWithNibName:nil bundle:nil];
		selectionVC.delegate = [UIApplication sharedApplication];
		[[self navigationController] pushViewController:selectionVC animated:YES];
	}
}

#pragma mark WebView Delegate Functions

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}	
	else 
		return YES;
}

@end

@implementation SearchRangeCell

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	static int numOfTouches = 1;
	numOfTouches ++;
	
	numOfTouches = numOfTouches % 10;
	if (numOfTouches == 0)
	{
		globalTestMode = YES;
		NSLog(@"Switch to Test mode!!");
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end



