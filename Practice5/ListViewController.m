//
//  ListViewController.m
//  Practice5
//
//  Created by Rockstar. on 1/29/15.
//  Copyright (c) 2015 Gabe Morales. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *titlesArray;
@property (nonatomic) NSMutableArray *descriptionsArray;;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titlesArray = [NSMutableArray new];
    _descriptionsArray = [NSMutableArray new];
    self.editing = NO;
    // Do any additional setup after loading the view.
}

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender {
    [self presentDreamEntry];
}

- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender {
    
    if (self.editing) {
        self.editing = NO;
        [self.tableView setEditing:NO animated:NO];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    } else {
        self.editing = true;
        [self.tableView setEditing:YES animated:NO];
        sender.title = @"Done";
        sender.style = UIBarButtonItemStylePlain;
    }
    [_tableView reloadData];
    
}


#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [_titlesArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_titlesArray removeObjectAtIndex:indexPath.row];
    [_descriptionsArray removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *titleItem = [_titlesArray objectAtIndex:sourceIndexPath.row];
    [_titlesArray removeObject:titleItem];
    [_titlesArray insertObject:titleItem atIndex:destinationIndexPath.row];
    
    NSString *descriptionItem = [_descriptionsArray objectAtIndex:sourceIndexPath.row];
    [_descriptionsArray removeObject:descriptionItem];
    [_descriptionsArray insertObject:descriptionItem atIndex:destinationIndexPath.row];
    
    [_tableView reloadData];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath)
    {
        return UITableViewCellEditingStyleNone;
    }
    
    if (self.editing && indexPath.row == _titlesArray.count)
    {
        return UITableViewCellEditingStyleInsert;
    }
    
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}


#pragma mark - Helper Methods
- (void)presentDreamEntry {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter New Dream"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dream Title";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dream Description";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           UITextField *textFieldOne = alertController.textFields[0];
                                                           UITextField *textFieldTwo = alertController.textFields[1];
                                                           
                                                           [_titlesArray addObject:textFieldOne.text];
                                                           [_descriptionsArray addObject:textFieldTwo.text];
                                                           [_tableView reloadData];
                                                       }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = segue.destinationViewController;
    detailVC.titleString = [_titlesArray objectAtIndex:_tableView.indexPathForSelectedRow.row];
    detailVC.descriptionString = [_descriptionsArray objectAtIndex:_tableView.indexPathForSelectedRow.row];
    
}


@end
