//
//  exADBMobile.h
//  exADBMobile
//
//  Created by Hadi Tavakoli on 10/7/18.
//  Copyright © 2018 myflashlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANE_NAME @"com.myflashlab.air.extensions.ADBMobile"

// dispatch events
#define TIMED_ACTION_ENDED @"onTimedActionEnded"

@interface exADBMobile : NSObject

+(void)dispatchEventEcode:(NSString *) ecode andElevel:(NSString *) elevel;

@end
