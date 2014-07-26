//
//  skcAppDelegate.h
//  ReactiveLab
//
//  Created by Saulo G Tauil on 14/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skcAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
