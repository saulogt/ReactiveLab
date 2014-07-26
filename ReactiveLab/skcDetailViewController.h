//
//  skcDetailViewController.h
//  ReactiveLab
//
//  Created by Saulo G Tauil on 14/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skcDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
