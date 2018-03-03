//
//  ZDSection.m
//  DZ 35 - Skut_TableView_Search_2
//
//  Created by mac on 03.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ZDSection.h"

@implementation ZDSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void) sortByFirstNameAndLastName {
    
    NSSortDescriptor *firstNameD = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameD = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptorsArray = [[NSMutableArray alloc]initWithObjects:firstNameD, lastNameD, nil];
    
    [self.itemsArray sortUsingDescriptors:sortDescriptorsArray];
}

@end
