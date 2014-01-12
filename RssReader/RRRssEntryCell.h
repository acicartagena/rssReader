//
//  RRRssCell.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRRssEntryCell : UITableViewCell

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *pubDate;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *mediaLink;

@end
