//
//  ViewController.h
//  DZ 35 - Skut_TableView_Search_2
//
//  Created by mac on 03.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

typedef enum {
    
    ZDSortingTypeMonthOfBirth,
    ZDSortingTypeFirstName,
    ZDSortingTypeLastName
    
} ZDSortingType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingTypeControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)actionSortingTypeControl:(UISegmentedControl *)sender;


@end

