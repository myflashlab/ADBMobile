# ADBMobile ANE for Adobe AIR apps

This ANE provides AIR developers access Adobe Mobile SDK for [Android](https://marketing.adobe.com/resources/help/en_US/mobile/android/) and [iOS](https://marketing.adobe.com/resources/help/en_US/mobile/ios/).

* [Click here for ASDOC](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/adobeMobile/package-detail.html)
* [Click here for Wiki docs](https://github.com/myflashlab/ADBMobile/wiki)
* [See the ANE setup requirements](https://github.com/myflashlab/ADBMobile/blob/master/src/ANE/extension.xml)

**IMPORTANT:** Implementing ANEs in your AIR projects means you may be required to add some [dependencies](https://github.com/myflashlab/common-dependencies-ANE) or copy some frameworks or editing your app's manifest file. Our ANE setup instruction is designed in a human-readable format but you may still need to familiarize yourself with this format. [Read this post for more information](https://www.myflashlabs.com/understanding-ane-setup-instruction/)

If you think manually setting up ANEs in your projects is confusing or time-consuming, you better check the [ANELAB Software](https://github.com/myflashlab/ANE-LAB/).

[![The ANE-LAB Software](https://www.myflashlabs.com/wp-content/uploads/2017/12/myflashlabs-ANE-LAB_features.jpg)](https://github.com/myflashlab/ANE-LAB/)

# Tech Support #
If you need our professional support to help you with implementing and using the ANE in your project, you can join [MyFlashLabs Club](https://www.myflashlabs.com/product/myflashlabs-club-membership/) or buy a [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/). Otherwise, you may create new issues at this repository and the community might help you.

# AIR Usage #
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

Are you using this ANE in your project? Maybe you'd like to buy us a beer :beer:?

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=payments@myflashlabs.com&lc=US&item_name=Donation+to+ADBMobile+ANE&no_note=0&cn=&currency_code=USD&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted)

Add your name to the below list? Donate anything more than $100 and it will be.

## Sponsored by... ##
<table align="left">
    <tr>
        <td align="left"><img src="https://myflashlab.github.io/sponsors/completecontrol.co.uk.jpg" width="60" height="60"></td>
        <td align="left"><a href="https://www.completecontrol.co.uk">completecontrol.co.uk</a><br>We produce interactive content for the best in children's media</td>
    </tr>
</table>