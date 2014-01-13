//
//  RRRssFeed.m
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import "RRRssFeed.h"
#import "AFNetworking.h"
#import "RRRssEntry.h"
#import <CoreData/CoreData.h>
#import "RRAppDelegate.h"

@implementation RRRssFeed

-(id) init{
    self = [super init];
    if (self){
        //self.elementsArray = [[NSMutableArray alloc] init];
        
        //load existing data from core data
        [self fetchExistingData];
        
    }
    return self;
}

-(void) fetchData:(void(^)(void))onSuccess{
    NSLog(@"fetch Data");

    NSURL *baseUrl = [NSURL URLWithString:@"http://feeds.bbci.co.uk"];
    NSDictionary *parms = [[NSDictionary alloc] initWithObjectsAndKeys:@"int",@"edition", nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"application/rss+xml"]];
    
    //NSLog(@"afhttp response serializer:%@",[manager responseSerializer]);
    [manager GET:@"/news/rss.xml"
      parameters:parms
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"response:%@",responseObject);
             NSXMLParser *parser = (NSXMLParser *)responseObject;
             [parser setDelegate:self];
             [parser parse];
             NSLog(@"finished parsing");
             onSuccess();
      }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
             NSLog(@"error:%@",error);
      }];
}

#pragma mark NSXMLParser Delegate Methods
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"media:thumbnail"]){
        media = [[attributeDict objectForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (!currentElementValue){
        currentElementValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentElementValue appendString:string];
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if ([elementName isEqualToString:@"title"]){
        title = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"title:%@",title);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"description"]){
        description = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"description:%@",description);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"guid"]){
        link = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"link:%@",link);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"pubDate"]){
        pubDate = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"pubdate:%@",pubDate);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"item"]){
        //NSLog(@"title:%@",title);
//        NSLog(@"description:%@",description);
//        NSLog(@"link:%@",link);
//        NSLog(@"pubDate:%@",pubDate);
//        NSLog(@"media link:%@",media);
        if (media == nil){
            media = @" ";
        }
        temp = @{@"title":title, @"description":description, @"link":link,@"pubDate":pubDate,@"mediaLink":media};
        
        //NSLog(@"item ! temp:%@",temp);
        [self save:temp];
        
        temp = nil;
        title = nil;
        description = nil;
        link = nil;
        pubDate = nil;
        media = nil;
        currentElementValue = nil;
    }
}

-(void) save:(NSDictionary *)entry{
    RRAppDelegate *appDelegate = (RRAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescr = [NSEntityDescription entityForName:@"RRRssEntry" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescr];
    
    NSError *fetchError = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title ==  %@)",entry[@"title"]];
    [fetchRequest setPredicate:predicate];
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&fetchError];
    
    if (array == nil){
        NSLog(@"error: %@:%@",fetchError,[fetchError userInfo]);
    }
    
    //if array has more than 1 element, entry exists in coredata
    if ([array count] > 0){
        //NSLog(@"entry %@ exists",[(RRRssEntry *)[array firstObject] title]);
        return;
    }
    
    //[self.elementsArray addObject:temp];
    
    RRRssEntry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"RRRssEntry"
                                                      inManagedObjectContext:[appDelegate managedObjectContext]];
    if (newEntry != nil){
        newEntry.title = entry[@"title"];
        newEntry.descr = entry[@"description"];
        newEntry.link = entry[@"link"];
        newEntry.pubDate = entry[@"pubDate"];
        newEntry.mediaLink = entry[@"mediaLink"];
        
        NSError *savingError = nil;
        
        if ([[appDelegate managedObjectContext] save:&savingError]){
            NSLog(@"successfully saved the context");
            [self.elementsArray addObject:newEntry];
        }else{
            NSLog(@"error: %@: %@",savingError, [savingError userInfo]);
        }
    }else{
        NSLog(@"Failed to create the new rss entity");
    }
                        
}

-(void) fetchExistingData{
    NSLog(@"Fetch existing data");
    
    RRAppDelegate *appDelegate = (RRAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entityDescr = [NSEntityDescription entityForName:@"RRRssEntry" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescr];
    NSError *fetchError = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&fetchError];
    
    if (array == nil){
        NSLog(@"error: %@:%@",fetchError,[fetchError userInfo]);
    }

    self.elementsArray = [[NSMutableArray alloc] initWithArray:array];
    
}
 

@end
