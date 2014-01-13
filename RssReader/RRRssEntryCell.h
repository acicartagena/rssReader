//
//  RRRssCell.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface RRRssEntryCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *title;
@property (nonatomic,weak) IBOutlet UILabel *pubDate;
@property (nonatomic,weak) IBOutlet UILabel *description;

@property (nonatomic,strong) UILabel *mediaLink;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *category;


@end
