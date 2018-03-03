//
//  ZDSection.h
//  DZ 35 - Skut_TableView_Search_2
//
//  Created by mac on 03.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDSection : NSObject

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray *itemsArray;

- (void) sortByFirstNameAndLastName;

@end
