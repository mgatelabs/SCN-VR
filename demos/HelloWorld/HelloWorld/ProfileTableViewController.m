//
//  ProfileTableViewController.m
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "NameValueTableViewCell.h"
#import "WizardItemTableViewController.h"
#import "ProfileNameTableViewCell.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _extendedStorage = @[
                         [[NSMutableArray alloc] initWithCapacity:5],
                         [[NSMutableArray alloc] initWithCapacity:5],
                         [[NSMutableArray alloc] initWithCapacity:5],
                         [[NSMutableArray alloc] initWithCapacity:5],
                         [[NSMutableArray alloc] initWithCapacity:5]
                         ];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self fillExtendedStorage];
}

- (void)dealloc
{
    _extendedStorage = nil;
}

-(void) fillExtendedStorage {
    
    NSMutableArray * tempMutableArray;
    
    for (int i = 0; i < 5; i++) {
        tempMutableArray = [_extendedStorage objectAtIndex:i];
        [tempMutableArray removeAllObjects];
    }
    
    for (int i = 0; i < _wizard.extenedItemCount; i++) {
        WizardItem * item = [_wizard.visibleItems objectAtIndex: i + _wizard.profileItemCount];
        
        tempMutableArray = [_extendedStorage objectAtIndex:item.sectionIndex];
        [tempMutableArray addObject:item];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Profile Name";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _wizard.profileItemCount;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            ProfileNameTableViewCell *cell = (ProfileNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
            
            cell.pc = _profile;
            
            cell.textfield.text = _profile.name;
            
            return cell;
        } break;
        case 1:
        default: {
            NameValueTableViewCell *cell = (NameValueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"nameValue" forIndexPath:indexPath];
       
            WizardItem * item = [_wizard.visibleItems objectAtIndex:indexPath.row];
        
            cell.name.text = item.title;
            cell.value.text = [item stringForIndex:item.valueIndex];
            
            return cell;
        } break;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        WizardItem * item = [_wizard.visibleItems objectAtIndex:indexPath.row];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:item.title message:item.info preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (indexPath.section >= 2) {
        
        NSMutableArray * temp = [_extendedStorage objectAtIndex:indexPath.section - 2];
        WizardItem * item = [temp objectAtIndex:indexPath.row];
        
        //WizardItem * item = [_wizard.visibleItems objectAtIndex:indexPath.row + _wizard.profileItemCount];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:item.title message:item.info preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showWizardItem"]) {
        
        WizardItemTableViewController *destViewController = (WizardItemTableViewController *)segue.destinationViewController;
        
        NSIndexPath * index = [self.tableView indexPathForSelectedRow];
        
        WizardItem * wizardItem = nil;
        
        if (index.section == 1) {
            int row = (int)index.row;
            wizardItem = [_wizard.visibleItems objectAtIndex:row];
        
        } else if (index.section >= 2) {
            
            NSMutableArray * temp = [_extendedStorage objectAtIndex:index.section - 2];
            wizardItem = [temp objectAtIndex:index.row];
            
        }
        
        destViewController.manager = _wizard;
        destViewController.item = wizardItem;
        destViewController.visibleIndex = wizardItem.visibleIndex;
        
    }
}

- (IBAction)returnFromWizardItemHome:(UIStoryboardSegue *)segue {
    [self fillExtendedStorage];
    [self.tableView reloadData];
}

@end
