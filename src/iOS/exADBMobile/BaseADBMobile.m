//
//  BaseADBMobile.m
//  ADBMobile
//
//  Created by Hadi Tavakoli on 10/7/18.
//  Copyright © 2018 myflashlabs. All rights reserved.
//

#import "BaseADBMobile.h"
#import "exADBMobile.h"
#import "MyFlashLabsClass.h"
#import "ADBMobile.h"
#import <CoreLocation/CoreLocation.h>

@implementation BaseADBMobile
{
    
}

@synthesize okIsTouch;

-(id)init
{
    self = [super init];
    
    return  self;
}

- (void) isTestVersion
{
    // If we know at least one ANE is DEMO, we don't need to show demo dialog again. It's already shown once.
    if([[MyFlashLabsClass sharedInstance] hasAnyDemoAne]) return;
    
    // Check if this ANE is registered?
    if([[MyFlashLabsClass sharedInstance] isAneRegistered:ANE_NAME]) return;
    
    // Otherwise, show the demo dialog.
    
    self.okIsTouch = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DEMO ANE!"
                                                    message:[NSString stringWithFormat:@"The library '%@' is not registered!", ANE_NAME]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.okIsTouch = YES;
    }
}

-(void)initialize:(NSString*)jsonPath
{
    [self toTrace:@"initialize BEGIN"];
    
    //NSURL* jsonURL = [NSURL fileURLWithPath:jsonPath];
    [ADBMobile overrideConfigPath:jsonPath];
    
    [self toTrace:@"initialize BEND"];
}

-(NSString*)getVersion
{
    return [ADBMobile version];
}

-(void)collectLifecycleData:(NSString*)contextDataStr
{
    /*
     
     JsonArray with this format: could be an empty ""
     
     [
        {
            "key": "myapp.category",
            "value": "Game"
        }
     ]
     
     */
    
    [ADBMobile collectLifecycleDataWithAdditionalData:[self convertStrToContextDataDic:contextDataStr]];
}

-(int)Config_getPrivacyStatus
{
    int result = 2; // means ADBMobilePrivacyStatusUnknown
    
    switch ([ADBMobile privacyStatus])
    {
        case ADBMobilePrivacyStatusOptIn:
            result = 0;
            break;
        case ADBMobilePrivacyStatusOptOut:
            result = 1;
            break;
        default:
            result = 2;
            break;
    }
    
    
    return result;
}

-(void)Config_setPrivacyStatus:(int)privacy
{
    ADBMobilePrivacyStatus thePrivacy = ADBMobilePrivacyStatusUnknown;
    
    switch (privacy)
    {
        case 0:
            thePrivacy = ADBMobilePrivacyStatusOptIn;
            break;
        case 1:
            thePrivacy = ADBMobilePrivacyStatusOptOut;
            break;
        default:
            thePrivacy = ADBMobilePrivacyStatusUnknown;
            break;
    }
    
    [ADBMobile setPrivacyStatus:thePrivacy];
}

-(double)Config_getLifetimeValue
{
    return [ADBMobile lifetimeValue].doubleValue;
}

-(NSString*)Config_getUserIdentifier
{
    NSString* userId = [ADBMobile userIdentifier];
    
    if(!userId) return @"";
    
    return userId;
}

-(void)Config_setUserIdentifier:(NSString*)userId
{
    [ADBMobile setUserIdentifier:userId];
}

-(BOOL)Config_getDebugLogging
{
    return [ADBMobile debugLogging];
}

-(void)Config_setDebugLogging:(BOOL)value
{
    [ADBMobile setDebugLogging:value];
}

-(void)Config_submitAdvertisingIdentifierTask:(NSString*)adId
{
    [ADBMobile setAdvertisingIdentifier:adId];
}

-(void)Config_collectPII:(NSString*)contextDataStr
{
    [ADBMobile collectPII:[self convertStrToContextDataDic:contextDataStr]];
}

-(void)Analytics_trackState:(NSString*)state contextDataStr:(NSString*)contextDataStr
{
    [ADBMobile trackState:state data:[self convertStrToContextDataDic:contextDataStr]];
}

-(void)Analytics_trackAction:(NSString*)action contextDataStr:(NSString*)contextDataStr fromBackground:(BOOL)fromBackground
{
    if(fromBackground)
    {
        [ADBMobile trackActionFromBackground:action data:[self convertStrToContextDataDic:contextDataStr]];
    }
    else
    {
        [ADBMobile trackAction:action data:[self convertStrToContextDataDic:contextDataStr]];
    }
}

-(NSString*)Analytics_getTrackingIdentifier
{
    // TODO: This method can cause a blocking network call and should not be used from a UI thread.
    
    NSString* result = [ADBMobile trackingIdentifier];
    
    if(!result) return @"";
    
    return result;
}

-(void)Analytics_trackLocation:(double)lat lng:(double)lng contextDataStr:(NSString*)contextDataStr
{
    CLLocation* location = [[CLLocation alloc]  initWithLatitude:lat longitude:lng];
    [ADBMobile trackLocation:location data:[self convertStrToContextDataDic:contextDataStr]];
}

-(void)Analytics_trackTimedActionStart:(NSString*)action contextDataStr:(NSString*)contextDataStr
{
    [ADBMobile trackTimedActionStart:action data:[self convertStrToContextDataDic:contextDataStr]];
}

-(void)Analytics_trackTimedActionUpdate:(NSString*)action contextDataStr:(NSString*)contextDataStr
{
    [ADBMobile trackTimedActionUpdate:action data:[self convertStrToContextDataDic:contextDataStr]];
}

-(void)Analytics_trackTimedActionEnd:(NSString*)action contextDataStr:(NSString*)contextDataStr sendHit:(BOOL)sendHit
{
    [ADBMobile trackTimedActionEnd:action logic:^BOOL(NSTimeInterval inAppDuration, NSTimeInterval totalDuration, NSMutableDictionary* data)
    {
        [self updateContextData:data withNewFields:contextDataStr];
        
        [exADBMobile dispatchEventEcode:TIMED_ACTION_ENDED andElevel:[NSString stringWithFormat:@"%f|||%f|||%@",
                                                                      inAppDuration,
                                                                      totalDuration,
                                                                      [self convertContextDataToStr:data]]];
        
        return sendHit;
    }];
}

-(void)Analytics_trackLifetimeValueIncrease:(double)amount contextDataStr:(NSString*)contextDataStr
{
    [ADBMobile trackLifetimeValueIncrease:[[NSDecimalNumber alloc] initWithDouble:amount] data:[self convertStrToContextDataDic:contextDataStr]];
}

-(void)Analytics_sendQueuedHits
{
    [ADBMobile trackingSendQueuedHits];
}

-(double)Analytics_getQueueSize
{
    return (double)[ADBMobile trackingGetQueueSize];
}

-(void)Analytics_clearQueue
{
    [ADBMobile trackingClearQueue];
}

-(void)Media_open:(NSString*)str
{
    ADBMediaSettings* mediaSettings = [self convertStrToMediaSettings:str];
    
    [ADBMobile mediaOpenWithSettings:mediaSettings callback:^(ADBMediaState* mediaState)
    {
        //TODO: monitor callback if you want to be notified every second the media is playing
    }];
}

-(void)Media_close:(NSString*)str
{
    [ADBMobile mediaClose:str];
}

-(void)Media_play:(NSString*)name offset:(double)offset
{
    [ADBMobile mediaPlay:name offset:offset];
}

-(void)Media_complete:(NSString*)name offset:(double)offset
{
    [ADBMobile mediaComplete:name offset:offset];
}

-(void)Media_stop:(NSString*)name offset:(double)offset
{
    [ADBMobile mediaStop:name offset:offset];
}

-(void)Media_click:(NSString*)name offset:(double)offset
{
    [ADBMobile mediaClick:name offset:offset];
}

-(void)Media_track:(NSString*)name contextDataStr:(NSString*)str
{
    [ADBMobile mediaTrack:name data:[self convertStrToContextDataDic:str]];
}












-(ADBMediaSettings*) convertStrToMediaSettings:(NSString*)str
{
    NSData* nsdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:nsdata options:0 error:nil];
    
    ADBMediaSettings* settings;
    
    if([[dic objectForKey:@"isMediaAd"] boolValue])
    {
        settings = [ADBMobile mediaAdCreateSettingsWithName:[dic objectForKey:@"name"]
                                                     length:[[dic objectForKey:@"lng"] doubleValue]
                                                 playerName:[dic objectForKey:@"playerName"]
                                                 parentName:[dic objectForKey:@"parentName"]
                                                  parentPod:[dic objectForKey:@"parentPod"]
                                          parentPodPosition:[[dic objectForKey:@"parentPodPosition"] doubleValue]
                                                        CPM:[dic objectForKey:@"cpm"]];
    }
    else
    {
        settings = [ADBMobile mediaCreateSettingsWithName:[dic objectForKey:@"name"]
                                                   length:[[dic objectForKey:@"lng"] doubleValue]
                                               playerName:[dic objectForKey:@"playerName"]
                                                 playerID:[dic objectForKey:@"playerID"]];
    }
    
    if([dic objectForKey:@"milestones"])        settings.milestones = [dic objectForKey:@"milestones"];
                                                settings.segmentByMilestones = [[dic objectForKey:@"segmentByMilestones"] boolValue];
    if([dic objectForKey:@"offsetMilestones"])  settings.offsetMilestones = [dic objectForKey:@"offsetMilestones"];
                                                settings.segmentByOffsetMilestones = [[dic objectForKey:@"segmentByOffsetMilestones"] boolValue];
                                                settings.trackSeconds = [[dic objectForKey:@"trackSeconds"] intValue];
    
    return settings;
}

-(NSString*)convertContextDataToStr:(NSMutableDictionary*)data
{
    NSMutableArray* finalArr = [[NSMutableArray alloc] init];
    
    for(id key in data)
    {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        [d setObject:key forKey:@"key"];
        [d setObject:[data objectForKey:key] forKey:@"value"];
        
        [finalArr addObject:d];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalArr options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

-(void)updateContextData:(NSMutableDictionary*)data withNewFields:(NSString*)str
{
    if(str.length < 1 || !data) return;
    
    NSData* nsdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:nsdata options:0 error:nil];
    
    for(int i=0; i < arr.count; i++)
    {
        NSDictionary* currDic = [arr objectAtIndex:i];
        
        [data setObject:[currDic objectForKey:@"value"] forKey:[currDic objectForKey:@"key"]];
    }
}

-(NSMutableDictionary*)convertStrToContextDataDic:(NSString*)str
{
    if(str.length < 1) return nil;
    
    NSMutableDictionary* finalDic = [[NSMutableDictionary alloc] init];
    
    NSData* nsdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:nsdata options:0 error:nil];
    
    for(int i=0; i < arr.count; i++)
    {
        NSDictionary* currDic = [arr objectAtIndex:i];
        
        [finalDic setObject:[currDic objectForKey:@"value"] forKey:[currDic objectForKey:@"key"]];
    }
    
    return finalDic;
}

-(void)toTrace:(NSString*)value
{
    [[MyFlashLabsClass sharedInstance] toTrace:ANE_NAME
                                     className:NSStringFromClass([self class])
                                           msg:value];
}

@end
