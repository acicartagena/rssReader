//
//  RRRssEntry.h
//  RssReader
//
//  Created by it_admin on 1/13/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RRRssEntry : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * mediaLink;
@property (nonatomic, retain) NSString * pubDate;

@end
