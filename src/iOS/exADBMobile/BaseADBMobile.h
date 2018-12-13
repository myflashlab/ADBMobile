//
//  BaseADBMobile.h
//  ADBMobile
//
//  Created by Hadi Tavakoli on 10/7/18.
//  Copyright © 2018 myflashlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseADBMobile : NSObject <UIAlertViewDelegate>
{
    BOOL okIsTouch;
}

@property (nonatomic) BOOL okIsTouch;

-(void)isTestVersion;
-(void)initialize:(NSString*)jsonPath;
-(NSString*)getVersion;
-(void)collectLifecycleData:(NSString*)contextDataStr;

-(int)Config_getPrivacyStatus;
-(void)Config_setPrivacyStatus:(int)privacy;
-(double)Config_getLifetimeValue;
-(NSString*)Config_getUserIdentifier;
-(void)Config_setUserIdentifier:(NSString*)userId;
-(BOOL)Config_getDebugLogging;
-(void)Config_setDebugLogging:(BOOL)value;
-(void)Config_submitAdvertisingIdentifierTask:(NSString*)adId;
-(void)Config_collectPII:(NSString*)contextDataStr;

-(void)Analytics_trackState:(NSString*)state contextDataStr:(NSString*)contextDataStr;
-(void)Analytics_trackAction:(NSString*)action contextDataStr:(NSString*)contextDataStr fromBackground:(BOOL)fromBackground;
-(NSString*)Analytics_getTrackingIdentifier;
-(void)Analytics_trackLocation:(double)lat lng:(double)lng contextDataStr:(NSString*)contextDataStr;
-(void)Analytics_trackTimedActionStart:(NSString*)action contextDataStr:(NSString*)contextDataStr;
-(void)Analytics_trackTimedActionUpdate:(NSString*)action contextDataStr:(NSString*)contextDataStr;
-(void)Analytics_trackTimedActionEnd:(NSString*)action contextDataStr:(NSString*)contextDataStr sendHit:(BOOL)sendHit;
-(void)Analytics_trackLifetimeValueIncrease:(double)amount contextDataStr:(NSString*)contextDataStr;
-(void)Analytics_sendQueuedHits;
-(double)Analytics_getQueueSize;
-(void)Analytics_clearQueue;

-(void)Media_open:(NSString*)str;
-(void)Media_close:(NSString*)str;
-(void)Media_play:(NSString*)name offset:(double)offset;
-(void)Media_complete:(NSString*)name offset:(double)offset;
-(void)Media_stop:(NSString*)name offset:(double)offset;
-(void)Media_click:(NSString*)name offset:(double)offset;
-(void)Media_track:(NSString*)name contextDataStr:(NSString*)str;

@end
