#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SEGAppsFlyerIntegration.h"
#import "SEGAppsFlyerIntegrationFactory.h"
#import "SegmentAppsFlyeriOS.h"

FOUNDATION_EXPORT double segment_appsflyer_iosVersionNumber;
FOUNDATION_EXPORT const unsigned char segment_appsflyer_iosVersionString[];

