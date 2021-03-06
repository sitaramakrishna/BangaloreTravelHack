//
//  GHSidebarViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHRevealViewController.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark -
#pragma mark Constants
const NSTimeInterval kGHRevealSidebarDefaultAnimationDuration = 0.25;
const CGFloat kGHRevealSidebarWidth = 260.0f;
const CGFloat kGHRevealSidebarFlickVelocity = 1000.0f;


#pragma mark -
#pragma mark Private Interface
@interface GHRevealViewController ()
@property (nonatomic, readwrite, getter = isSidebarShowing) BOOL sidebarShowing;
@property (nonatomic, readwrite, getter = isSearching) BOOL searching;
@property (nonatomic, strong) UIView *searchView;
- (void)hideSidebar;
@end


#pragma mark -
#pragma mark Implementation
@implementation GHRevealViewController {

@private
	UIView *_sidebarView;
	UIView *_contentView;
	UITapGestureRecognizer *_tapRecog;
}
@synthesize imgView;
@synthesize dialogpop;

int imgState;

- (void)setSidebarViewController:(UIViewController *)svc {
	if (_sidebarViewController == nil) {
		svc.view.frame = _sidebarView.bounds;
        svc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_sidebarViewController = svc;
		[self addChildViewController:_sidebarViewController];
		[_sidebarView addSubview:_sidebarViewController.view];
		[_sidebarViewController didMoveToParentViewController:self];
	} else if (_sidebarViewController != svc) {
		svc.view.frame = _sidebarView.bounds;
        svc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[_sidebarViewController willMoveToParentViewController:nil];
		[self addChildViewController:svc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_sidebarViewController
						  toViewController:svc 
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{} 
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_sidebarViewController removeFromParentViewController];
									[svc didMoveToParentViewController:self];
									_sidebarViewController = svc;
								}
		 ];
	}
}

- (void)setContentViewController:(UIViewController *)cvc {
	if (_contentViewController == nil) {
		cvc.view.frame = _contentView.bounds;
		_contentViewController = cvc;
		[self addChildViewController:_contentViewController];
		[_contentView addSubview:_contentViewController.view];
		[_contentViewController didMoveToParentViewController:self];
	} else if (_contentViewController != cvc) {
		cvc.view.frame = _contentView.bounds;
		[_contentViewController willMoveToParentViewController:nil];
		[self addChildViewController:cvc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_contentViewController
						  toViewController:cvc 
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_contentViewController removeFromParentViewController];
									[cvc didMoveToParentViewController:self];
									_contentViewController = cvc;
								}
		];
	}
}

#pragma mark Memory Management
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.sidebarShowing = NO;
		self.searching = NO;
		_tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidebar)];
		_tapRecog.cancelsTouchesInView = YES;
		
		self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		_sidebarView = [[UIView alloc] initWithFrame:self.view.bounds];
		_sidebarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_sidebarView.backgroundColor = [UIColor blackColor];
		[self.view addSubview:_sidebarView];
		
		_contentView = [[UIView alloc] initWithFrame:self.view.bounds];
		_contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_contentView.backgroundColor = [UIColor whiteColor];
		_contentView.layer.masksToBounds = NO;
		_contentView.layer.shadowColor = [UIColor whiteColor].CGColor;
		_contentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		_contentView.layer.shadowOpacity = 1.0f;
		_contentView.layer.shadowRadius = 2.5f;
		_contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.bounds].CGPath;
		[self.view addSubview:_contentView];
        
        //dialogpop.hidden = true;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Add" forState:UIControlStateNormal];
        button.frame = CGRectMake(215.0, 24.0, 160.0, 40.0);
        [self.view addSubview:button];
        
        dialogpop = [[UIView alloc] initWithFrame:CGRectMake(30, 100, 250, 400)];
        dialogpop.backgroundColor = [UIColor colorWithRed:(230.0f/255.0f) green:(230.0f/255.0f) blue:(230.0f/255.0f) alpha:1.0f];
        dialogpop.layer.cornerRadius = 5;
        dialogpop.layer.masksToBounds = YES;
        
        UILabel *AboutText = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 220, 20)];
        
        [AboutText setTextColor:[UIColor orangeColor]];
        [AboutText setBackgroundColor:[UIColor clearColor]];
        [AboutText setFont:[UIFont boldSystemFontOfSize:18.0f]];
        AboutText.autoresizingMask = dialogpop.autoresizingMask;
        AboutText.text = @"Add a new souvenir";
        
        

        UILabel *About = [[UILabel alloc] initWithFrame:CGRectMake(18, 240, 220, 20)];
        
        [About setTextColor:[UIColor orangeColor]];
        [About setBackgroundColor:[UIColor clearColor]];
        [About setFont:[UIFont boldSystemFontOfSize:16.0f]];
        About.autoresizingMask = dialogpop.autoresizingMask;
        About.text = @"About";
        
        
        UILabel *AboutValue = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 220, 20)];
        
        [AboutValue setTextColor:[UIColor blackColor]];
        [AboutValue setBackgroundColor:[UIColor clearColor]];
        [AboutValue setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]];
        AboutValue.autoresizingMask = dialogpop.autoresizingMask;
        AboutValue.text = @"Famous Article Piece";
        
        
        UILabel *Merchant = [[UILabel alloc] initWithFrame:CGRectMake(18, 280, 220, 20)];
        
        [Merchant setTextColor:[UIColor orangeColor]];
        [Merchant setBackgroundColor:[UIColor clearColor]];
        [Merchant setFont:[UIFont boldSystemFontOfSize:16.0f]];
        Merchant.autoresizingMask = dialogpop.autoresizingMask;
        Merchant.text = @"Merchant Details";
        
        
        UILabel *MerchantDetails = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 220, 20)];
        
        [MerchantDetails setTextColor:[UIColor blackColor]];
        [MerchantDetails setBackgroundColor:[UIColor clearColor]];
        [MerchantDetails setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]];
        MerchantDetails.autoresizingMask = dialogpop.autoresizingMask;
        MerchantDetails.text = @"Bangalore Handlooms";
        
        
        
        UIButton *savebutton = [[UIButton alloc] initWithFrame:CGRectMake(25, 360, 90, 30)];
        [savebutton setTitle:@"SAVE" forState:UIControlStateNormal];
        savebutton.backgroundColor = [UIColor orangeColor];
        savebutton.layer.cornerRadius = 5;
        savebutton.layer.masksToBounds = YES;
        [savebutton addTarget:self
                   action:@selector(saveMethod:)
         forControlEvents:UIControlEventTouchDown];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(135, 360, 90, 30)];
        [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor orangeColor];
        cancelButton.layer.cornerRadius = 5;
        cancelButton.layer.masksToBounds = YES;
        [cancelButton addTarget:self
                   action:@selector(cancelMethod:)
         forControlEvents:UIControlEventTouchDown];
        
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 220, 200)];
        [imgView.layer setBorderColor: [[UIColor orangeColor] CGColor]];
        [imgView.layer setBorderWidth: 1.0];
        [imgView.layer setCornerRadius: 5.0];
        [imgView.layer setMasksToBounds:YES];
        
        [dialogpop addSubview:cancelButton];
        [dialogpop addSubview:savebutton];
        [dialogpop addSubview:AboutValue];
        [dialogpop addSubview:AboutText];
        [dialogpop addSubview:Merchant];
        [dialogpop addSubview:MerchantDetails];
        [dialogpop addSubview:About];
        [dialogpop addSubview:imgView];
        
        imgState = 0;
    }
    return self;
}
- (void) saveMethod:(UIButton *)sender {
    [self closeImg:nil];
}

- (void) cancelMethod:(UIButton *)sender {
    [self closeImg:nil];
}

- (void) aMethod:(UIButton *)sender {
    //if (imgState == 0) {
        [self selectPhoto];
    /*    imgState = 1;
    } else {
        [self closeImg:nil];
        imgState = 0;
    }*/
}

#pragma mark Photo/Video methods
- (void) takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    [self.view addSubview:dialogpop];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgView.hidden = false;
    //self.imgDoneButton.hidden = false;
    
    self.imgView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)closeImg:(id)sender {
    //self.imgDoneButton.hidden = true;
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Awesome!"
                                                          message:@"Added Sovenieur info to Bangalore!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];
    self.dialogpop.hidden = true;
    self.imgView.hidden = true;
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void) selectPhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        [self.view addSubview:dialogpop];
        
    } else {
        [self takePhoto];
    }
}

#pragma mark UIViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
		? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		: YES;
}

#pragma mark Public Methods
- (void)dragContentView:(UIPanGestureRecognizer *)panGesture {
	CGFloat translation = [panGesture translationInView:self.view].x;
	if (panGesture.state == UIGestureRecognizerStateChanged) {
		if (_sidebarShowing) {
			if (translation > 0.0f) {
				_contentView.frame = CGRectOffset(_contentView.bounds, kGHRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else if (translation < -kGHRevealSidebarWidth) {
				_contentView.frame = _contentView.bounds;
				self.sidebarShowing = NO;
			} else {
				_contentView.frame = CGRectOffset(_contentView.bounds, (kGHRevealSidebarWidth + translation), 0.0f);
			}
		} else {
			if (translation < 0.0f) {
				_contentView.frame = _contentView.bounds;
				self.sidebarShowing = NO;
			} else if (translation > kGHRevealSidebarWidth) {
				_contentView.frame = CGRectOffset(_contentView.bounds, kGHRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else {
				_contentView.frame = CGRectOffset(_contentView.bounds, translation, 0.0f);
			}
		}
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		CGFloat velocity = [panGesture velocityInView:self.view].x;
		BOOL show = (fabs(velocity) > kGHRevealSidebarFlickVelocity)
			? (velocity > 0)
			: (translation > (kGHRevealSidebarWidth / 2));
		[self toggleSidebar:show duration:kGHRevealSidebarDefaultAnimationDuration];
		
	}
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration {
	[self toggleSidebar:show duration:duration completion:^(BOOL finshed){}];
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
    __weak GHRevealViewController *selfRef = self;
	void (^animations)(void) = ^{
		if (show) {
			_contentView.frame = CGRectOffset(_contentView.bounds, kGHRevealSidebarWidth, 0.0f);
			[_contentView addGestureRecognizer:_tapRecog];
            [selfRef.contentViewController.view setUserInteractionEnabled:NO];
		} else {
			if (self.isSearching) {
				_sidebarView.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
			} else {
				[_contentView removeGestureRecognizer:_tapRecog];
			}
			_contentView.frame = _contentView.bounds;
            [selfRef.contentViewController.view setUserInteractionEnabled:YES];
		}
		selfRef.sidebarShowing = show;
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

- (void)toggleSearch:(BOOL)showSearch withSearchView:(UIView *)srchView duration:(NSTimeInterval)duration {
	[self toggleSearch:showSearch withSearchView:srchView duration:duration completion:^(BOOL finished){}];
}

- (void)toggleSearch:(BOOL)showSearch withSearchView:(UIView *)srchView duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
	if (showSearch) {
		srchView.frame = self.view.bounds;
	} else {
		_sidebarView.alpha = 0.0f;
		_contentView.frame = CGRectOffset(self.view.bounds, CGRectGetWidth(self.view.bounds), 0.0f);
		[self.view addSubview:_contentView];
	}
	void (^animations)(void) = ^{
		if (showSearch) {
			_contentView.frame = CGRectOffset(_contentView.bounds, CGRectGetWidth(self.view.bounds), 0.0f);
			[_contentView removeGestureRecognizer:_tapRecog];
			[_sidebarView removeFromSuperview];
			self.searchView = srchView;
			[self.view insertSubview:self.searchView atIndex:0];
		} else {
			_sidebarView.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
			_sidebarView.alpha = 1.0f;
			[self.view insertSubview:_sidebarView atIndex:0];
			self.searchView.frame = _sidebarView.frame;
			_contentView.frame = CGRectOffset(_contentView.bounds, kGHRevealSidebarWidth, 0.0f);
		}
	};
	void (^fullCompletion)(BOOL) = ^(BOOL finished){
		if (showSearch) {
			_contentView.frame = CGRectOffset(_contentView.bounds, CGRectGetHeight([UIScreen mainScreen].bounds), 0.0f);
			[_contentView removeFromSuperview];
		} else {
			[_contentView addGestureRecognizer:_tapRecog];
			[self.searchView removeFromSuperview];
			self.searchView = nil;
		}
		self.sidebarShowing = YES;
		self.searching = showSearch;
		completion(finished);
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:fullCompletion];
	} else {
		animations();
		fullCompletion(YES);
	}
}

#pragma mark Private Methods
- (void)hideSidebar {
	[self toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
}

@end
