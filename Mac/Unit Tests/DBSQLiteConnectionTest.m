//
//  DBSQLiteConnectionTest.m
//  DatabaseKit
//
//  Created by Fjölnir Ásgeirsson on 8.8.2007.
//  Copyright 2007 Fjölnir Ásgeirsson. All rights reserved.
//

#import "DBSQLiteConnectionTest.h"
#import <DatabaseKit/DatabaseKit.h>
#import "GHTestCase+Fixtures.h"

@implementation DBSQLiteConnectionTest
- (void)setUp
{
    db = [super setUpSQLiteFixtures];
}

- (void)tearDown
{
    GHAssertTrue([db.connection closeConnection], @"Couldn't close connection");
}

- (void)testConnection
{
    GHAssertNotNil(db.connection, @"connection should not be nil");
}

- (void)testFetchColumns
{
    // Test if we fetch correct columns
    NSArray *columnsFromDb = [db.connection columnsForTable:@"foo"];
    NSArray *columnsFixture = @[@"id", @"bar", @"baz", @"integer"];
    for(NSString *fixture in columnsFixture)
    {
        GHAssertTrue([columnsFromDb containsObject:fixture],
                     @"Columns didn't contain: %@", fixture);
    }
}

- (void)testQuery
{
    NSString *query = @"SELECT * FROM foo" ;
    NSArray *result = [db.connection executeSQL:query substitutions:nil error:nil];
    GHAssertTrue([result count] == 2, @"foo should have 2 rows");
    NSArray *columns = [result[0] allKeys];
    NSArray *expectedColumns = @[@"id", @"bar", @"baz", @"integer"];
    for(NSString *fixture in expectedColumns)
    {
        GHAssertTrue([columns containsObject:fixture],
                     @"Columns didn't contain: %@", fixture);
    }
    int i = 0;
    for(id row in [db[@"foo"] select]) {
        ++i;
    }
    GHAssertEquals(i, 2, @"Fast enumeration did not evaluate the correct amount of times");
}

@end