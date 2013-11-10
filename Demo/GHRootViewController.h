//
//  GHRootViewController.h
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

typedef void (^RevealBlock)();

@interface GHRootViewController : UIViewController {
    //GMSMapView *mapView_;
    //CLLocationManager *locationManager;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;
@property (strong, nonatomic) IBOutlet UISegmentedControl *types;
@property (strong, nonatomic) IBOutlet UIWebView *homepage;
- (IBAction)onTypesChange:(id)sender;

@end
