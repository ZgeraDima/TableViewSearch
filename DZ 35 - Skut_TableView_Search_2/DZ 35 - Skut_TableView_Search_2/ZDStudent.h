//
//  ZDStudent.h
//  DZ 35 - Skut_TableView_Search_2
//
//  Created by mac on 03.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (assign, nonatomic) NSRange firstNameSearchChar;
@property (assign, nonatomic) NSRange lastNameSearchChar;

+ (NSDate*) createBirthDay;

- (NSInteger) getBirthDayMonth;


@end
