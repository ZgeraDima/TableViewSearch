//
//  ViewController.m
//  DZ 35 - Skut_TableView_Search_2
//
//  Created by mac on 03.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ViewController.h"
#import "ZDStudent.h"
#import "ZDSection.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *sortDescriptorsArray;
@property (strong, nonatomic) NSInvocationOperation *sortOperation;


@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.studentsArray = [NSMutableArray array];
    
    for (int i = 0; i < 5000; i++) {
        
        ZDStudent *student = [[ZDStudent alloc]init];
        [self.studentsArray addObject:student];
    }
    
    NSSortDescriptor *firstNameD = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameD = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSSortDescriptor *dateOfBirthD = [[ NSSortDescriptor alloc]initWithKey:@"dateOfBirth" ascending:YES];
    
    self.sortDescriptorsArray = [NSMutableArray arrayWithObjects:firstNameD, lastNameD, dateOfBirthD, nil];
    self.sectionsArray = [[NSMutableArray alloc]init];
    
    self.sortOperation = [[NSInvocationOperation alloc]initWithTarget:self
                                                             selector:@selector(sortByMonthInBackGround) object:nil];
    [self.sortOperation start];
}

#pragma mark - Sorting Arrays

- (void) sortByMonthInBackGround {
    
    self.studentsArray = [self sortStudentsByBirthdayMonth:self.studentsArray];
    self.sectionsArray = [self generateSectionsFromBirthdayMonth:self.studentsArray];
    
    __weak ViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

- (void) sortByFirstNamesInBackground {
    
    [self.studentsArray sortUsingDescriptors:self.sortDescriptorsArray];
    self.sectionsArray = [self generateSectionFromFirstNames:self.studentsArray];
    
    __weak ViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

- (void) sortByLastNamesInBackground {
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [self.sortDescriptorsArray objectAtIndex:1],
                                [self.sortDescriptorsArray objectAtIndex:2],
                                [self.sortDescriptorsArray objectAtIndex:0], nil];
    
    [self.studentsArray sortUsingDescriptors:sortDescriptors];
    self.sectionsArray = [self generateSectionsFromLastNames:self.studentsArray];
    
    __weak ViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

- (NSMutableArray *) sortStudentsByBirthdayMonth: (NSMutableArray *) students {
    
    [students sortUsingComparator:^NSComparisonResult(ZDStudent *obj1, ZDStudent *obj2) {
        
        if ([obj1 getBirthDayMonth] < [obj2 getBirthDayMonth]) {
            return (NSComparisonResult) NSOrderedAscending;
            
        } else if ([obj1 getBirthDayMonth] > [obj2 getBirthDayMonth]) {
            return (NSComparisonResult) NSOrderedDescending;
            
        } else return (NSComparisonResult) NSOrderedSame;
    }];
    
    return students;
}

#pragma mark - Sections Generating

- (NSMutableArray *) generateSectionsFromBirthdayMonth:(NSMutableArray*)students  {
    
    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSString *currentMonth = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMM"];
    
    for (ZDStudent *student in students) {
        
        NSString *firstMonth = [dateFormat stringFromDate:student.dateOfBirth];
        ZDSection *section = nil;
        
        if (![currentMonth isEqualToString:firstMonth]) {
            section = [[ZDSection alloc]init];
            section.sectionName = firstMonth;
            section.itemsArray = [NSMutableArray array];
            currentMonth = firstMonth;
            [sectionsArray addObject:section];
            
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.itemsArray addObject:student];
    }
    
    for (ZDSection * section in sectionsArray) {
        
        [section sortByFirstNameAndLastName];
    }
    
    return sectionsArray;
}

- (NSMutableArray*) generateSectionFromFirstNames:(NSMutableArray*) students {
    
    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSString* currentLetter = nil;
    
    for (ZDStudent *student in students) {
        
        NSString *firstLetter = [student.firstName substringToIndex:1];
        ZDSection *section = nil;
        
        if (![firstLetter isEqualToString:currentLetter]) {
            section = [[ZDSection alloc]init];
            section.sectionName = firstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
            
        } else {
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject:student];
    }
    
    return sectionsArray;
}

- (NSMutableArray *) generateSectionsFromLastNames: (NSMutableArray*)students {
    
    NSMutableArray *sectionsArray = [[NSMutableArray alloc]init];
    NSString *currentLetter = nil;
    
    for (ZDStudent *student in students) {
        
        NSString *firstLetter = [student.lastName substringToIndex:1];
        ZDSection *section = nil;
        
        if (![firstLetter isEqualToString:currentLetter]) {
            section = [[ZDSection alloc]init];
            section.sectionName = firstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
            
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.itemsArray addObject:student];
    }
    
    return sectionsArray;
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.sectionsArray objectAtIndex:section] sectionName];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *titlesArray = [[NSMutableArray alloc]init];
    
    for (ZDSection *thisSection in self.sectionsArray) {
        
        if (self.sortingTypeControl.selectedSegmentIndex == ZDSortingTypeFirstName
            || self.sortingTypeControl.selectedSegmentIndex == ZDSortingTypeLastName) {
            
            NSString *firstLetterTitle = [thisSection.sectionName substringToIndex:1];
            [titlesArray addObject:firstLetterTitle];
            
        } else {
            [titlesArray addObject:thisSection.sectionName];
        }
        
    }
    
    return titlesArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZDSection *thisSection = [self.sectionsArray objectAtIndex:section];
    
    return [thisSection.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    ZDSection *thisSection = [self.sectionsArray objectAtIndex:indexPath.section];
    ZDStudent *student = [thisSection.itemsArray objectAtIndex:indexPath.row];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    cell.textLabel.text = fullName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:student.dateOfBirth];
    cell.imageView.image = [UIImage imageNamed:@"student.png"];
    cell.userInteractionEnabled = NO;
    
    
    UIColor *whiteColor = [UIColor whiteColor];
    UIColor *blueColor = [UIColor blueColor];
    
    if ([self.searchBar.text length]) {
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:fullName];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:whiteColor range:student.firstNameSearchChar];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:whiteColor range:student.lastNameSearchChar];
        
        [attributedStr addAttribute:NSBackgroundColorAttributeName
                              value:blueColor range:student.firstNameSearchChar];
        [attributedStr addAttribute:NSBackgroundColorAttributeName
                              value:blueColor range:student.lastNameSearchChar];
        
        cell.textLabel.attributedText = attributedStr;
    }
    
    return cell;
}

#pragma mark - UISegmentedControl Action

- (IBAction)actionSortingTypeControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == ZDSortingTypeMonthOfBirth) {
        [self.sortOperation cancel];
        self.sortOperation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                 selector:@selector(sortByMonthInBackGround)
                                                                   object:nil];
        [self.sortOperation start];
        
    } else if (sender.selectedSegmentIndex == ZDSortingTypeFirstName) {
        [self.sortOperation cancel];
        self.sortOperation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                 selector:@selector(sortByFirstNamesInBackground)
                                                                   object:nil];
        [self.sortOperation start];
        
    } else if (sender.selectedSegmentIndex == ZDSortingTypeLastName) {
        [self.sortOperation cancel];
        self.sortOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                  selector:@selector(sortByLastNamesInBackground)
                                                                    object:nil];
        [self.sortOperation start];
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.studentsArray = [self sortStudentsByBirthdayMonth:self.studentsArray];
    self.sectionsArray = [self generateSectionsFromBirthdayMonth:self.studentsArray];
    self.sortingTypeControl.selectedSegmentIndex = ZDSortingTypeMonthOfBirth;
    [self clearStudentsSearchRange];
    searchBar.text = @"";
    [self.tableView reloadData];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSMutableArray *tempStudentsArray = self.studentsArray;
    NSMutableArray *tempSectionsArray = [NSMutableArray arrayWithArray:self.sectionsArray];
    [self clearStudentsSearchRange];
    
    if ([searchText length] == 1) {
        
        [tempSectionsArray removeAllObjects];
        ZDSection *section = [[ZDSection alloc]init];
        section.sectionName = searchText;
        
        for (ZDStudent *student in tempStudentsArray) {
            
            if ([student.firstName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)] == NSOrderedSame
                || [student.lastName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)] == NSOrderedSame) {
                
                if ([student.firstName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)] == NSOrderedSame) {
                    
                    student.firstNameSearchChar = NSMakeRange(0, 1);
                }
                
                if ([student.lastName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)] == NSOrderedSame) {
                    
                    student.lastNameSearchChar = NSMakeRange([student.firstName length] + 1, 1);
                }
                
                [section.itemsArray addObject:student];
            }
        }
        [tempSectionsArray addObject:section];
        self.sectionsArray = tempSectionsArray;
        
        
    } else if ([searchText length] > 1) {
        
        [tempSectionsArray removeAllObjects];
        ZDSection *foundSection = [self.sectionsArray firstObject];
        foundSection.sectionName = searchText;
        NSMutableArray *tempStudentsArray = [[NSMutableArray alloc]init];
        
        for (ZDStudent * student in foundSection.itemsArray) {
            
            if ([student.firstName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchText length])] == NSOrderedSame
                || [student.lastName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchText length])] == NSOrderedSame) {
                
                if ([student.firstName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0,[searchText length])] == NSOrderedSame) {
                    
                    student.firstNameSearchChar = NSMakeRange(0, [searchText length]);
                }
                
                if ([student.lastName compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0,[searchText length])] == NSOrderedSame) {
                    
                    student.lastNameSearchChar = NSMakeRange([student.firstName length] + 1, [searchText length]);
                }
                
                [tempStudentsArray addObject:student];
            }
        }
        
        if (![tempStudentsArray count]) {
            
            NSString *message = [NSString stringWithFormat:@"Student with name: <%@> not found!", searchText];
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Not Found!"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [alertCtrl addAction:alertAct];
            [self presentViewController:alertCtrl animated:YES completion:nil];
            
        } else {
            
            foundSection.itemsArray = tempStudentsArray;
            [tempSectionsArray addObject:foundSection];
            self.sectionsArray = tempSectionsArray;
        }
        
        
    } else if ([searchText length] < 1) {
        
        self.studentsArray = [self sortStudentsByBirthdayMonth:self.studentsArray];
        self.sectionsArray = [self generateSectionsFromBirthdayMonth:self.studentsArray];
        
        self.sortingTypeControl.selectedSegmentIndex = ZDSortingTypeMonthOfBirth;
        [self clearStudentsSearchRange];
    }
    
    [self.tableView reloadData];
}

- (void) clearStudentsSearchRange {
    
    for (ZDStudent *student in self.studentsArray) {
        student.firstNameSearchChar = NSMakeRange(0, 0);
        student.lastNameSearchChar = NSMakeRange(0, 0);
    }
}


@end
