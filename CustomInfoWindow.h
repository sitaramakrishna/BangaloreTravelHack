//
//  CustomInfoWindow.h
//  prototype
//
//  Created by Seetharamkrishna M on 10/27/13.
//  Copyright (c) 2013 Seetharamkrishna M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoWindow : UIView

@property (strong,nonatomic) IBOutlet UILabel *name;
@property (strong,nonatomic) IBOutlet UILabel *description;
@property (strong,nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
