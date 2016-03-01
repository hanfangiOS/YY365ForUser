//
//  SNLocationRequestDefines.h
//
//  Copyright (c) 2014 SNit Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#ifndef SN_LOCATION_REQUEST_DEFINES_H
#define SN_LOCATION_REQUEST_DEFINES_H

#define kSNHorizontalAccuracyThresholdCity            5000.0  // in meters
#define kSNHorizontalAccuracyThresholdNeighborhood    1000.0  // in meters
#define kSNHorizontalAccuracyThresholdBlock           100.0   // in meters
#define kSNHorizontalAccuracyThresholdHouse           15.0    // in meters
#define kSNHorizontalAccuracyThresholdRoom            5.0     // in meters

#define kSNUpdateTimeStaleThresholdCity               600.0   // in seconds
#define kSNUpdateTimeStaleThresholdNeighborhood       300.0   // in seconds
#define kSNUpdateTimeStaleThresholdBlock              60.0    // in seconds
#define kSNUpdateTimeStaleThresholdHouse              15.0    // in seconds
#define kSNUpdateTimeStaleThresholdRoom               5.0     // in seconds

// An abstraction of both the horizontal accuracy and recency of location data.
// Room is the highest level of accuracy/recency; City is the lowest level.
typedef NS_ENUM(NSInteger, SNLocationAccuracy) {
    /* Not valid as a desired accuracy. */
    SNLocationAccuracyNone = 0,     // Inaccurate (>5000 meters, received >10 minutes ago)
    
    /* These options are valid desired accuracies. */
    SNLocationAccuracyCity,         // 5000 meters or better, received within the last 10 minutes  -- lowest accuracy
    SNLocationAccuracyNeighborhood, // 1000 meters or better, received within the last 5 minutes
    SNLocationAccuracyBlock,        // 100 meters or better, received within the last 1 minute
    SNLocationAccuracyHouse,        // 15 meters or better, received within the last 15 seconds
    SNLocationAccuracyRoom,         // 5 meters or better, received within the last 5 seconds      -- highest accuracy
};

typedef NS_ENUM(NSInteger, SNLocationStatus) {
    /* These statuses will accompany a valid location. */
    SNLocationStatusSuccess = 0,  // got a location and desired accuracy level was achieved successfully
    SNLocationStatusTimedOut,     // got a location, but desired accuracy level was not reached before timeout
    
    /* These statuses indicate some sort of error, and will accompany a nil location. */
    SNLocationStatusServicesNotDetermined, // user has not responded to the permissions dialog
    SNLocationStatusServicesDenied,        // user has explicitly denied this app permission to access location services
    SNLocationStatusServicesRestricted,    // user does not have ability to enable location services (e.g. parental controls, corporate policy, etc)
    SNLocationStatusServicesDisabled,      // user has turned off device-wide location services from system settings
    SNLocationStatusError                  // an error occurred while using the system location services
};

/**
 A block type for a location request, which is executed when the request succeeds, fails, or times out.
 
 @param currentLocation The most recent & accurate current location available when the block executes, or nil if no valid location is available.
 @param achievedAccuracy The accuracy level that was actually achieved (may be better than, equal to, or worse than the desired accuracy).
 @param status The status of the location request - whether it succeeded, timed out, or failed due to some sort of error. This can be used to
               understand what the outcome of the request was, decide if/how to use the associated currentLocation, and determine whether other
               actions are required (such as displaying an error message to the user, retrying with another request, quietly proceeding, etc).
 */
typedef void(^SNLocationRequestBlock)(CLLocation *currentLocation, SNLocationAccuracy achievedAccuracy, SNLocationStatus status);

#endif /* SN_LOCATION_REQUEST_DEFINES_H */
