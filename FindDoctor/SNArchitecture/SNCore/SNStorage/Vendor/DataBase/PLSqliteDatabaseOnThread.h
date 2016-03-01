//
//  PLSqliteDatabaseOnThread.h
//  SinaNews
//
//  Created by li na on 13-7-22.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#ifdef WINDOWS
#import "sqlite3.h"
#else
#import <sqlite3.h>
#endif

/* On older versions of sqlite3, sqlite3_prepare_v2() is not available */
#if SQLITE_VERSION_NUMBER <= 3003009
#define PL_SQLITE_LEGACY_STMT_PREPARE 1
#endif

extern NSString *PLSqliteException;


@interface PLSqliteDatabaseOnThread : NSObject<PLDatabase>
{
    @private
    /** Path to the database file. */
    NSString *_path;
    
    /** Underlying sqlite database reference. */
    sqlite3 *_sqlite;
    dispatch_queue_t database_queue;
}

+ (id) databaseWithPath: (NSString *) dbPath;

- (id) initWithPath: (NSString*) dbPath;

- (BOOL) open;
- (BOOL) openAndReturnError: (NSError **) error;

- (sqlite3 *) sqliteHandle;
- (int64_t) lastInsertRowId;

@end

#ifdef PL_DB_PRIVATE

@interface PLSqliteDatabaseOnThread (PLSqliteDatabaseLibraryPrivate)

- (int) lastErrorCode;
- (NSString *) lastErrorMessage;

#ifdef PL_SQLITE_LEGACY_STMT_PREPARE
// This method is only exposed for the purpose of supporting implementations missing sqlite3_prepare_v2()
- (sqlite3_stmt *) createStatement: (NSString *) statement error: (NSError **) error;
#endif

- (void) populateError: (NSError **) result withErrorCode: (PLDatabaseError) errorCode
           description: (NSString *) localizedDescription queryString: (NSString *) queryString;

@end

#endif