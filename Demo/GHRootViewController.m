//
//  GHRootViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHRootViewController.h"
#import "GHPushedViewController.h"
#import "CustomInfoWindow.h"

#pragma mark Private Interface
@interface GHRootViewController ()
- (void)pushViewController;
- (void)revealSidebar;
@end

#pragma mark Implementation
@implementation GHRootViewController{
@private
	RevealBlock _revealBlock;
    NSString *sidebarTitle;
}

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:@"View" bundle:nil]) {
		self.title = title;
        sidebarTitle = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem = 
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
														  target:self
														  action:@selector(revealSidebar)];
	}
	return self;
}

/*- (void) loadMap
{
    NSLog(@"LOADING MAP!!!");
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:12.305135
                                                            longitude:76.655148
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.delegate = self;
    
    mapView_.myLocationEnabled = YES;
    
    [self.view insertSubview:mapView_ atIndex:0];
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(12.305135,
                                                 76.655148);
    marker.title = @"Mysore Palace";
    marker.snippet = @"Mysore, Karnataka, India";
    UIImage *img = [UIImage imageNamed:@"historicalquarter.png"];
    CGSize size = CGSizeMake(25, 25);
    marker.icon = [self imageWithImage:img scaledToSize:size];
    
    marker.map = mapView_;
    
    
    
    
}*/

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    CustomInfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    view.name.text = marker.title;
    view.description.text = marker.snippet;
    view.phone.text = @"123 456 789";
    view.image.image = [UIImage imageNamed:@"museum.jpg"];
    view.image.transform = CGAffineTransformMakeRotation(-.08);
    
    
    // border radius
    [view.layer setCornerRadius:20.0f];
    
    // border
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:1.5f];
    
    // drop shadow
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.5];
    [view.layer setShadowRadius:2.0];
    [view.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    return view;
}*/

#pragma mark webview delegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"WebView delegate called....");
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        
        NSString *urlStr = request.URL.absoluteString;
        NSRange preisRange = [urlStr rangeOfString:@"/challenge.html" options:NSCaseInsensitiveSearch];
        NSLog(@"Loading GOOGLEMAP :%d", preisRange.location );
        
        if(preisRange.location == 7) {
            /*self.mapFunctions.hidden = false;
            self.mapsearchbar.hidden = false;
            self.tripWebView.hidden = true;
            [self loadMap];//Handle External REQ here*/
            //return NO;
        }
    }
    return YES;
}

- loadFile:(NSString *) fileName {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    NSString *htmlPath = [documentPath stringByAppendingPathComponent:@"GHSidebarNav//"];
    htmlPath = [htmlPath stringByAppendingString:fileName];
    NSURL *bundleUrl = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:bundleUrl];
    NSLog(@"help file url: %@", bundleUrl);
	[self.homepage loadRequest:requestObj];
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"GHSidebarNav"];
    // If the expected store doesn't exist, copy the default store.
    // If it is in production, copy only the first time.
    // Otherwise, copy everytime the help button is clicked to allow easier testing.
    BOOL isProduction = FALSE;
    if (!isProduction || ![fileManager fileExistsAtPath:dataPath]) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *helpPath = [bundlePath stringByAppendingPathComponent:@"GHSidebarNav"];
        if (helpPath) {
            [fileManager copyItemAtPath:helpPath toPath:dataPath error:NULL];
        }
    }

	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //[self.types insertSegmentWithImage:[UIImage imageNamed:@"icon-home.png"] atIndex:0 animated:NO];
    //[self.types insertSegmentWithImage:[UIImage imageNamed:@"icon-star.png"] atIndex:1 animated:NO];
    if ([sidebarTitle  isEqual: @"Machu Picchu, Peru"]) {
        [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"peruhome" ofType:@"html"]isDirectory:NO]]];
        //[self loadFile:@"/peruhome.html"];
        
    }
    else if ([sidebarTitle  isEqual: @"Siem Reap, Cambodia"]) {
        [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cambodiahome" ofType:@"html"]isDirectory:NO]]];
        //[self loadFile:@"/cambodiahome.html"];
    }
    else if ([sidebarTitle  isEqual: @"Assam, India"]) {
        [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"assamhome" ofType:@"html"]isDirectory:NO]]];
        
    }
    
    self.homepage.delegate = self;
}

#pragma mark Private Methods
- (void)pushViewController {
	NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
	UIViewController *vc = [[GHPushedViewController alloc] initWithTitle:vcTitle];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)revealSidebar {
	_revealBlock();
}

- (IBAction)onTypesChange:(id)sender {
    NSLog(@"selected: %d", self.types.selectedSegmentIndex);
    if(self.types.selectedSegmentIndex == 0) {
        if ([sidebarTitle  isEqual: @"Machu Picchu, Peru"]) {
            [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"peruhome" ofType:@"html"]isDirectory:NO]]];
            
        }
        else if ([sidebarTitle  isEqual: @"Siem Reap, Cambodia"]) {
            [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cambodiahome" ofType:@"html"]isDirectory:NO]]];
            
        }
        else if ([sidebarTitle  isEqual: @"Assam, India"]) {
            [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"assamhome" ofType:@"html"]isDirectory:NO]]];
            
        }
        
    }
    else if(self.types.selectedSegmentIndex == 1) {
        if ([sidebarTitle  isEqual: @"Machu Picchu, Peru"]) {
            [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"perufood" ofType:@"html"]isDirectory:NO]]];
            
        }
        else if ([sidebarTitle  isEqual: @"Siem Reap, Cambodia"]) {
            [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cambodiafood" ofType:@"html"]isDirectory:NO]]];
            
        }
        else if ([sidebarTitle  isEqual: @"Assam, India"]) {
            [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"assamfood" ofType:@"html"]isDirectory:NO]]];
            
        }
        
    }
    
}
@end
