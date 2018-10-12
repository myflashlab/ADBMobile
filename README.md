**Pre-release version** Please do not use in production.

The main ANE, **ADBMobile.ane** includes the latest Android [*release notes for Android*](https://marketing.adobe.com/resources/help/en_US/mobile/android/) and iOS [*release notes for iOS*](https://marketing.adobe.com/resources/help/en_US/mobile/ios/) SDKs for Adobe Experience Cloud V4.17.0 being released on *September 20, 2018* 

Make sure to study the [ASDOC](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/adobeMobile/package-detail.html) for this ANE to know how to work with it. We have tried to keep the method names similar to the Native methods.

The ANE depends on the [OverrideAir ANE](https://github.com/myflashlab/common-dependencies-ANE/tree/master/overridAir) on both Android and iOS sides and you should be using at least AIR SDK 30 to compile your app. Below is the required manifest .xml settings:

```xml
<!-- Android -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-sdk android:targetSdkVersion="26"/>




<!-- iOS -->
<!--
    Read this link and apply if required based on your apps required specifications:
    https://marketing.adobe.com/resources/help/en_US/mobile/ios/app_transport_security.html
-->




<!-- Extensions -->
<extensions>
	<extensionID>com.myflashlab.air.extensions.ADBMobile</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
</extensions>
```

After implemnting the ANE, it's time to see how the API should be initialized. ANE initialization must happen the soonest possible in your app. The best place for this is the Construction-function of the Document-class of your project.

1. Add the config file, **ADBMobileConfig.json** to you app.
```actionscript
// config file should be in File.applicationStorageDirectory

// If you are bundling the config file in your app, it will be in File.applicationDirectory
var f:File = File.applicationDirectory.resolvePath("ADBMobileConfig.json");

// You should copy it to File.applicationStorageDirectory
var dis:File = File.applicationStorageDirectory.resolvePath("ADBMobileConfig.json");

f.copyTo(dis);

// call init and pass the config File to it.
ADBMobile.init(dis);
```

2. Managing the Analytics App LifeCycle. On Android, you must notify the ANE when app starts or goes to background each time, on the iOS side however, this is managed automatically by the SDK.

```actionscript
/*
    Right after the ANE is initialized, call "collectLifecycleData"

    iOS will send lifecycle information with or without calling "collectLifecycleData"; and
    this method is only a way to initiate lifecycle earlier in the application's launch sequence.
*/
ADBMobile.collectLifecycleData();
```

On Android, listen for **Event.ACTIVATE** and **Event.DEACTIVATE** and when app goes to background or when it closes, call **pauseCollectingLifecycleData()**

```actionscript
NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);

private static function handleActivate(e:Event):void
{
    if(OverrideAir.os == OverrideAir.ANDROID)
    {
        if(ADBMobile.isInitialized)
        {
            // this happens on iOS automatically. so we should call this on Android
            ADBMobile.collectLifecycleData();
        }
    }
}

private static function handleDeactivate(e:Event):void
{
    if(OverrideAir.os == OverrideAir.ANDROID)
    {
        // this happens on iOS automatically. so we should pause only on Android
        ADBMobile.pauseCollectingLifecycleData();
    }
}
```

3. Different methods of the ANE, are expecting an optional **ContextData** object. You can use it to pass any context data you like based on your apps requirements. below is a sample on how to create a ContextData instance and pass it to the collectLifecycleData method.

```actionscript
var ctx:ContextData = new ContextData();
ctx.put("myapp.category", "Game");
// ctx.put("key", "value");
// ctx.put("key3", "value3");
ADBMobile.collectLifecycleData(ctx);
```

4. Accessing the analytics methods and other APIs are through static getters of ADBMobile class:
```actionscript
ADBMobile.analytics.
ADBMobile.config.
ADBMobile.media.
```

5. For Video Analytics, you need to pass in the events to the ANE using the ```ADBMobile.media.``` API.

```actionscript
var mediaSettings:MediaSettings = new MediaSettings(false);
mediaSettings.name = "name";
mediaSettings.lng = 10;
mediaSettings.playerName = "playerName";
mediaSettings.playerID = "playerId";
// for other settings check asdoc

ADBMobile.media.open(mediaSettings);

// check asdoc to know other methods like ADBMobile.media.stop(
```