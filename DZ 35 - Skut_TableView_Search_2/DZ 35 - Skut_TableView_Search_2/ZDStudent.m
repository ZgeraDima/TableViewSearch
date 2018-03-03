//
//  ZDStudent.m
//  DZ 35 - Skut_TableView_Search_2
//
//  Created by mac on 03.03.2018.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ZDStudent.h"

@implementation ZDStudent

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSArray *firstNames = [[NSArray alloc]initWithObjects:
                               @"Alex",@"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
                               @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
                               @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
                               @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
                               @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
                               @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
                               @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
                               @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
                               @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
                               @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie", nil];
        
        NSArray *lastNames = [[NSArray alloc] initWithObjects:
                              @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
                              @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
                              @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
                              @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
                              @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
                              @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
                              @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
                              @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
                              @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
                              @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook",nil];
        
        
        self.firstName = [firstNames objectAtIndex:arc4random_uniform((int)[firstNames count])];
        self.lastName = [lastNames objectAtIndex:arc4random_uniform((int)[lastNames count])];
        self.dateOfBirth = [ZDStudent createBirthDay];
        self.firstNameSearchChar = NSMakeRange(0, 0);
        self.lastNameSearchChar = NSMakeRange(0, 0);
    }
    return self;
}

+ (NSDate *)createBirthDay {
    
    NSDate *dateOfBirth = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitYear fromDate:dateOfBirth];
    
    [components setYear:arc4random_uniform(29)+1970];
    [components setMonth:arc4random_uniform(12)+1];
    [components setDay:arc4random_uniform(29)+1];
    
    dateOfBirth = [currentCalendar dateFromComponents:components];
    
    return dateOfBirth;
}

- (NSInteger)getBirthDayMonth {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.dateOfBirth];
    return [components month];
}

- (NSString *)description {
    
    NSString *descriptionStr = [NSString stringWithFormat:@"student %@ %@ %@", self.firstName, self.lastName, self.dateOfBirth];
    
    return descriptionStr;
}


@end
