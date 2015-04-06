//
//  HomeViewController.h
//  HelloWorld
//
//  Created by Michael Fuller on 4/5/15.
//  Copyright (c) 2015 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController

- (IBAction)returnFromProfileChanged:(UIStoryboardSegue *)segue;

- (IBAction)returnFromPlayerToHome:(UIStoryboardSegue *)segue;

@end
