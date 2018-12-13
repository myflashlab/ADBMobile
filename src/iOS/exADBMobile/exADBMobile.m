//
//  exADBMobile.m
//  exADBMobile
//
//  Created by Hadi Tavakoli on 10/7/18.
//  Copyright © 2018 myflashlabs. All rights reserved.
//

#import "exADBMobile.h"
#import "MyFlashLabsClass.h"
#import "FlashRuntimeExtensions.h"
#import "BaseADBMobile.h"

@interface exADBMobile ()

typedef enum
{
    isTestVersion,
    initialize,
    getVersion,
    collectLifecycleData,
    //keepLifecycleSessionAlive, // not available on Android. This method is intended to be used for apps that register for notifications...
    //pauseCollectingLifecycleData, // don't have this on iOS. Actually this is happening automatically on the iOS side and user does not need to do anything about it.
    
    // configuration methods https://marketing.adobe.com/resources/help/en_US/mobile/ios/sdk_methods.html
    //Config_setContext, // don't have this on iOS
    //Config_registerAdobeDataCallback, // don't have this on iOS
    //Config_setAppExtensionType, // not available on Android. AIR apps 'usually' don't have 'iOS extensions'
    Config_getPrivacyStatus,
    Config_setPrivacyStatus,
    Config_getLifetimeValue,
    Config_getUserIdentifier,
    Config_setUserIdentifier,
    Config_getDebugLogging,
    Config_setDebugLogging,
    //Config_setSmallIconResourceId, //
    //Config_setLargeIconResourceId, //
    //Config_setPushIdentifier,
    Config_submitAdvertisingIdentifierTask,
    Config_collectPII,
    
    // https://marketing.adobe.com/resources/help/en_US/mobile/ios/analytics_main.html
    Analytics_trackState,
    Analytics_trackAction,
    Analytics_getTrackingIdentifier,
    Analytics_trackLocation,
    Analytics_trackTimedActionStart,
    Analytics_trackTimedActionUpdate,
    Analytics_trackTimedActionEnd,
    //Analytics_trackingTimedActionExists, // not available on Android
    Analytics_trackLifetimeValueIncrease,
    Analytics_sendQueuedHits,
    Analytics_getQueueSize,
    Analytics_clearQueue,
    //Analytics_trackPushMessageClickThrough, // not implemented
    
    Media_open,
    Media_close,
    Media_play,
    Media_complete,
    Media_stop,
    Media_click,
    Media_track,
    
    defaultEnum
} commandType;

@end

@implementation exADBMobile

FREContext freContextADBMobile;
static BaseADBMobile *base = nil;

commandType getEnumTitleADBMobile(NSString *theType)
{
#define CHECK_ENUM(X)   if([theType isEqualToString:@#X]) return X
    
    CHECK_ENUM(isTestVersion);
    CHECK_ENUM(initialize);
    CHECK_ENUM(getVersion);
    CHECK_ENUM(collectLifecycleData);
    
    CHECK_ENUM(Config_getPrivacyStatus);
    CHECK_ENUM(Config_setPrivacyStatus);
    CHECK_ENUM(Config_getLifetimeValue);
    CHECK_ENUM(Config_getUserIdentifier);
    CHECK_ENUM(Config_setUserIdentifier);
    CHECK_ENUM(Config_getDebugLogging);
    CHECK_ENUM(Config_setDebugLogging);
    CHECK_ENUM(Config_submitAdvertisingIdentifierTask);
    CHECK_ENUM(Config_collectPII);
    
    CHECK_ENUM(Analytics_trackState);
    CHECK_ENUM(Analytics_trackAction);
    CHECK_ENUM(Analytics_getTrackingIdentifier);
    CHECK_ENUM(Analytics_trackLocation);
    CHECK_ENUM(Analytics_trackTimedActionStart);
    CHECK_ENUM(Analytics_trackTimedActionUpdate);
    CHECK_ENUM(Analytics_trackTimedActionEnd);
    CHECK_ENUM(Analytics_trackLifetimeValueIncrease);
    CHECK_ENUM(Analytics_sendQueuedHits);
    CHECK_ENUM(Analytics_getQueueSize);
    CHECK_ENUM(Analytics_clearQueue);
    
    CHECK_ENUM(Media_open);
    CHECK_ENUM(Media_close);
    CHECK_ENUM(Media_play);
    CHECK_ENUM(Media_complete);
    CHECK_ENUM(Media_stop);
    CHECK_ENUM(Media_click);
    CHECK_ENUM(Media_track);
    
    return defaultEnum;
    
#undef CHECK_ENUM
}

+ (void) dispatchEventEcode:(NSString *) ecode andElevel:(NSString *) elevel
{
    if (freContextADBMobile == NULL)
    {
        return;
    }
    
    const uint8_t* enentLevel = (const uint8_t*) [elevel UTF8String];
    const uint8_t* eventCode = (const uint8_t*) [ecode UTF8String];
    FREDispatchStatusEventAsync(freContextADBMobile, eventCode, enentLevel);
}

// -------------------------------------------------------------------------
FREObject commandADBMobile(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject retFREObject = nil;
    
    NSString *command = [MyFlashLabsClass AirToIos_String:argv[0]];
    commandType temp = getEnumTitleADBMobile(command);
    
    // save the active context from flash
    freContextADBMobile = ctx;
    
    // make sure the base class is initialized
    if (!base) base = [[BaseADBMobile alloc] init];
    
    switch (temp)
    {
        case isTestVersion:
            
            [base isTestVersion];
            
            break;
        case initialize:
            
            [base initialize:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case getVersion:
            
            retFREObject = [MyFlashLabsClass IosToAir_String:[base getVersion]];
            
            break;
        case collectLifecycleData:
            
            [base collectLifecycleData:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case Config_getPrivacyStatus:
            
            retFREObject = [MyFlashLabsClass IosToAir_Integer:[base Config_getPrivacyStatus]];
            
            break;
        case Config_setPrivacyStatus:
            
            [base Config_setPrivacyStatus:[MyFlashLabsClass AirToIos_Integer:argv[1]]];
            
            break;
        case Config_getLifetimeValue:
            
            retFREObject = [MyFlashLabsClass IosToAir_Double:[base Config_getLifetimeValue]];
            
            break;
        case Config_getUserIdentifier:
            
            retFREObject = [MyFlashLabsClass IosToAir_String:[base Config_getUserIdentifier]];
            
            break;
        case Config_setUserIdentifier:
            
            [base Config_setUserIdentifier:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case Config_getDebugLogging:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base Config_getDebugLogging]];
            
            break;
        case Config_setDebugLogging:
            
            [base Config_setDebugLogging:[MyFlashLabsClass AirToIos_Boolean:argv[1]]];
            
            break;
        case Config_submitAdvertisingIdentifierTask:
            
            [base Config_submitAdvertisingIdentifierTask:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case Config_collectPII:
            
            [base Config_collectPII:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case Analytics_trackState:
            
            [base Analytics_trackState:[MyFlashLabsClass AirToIos_String:argv[1]] // state
                        contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]]]; // contextDataStr
            
            break;
        case Analytics_trackAction:
            
            /*
                on Android, we don't have anything like fromBackground
            */
            [base Analytics_trackAction:[MyFlashLabsClass AirToIos_String:argv[1]] // action
                         contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]] // contextDataStr
                         fromBackground:[MyFlashLabsClass AirToIos_Boolean:argv[3]]]; // fromBackground
            
            break;
        case Analytics_getTrackingIdentifier:
            
            retFREObject = [MyFlashLabsClass IosToAir_String:[base Analytics_getTrackingIdentifier]];
            
            break;
        case Analytics_trackLocation:
            
            [base Analytics_trackLocation:[MyFlashLabsClass AirToIos_Double:argv[1]] // lat
                                      lng:[MyFlashLabsClass AirToIos_Double:argv[2]] // lng
                           contextDataStr:[MyFlashLabsClass AirToIos_String:argv[3]]]; // contextDataStr
            
            break;
        case Analytics_trackTimedActionStart:
            
            [base Analytics_trackTimedActionStart:[MyFlashLabsClass AirToIos_String:argv[1]] // action
                                   contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]]]; // contextDataStr
            
            break;
        case Analytics_trackTimedActionUpdate:
            
            [base Analytics_trackTimedActionUpdate:[MyFlashLabsClass AirToIos_String:argv[1]] // action
                                    contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]]]; // contextDataStr
            
            break;
        case Analytics_trackTimedActionEnd:
            
            [base Analytics_trackTimedActionEnd:[MyFlashLabsClass AirToIos_String:argv[1]] // action
                                 contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]] // contextDataStr
                                        sendHit:[MyFlashLabsClass AirToIos_Boolean:argv[3]]]; // sendHit
            
            break;
        case Analytics_trackLifetimeValueIncrease:
            
            [base Analytics_trackLifetimeValueIncrease:[MyFlashLabsClass AirToIos_Double:argv[1]] // amount
                                        contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]]]; // contextDataStr
            
            break;
        case Analytics_sendQueuedHits:
            
            [base Analytics_sendQueuedHits];
            
            break;
        case Analytics_getQueueSize:
            
            retFREObject = [MyFlashLabsClass IosToAir_Double:[base Analytics_getQueueSize]];
            
            break;
        case Analytics_clearQueue:
            
            [base Analytics_clearQueue];
            
            break;
        case Media_open:
            
            [base Media_open:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case Media_close:
            
            [base Media_close:[MyFlashLabsClass AirToIos_String:argv[1]]];
            
            break;
        case Media_play:
            
            [base Media_play:[MyFlashLabsClass AirToIos_String:argv[1]] // name
                      offset:[MyFlashLabsClass AirToIos_Double:argv[2]]]; // offset
            
            break;
        case Media_complete:
            
            [base Media_complete:[MyFlashLabsClass AirToIos_String:argv[1]] // name
                          offset:[MyFlashLabsClass AirToIos_Double:argv[2]]]; // offset
            
            break;
        case Media_stop:
            
            [base Media_stop:[MyFlashLabsClass AirToIos_String:argv[1]] // name
                      offset:[MyFlashLabsClass AirToIos_Double:argv[2]]]; // offset
            
            break;
        case Media_click:
            
            [base Media_click:[MyFlashLabsClass AirToIos_String:argv[1]] // name
                       offset:[MyFlashLabsClass AirToIos_Double:argv[2]]]; // offset
            
            break;
        case Media_track:
            
            [base Media_track:[MyFlashLabsClass AirToIos_String:argv[1]] // name
               contextDataStr:[MyFlashLabsClass AirToIos_String:argv[2]]]; // contextDataStr
            
            break;
        default:
            
            retFREObject = [MyFlashLabsClass IosToAir_String:[[MyFlashLabsClass sharedInstance] retriveCommandNotFound]];
            break;
    }
    
    // Return data back to flash
    return retFREObject;
}

void contextInitializerADBMobile(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 1;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "command";
    func[0].functionData = NULL;
    func[0].function = &commandADBMobile;
    
    *functionsToSet = func;
}

void contextFinalizerADBMobile(FREContext ctx)
{
    return;
}

void comMyflashlabsADBMobileMyExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &contextInitializerADBMobile;
    *ctxFinalizerToSet = &contextFinalizerADBMobile;
}

void comMyflashlabsADBMobileMyExtensionFinalizer(void* extData)
{
    return;
}

@end
