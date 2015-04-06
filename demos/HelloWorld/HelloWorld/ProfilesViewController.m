//
//  ProfileViewController.m
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ProfilesViewController.h"
#import "ProfileTableViewController.h"
#import "NameValueTableViewCell.h"

@interface ProfilesViewController ()

@end

@implementation ProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dirty = NO;
    
    _profiles = [ProfileManager sharedManager];
    
    _wasEditing = NO;
    _wasEditingIndex = 0;
    
    _forcedEditIndex = -1;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_wasEditing) {
        _wasEditing = NO;
        
        WizardManager * wizard = [_profiles wizardManager];
        
        if (wizard.dirty) {
            // This form is dirty
            _dirty = YES;
            
            ProfileConfiguration * pc = [_profiles.profiles objectAtIndex:_wasEditingIndex];
            
            pc.values = [wizard extractItem];
        }
        
        // Save to disk
        [_profiles persist];
        
        [self.tableView reloadData];
    } else {
        if (_forceViewSelected) {
            _forceViewSelected = NO;
            _forcedEditIndex = self.profiles.index;
            [self performSegueWithIdentifier: @"showProfile" sender: self];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _profiles.count;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        int row = (int)indexPath.row;
        
        [_profiles deleteIndex:row];
        [self.tableView reloadData];
        
        [_profiles persist];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL selected = indexPath.row == _profiles.index;
    
    UITableViewCell * cell = nil;
    UILabel * refLabel = nil;
    
    if (selected) {
        NameValueTableViewCell * nvc = [tableView dequeueReusableCellWithIdentifier: @"selected"  forIndexPath:indexPath];
        refLabel = nvc.name;
        cell = nvc;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];
        refLabel = cell.textLabel;
    }
    
    
    refLabel.text = [_profiles nameForIndex:(int)indexPath.row];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _forcedEditIndex = (int)indexPath.row;
    [self performSegueWithIdentifier: @"navigateToProfile" sender: indexPath];
}

#pragma mark - Actions

-(IBAction) actionHit:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Actions" message:@"What would you like to do?" preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.barButtonItem = self.actionButton;
    
    UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelButton];
    
    UIAlertAction * createButton = [UIAlertAction actionWithTitle:@"New Profile" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self createNewProfile:sender];
        
    }];
    [alertController addAction:createButton];
    
    if (self.tableView.editing == NO) {
        
    } else {
        NSArray * selections = [self.tableView indexPathsForSelectedRows];
        
        if (selections.count == 1) {
            UIAlertAction * copyButton = [UIAlertAction actionWithTitle:@"Copy Profile" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self copyProfile:sender];
                
            }];
            [alertController addAction:copyButton];
        }
    }
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
    
}

-(IBAction) createNewProfile:(id)sender {
    _forcedEditIndex = [_profiles newProfile];
    _wasEditing = YES;
    [self performSegueWithIdentifier: @"showProfile" sender: self];
}

-(IBAction) copyProfile:(id)sender {
    
    NSIndexPath * index = [self.tableView indexPathForSelectedRow];
    
    ProfileConfiguration * profile = [self.profiles.profiles objectAtIndex:index.row];
    
    _forcedEditIndex = [_profiles newProfile];
    
    ProfileConfiguration * otherProfile = [self.profiles.profiles objectAtIndex:_forcedEditIndex];
    
    otherProfile.name = [NSString stringWithFormat:@"%@ Copy", profile.name];
    
    // Copy values
    [otherProfile.values removeAllObjects];
    [otherProfile.values setValuesForKeysWithDictionary:profile.values];
    
    _wasEditing = YES;
    [self performSegueWithIdentifier: @"showProfile" sender: self];
}

-(IBAction) helpPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Help", @"Help") message:@"Profiles are very important and can negatively effect your VR experience if not properly setup.  To edit a profile, tap on the selected row, or press on it's information icon.  Please review each item in the profile carefully.  The top section controls how content will be displayed, everything else allows you to customize your experience." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    self.tableView.editing = !self.tableView.editing;
    
    //_deleteIcon.enabled = self.tableView.editing;
    //_moveIcon.enabled = self.tableView.editing;
    //_createFolderIcon.enabled = !self.tableView.editing;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    [_profiles moveIndex:(int)sourceIndexPath.row to:(int)destinationIndexPath.row];
    
    [self.profiles persist];
}

#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
 
    if (self.tableView.editing) {
        return NO;
    }
    return true;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showProfile"]) {
        
        ProfileTableViewController *destViewController = (ProfileTableViewController *)segue.destinationViewController;
        
        NSIndexPath * index = [self.tableView indexPathForSelectedRow];
        int row = _forcedEditIndex >= 0 ? _forcedEditIndex : (int)index.row;
        [self.tableView deselectRowAtIndexPath:index animated:NO];
        
        _forcedEditIndex = -1;
        
        ProfileConfiguration * pc = [_profiles.profiles objectAtIndex:row];
        WizardManager * wizard = [_profiles wizardManager];
        [wizard insertItem:pc.values];
        
        destViewController.wizard = wizard;
        destViewController.profile = pc;
        
        _wasEditing = YES;
        _wasEditingIndex = row;
    } else if ([segue.identifier isEqualToString:@"profileChanged"]) {
        
        int row = (int)[self.tableView indexPathForSelectedRow].row;
        
        [_profiles selectIndex:row];
    }
}


@end
