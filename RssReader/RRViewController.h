//
//  RRViewController.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRRssFeed.h"


#if STRATEGY == DELEGATE
@interface RRViewController : UITableViewController <RRRssFeedDelegate>
#else
@interface RRViewController : UITableViewController
#endif

@property (nonatomic,strong) RRRssFeed *feed;

@end
