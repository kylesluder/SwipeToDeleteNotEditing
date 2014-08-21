//
//  ViewController.m
//  SwipeToDeleteNotReloading
//
//  Created by Kyle Sluder on 8/19/14.
//  Copyright (c) 2014 The Omni Group. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableIndexSet *_indices;
}

#if 0
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"-tableView:willBeginEditingRowAtIndexPath:");
}
#else
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"-tableView:didEndEditingRowAtIndexPath:");
}
#endif

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
{
    NSLog(@"-setEditing:%@ animated:%@", editing ? @"YES" : @"NO", animated ? @"YES" : @"NO");
    [super setEditing:editing animated:animated];
}

- (void)setEditing:(BOOL)editing;
{
    NSLog(@"-setEditing:%@", editing ? @"YES" : @"NO");
    [super setEditing:editing];
}


- (void)viewDidLoad;
{
    _indices = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)];
    self.tableView.allowsSelection = NO;
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _indices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseIdentifier"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReuseIdentifier"];
    
    NSUInteger indexForRowInSet = [_indices indexPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return idx == indexPath.row;
    }];
    
    if (indexForRowInSet == 0)
        cell.textLabel.text = @"Swipe to delete any of the following rows; notice the Edit button doesn't change";
    else
        cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (unsigned long)indexForRowInSet];
    
    cell.backgroundColor = self.editing ? [UIColor lightGrayColor] : [UIColor whiteColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_indices removeIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
