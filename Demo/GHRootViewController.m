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
		self.title = @"Peru, South Africa, Combodia";
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
            return NO;
        }
    }
    return YES;
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //[self.types insertSegmentWithImage:[UIImage imageNamed:@"icon-home.png"] atIndex:0 animated:NO];
    //[self.types insertSegmentWithImage:[UIImage imageNamed:@"icon-star.png"] atIndex:1 animated:NO];
    [self.homepage loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"homepage" ofType:@"html"]isDirectory:NO]]];
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

@end
