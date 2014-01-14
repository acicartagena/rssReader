//
//  RRAppDelegate.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//constants
#define BLOCKS 1
#define DELEGATE 2
#define NOTIF 3
#define KVO 4

#define STRATEGY NOTIF

@class RRViewController;
@interface RRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSURL*) applicationDocumentsDirectory;
-(void) saveContext;
@end
