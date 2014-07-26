//
//  skcMasterViewController.h
//  ReactiveLab
//
//  Created by Saulo G Tauil on 14/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class skcDetailViewController;

#import <CoreData/CoreData.h>

@interface skcMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) skcDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
