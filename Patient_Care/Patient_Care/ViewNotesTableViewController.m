//
//  ViewNotesTableViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/22/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ViewNotesTableViewController.h"
#import "Settings.h"
#import "AddNotesViewController.h"

@interface ViewNotesTableViewController ()

@end

@implementation ViewNotesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        notes = [Settings instance].notes;
        
        NSLog(@"lenght %lu", (unsigned long)[notes count]);
        
        // Assuming you've added the table view as a subview to the current view controller
        UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
        
        [tableView reloadData];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [notes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotesCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [notes objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"2");
    
    AddNotesViewController *controller = (AddNotesViewController *)segue.destinationViewController;

    
    if([segue.identifier isEqualToString:@"showDetailSegue"]){
        
        //        controller.note2 = note
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        NSString *te = [notes objectAtIndex:selectedIndexPath.row];
        
        controller.note = te;
        
        controller.newNote = false;
        
        NSInteger a = selectedIndexPath.row;
        
        controller.noteNumber = &(a);
        
        [controller.data setValue:[NSString stringWithFormat:@"%ld", (long)a] forKey:@"pos"];
        [controller.data setValue:@"0" forKey:@"new"];
        
        [Settings instance].selectedNote = (int)a;
        [Settings instance].newNote = (int)1;
    } else {
//        controller.newNote = true;
//        controller.newNote = YES;
        
        NSInteger a = -1;
        
        controller.noteNumber = &(a);
        
        [controller.data setValue:@"-1" forKey:@"pos"];
        [controller.data setValue:@"1" forKey:@"new"];

        [Settings instance].selectedNote = (int)-1;
        [Settings instance].newNote = (int)0;
    }
}

@end
