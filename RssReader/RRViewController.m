//
//  RRViewController.m
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import "RRViewController.h"
#import "RRRssFeed.h"
#import "RRRssEntryCell.h"
#import "RRRssEntry.h"

@interface RRViewController ()

@end

@implementation RRViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                               target:self
                                               action:@selector(refresh:)];
    
    self.feed = [[RRRssFeed alloc] init];
    
#if STRATEGY == DELEGATE
    [self.feed setDelegate:self];
#elif STRATEGY == NOTIF
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rssFeedFetchSuccess)
                                                 name:@"rssFeedFetchSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rssFeedFetchError)
                                                 name:@"rssFeedFetchError"
                                               object:nil];
#endif
    [self refresh:nil];
}


-(void) refresh:(id)sender{
    NSLog(@"refresh");
#if STRATEGY == BLOCKS
    [self.feed fetchData:^{
        [self.tableView reloadData];
    }OnError:^(NSError *error){
        NSLog(@"error: %@: %@",error,[error userInfo]);
    }];
#elif STRATEGY == DELEGATE || STRATEGY == NOTIF
    [self.feed fetchData];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if STRATEGY == NOTIF
#pragma mark - Notification Center methods
-(void)rssFeedFetchSuccess{
    NSLog(@"rss feed fetch success");
    [self.tableView reloadData];
}

-(void)rssFeedFetchError{
    NSError *error = [self.feed error];
    NSLog(@"vc:error:%@ :%@",error,[error userInfo]);
    
}
#endif


#if STRATEGY == DELEGATE
#pragma mark  - RRRssFeed Delegate methods
-(void)rssFeedFetchSuccess{
    NSLog(@"rss feed fetch success");
    [self.tableView reloadData];
}

-(void)rssFeedFetchError:(NSError *)error{
    NSLog(@"vc:error:%@ :%@",error,[error userInfo]);
}
#endif

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.feed elementsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RRRssEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RRRssEntry *cellData = [[self.feed elementsArray] objectAtIndex:[[self.feed elementsArray] count]-[indexPath row]-1];

    cell.title.text = [cellData title];
    cell.description.text = [cellData descr];
    cell.pubDate.text = [cellData pubDate];
    
    return cell;
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
