package com.myflashlab.ADBMobile;


import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.location.Location;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.myflashlab.Conversions;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Callable;

import com.adobe.mobile.*;

/**
 * @author Hadi Tavakoli
 */
public class AirCommand implements FREFunction
{
	private boolean isDialogCalled = false;
	private boolean isDialogClicked = false;

	private Activity _activity;

	private enum commands
	{
		isTestVersion,
		initialize,
		getVersion,
		collectLifecycleData,
		pauseCollectingLifecycleData,

		// configuration methods https://marketing.adobe.com/resources/help/en_US/mobile/android/methods.html
		//Config_setContext, // we don't have this on iOS, so on Android, we should set the AIR context automatically
		//Config_registerAdobeDataCallback, // we don't have this on iOS
		Config_getPrivacyStatus,
		Config_setPrivacyStatus,
		Config_getLifetimeValue,
		Config_getUserIdentifier,
		Config_setUserIdentifier,
		Config_getDebugLogging,
		Config_setDebugLogging,
		//Config_setSmallIconResourceId, // Config.setSmallIconResourceId(R.drawable.appIcon);
		//Config_setLargeIconResourceId, // Config.setLargeIconResourceId(R.drawable.appIcon);
		//Config_setPushIdentifier,
		Config_submitAdvertisingIdentifierTask,
		Config_collectPII,

		// https://marketing.adobe.com/resources/help/en_US/mobile/android/analytics_main.html
		Analytics_trackState,
		Analytics_trackAction,
		Analytics_getTrackingIdentifier,
		Analytics_trackLocation,
		Analytics_trackTimedActionStart,
		Analytics_trackTimedActionUpdate,
		Analytics_trackTimedActionEnd,
		Analytics_trackLifetimeValueIncrease,
		Analytics_sendQueuedHits,
		Analytics_getQueueSize,
		Analytics_clearQueue,

		Media_open,
		Media_close,
		Media_play,
		Media_complete,
		Media_stop,
		Media_click,
		Media_track,
	}

	private void showTestVersionDialog()
	{
		// If we know at least one ANE is DEMO, we don't need to show demo dialog again. It's already shown once.
		if(com.myflashlab.dependency.overrideAir.MyExtension.hasAnyDemoAne()) return;

		// Check if this ANE is registered?
		if(com.myflashlab.dependency.overrideAir.MyExtension.isAneRegistered(ExConsts.ANE_NAME)) return;

		// Otherwise, show the demo dialog.

		AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(_activity);
		dialogBuilder.setTitle("DEMO ANE!");
		dialogBuilder.setMessage("The library '"+ExConsts.ANE_NAME+"' is not registered!");
		dialogBuilder.setCancelable(false);
		dialogBuilder.setPositiveButton("OK", new DialogInterface.OnClickListener()
		{
			public void onClick(DialogInterface dialog, int id)
			{
				dialog.dismiss();
				isDialogClicked = true;
			}
		});

		AlertDialog myAlert = dialogBuilder.create();
		myAlert.show();

		isDialogCalled = true;
	}

	public FREObject call(FREContext $context, FREObject[] $params)
	{
		String command = Conversions.AirToJava_String($params[0]);
		FREObject result = null;

		if (_activity == null)
		{
			_activity = $context.getActivity();
		}

		switch (commands.valueOf(command))
		{
			case isTestVersion:

				showTestVersionDialog();

				break;
			case initialize:

				initialize(Conversions.AirToJava_String($params[1]));
				Config.setContext(_activity.getApplicationContext());

				break;
			/*case Config_setContext:

				//TODO: like passing a reference from other ANEs activities, maybe we should do the same for this method also
				// for this version, we are passing Activity and Context of the AIR app only
				Config.setContext(_activity.getApplicationContext());

				break;*/
			/*case Config_registerAdobeDataCallback:

				registerAdobeDataCallback();

				break;*/
			case getVersion:

				result = Conversions.JavaToAir_String(Config.getVersion());

				break;
			case collectLifecycleData:

				//TODO: You must add these calls to every activity to ensure accurate crash reporting. For more information, see Track App Crashes.
				// https://marketing.adobe.com/resources/help/en_US/mobile/android/crashes.html#concept_07DAAEDAE5A04FD6AB01279C644F2073
				// An idea is to create a method for all other ANEs to point to their Activity references so we can pass them to ADBMobile
				collectLifecycleData(Conversions.AirToJava_String($params[1]));

				break;
			case pauseCollectingLifecycleData:

				Config.pauseCollectingLifecycleData();

				break;
			case Config_getPrivacyStatus:

				result = Conversions.JavaToAir_Integer(getPrivacyStatus());

				break;
			case Config_setPrivacyStatus:

				setPrivacyStatus(Conversions.AirToJava_Integer($params[1]));

				break;
			case Config_getLifetimeValue:

				result = Conversions.JavaToAir_Double(Config.getLifetimeValue().doubleValue());

				break;
			case Config_getUserIdentifier:

				result = Conversions.JavaToAir_String(getUserIdentifier());

				break;
			case Config_setUserIdentifier:

				setUserIdentifier(Conversions.AirToJava_String($params[1]));

				break;
			case Config_getDebugLogging:

				result = Conversions.JavaToAir_Boolean(Config.getDebugLogging());

				break;
			case Config_setDebugLogging:

				Config.setDebugLogging(Conversions.AirToJava_Boolean($params[1]));

				break;
			case Config_submitAdvertisingIdentifierTask:

				submitAdvertisingIdentifierTask(Conversions.AirToJava_String($params[1]));

				break;
			case Config_collectPII:

				Config.collectPII(convertStrToContextDataMap(Conversions.AirToJava_String($params[1])));

				break;
			case Analytics_trackState:

				Analytics_trackState(
						Conversions.AirToJava_String($params[1]), // $state
						Conversions.AirToJava_String($params[2]) // $contextDataStr
				);

				break;
			case Analytics_trackAction:

				Analytics_trackAction(
						Conversions.AirToJava_String($params[1]), // $action
						Conversions.AirToJava_String($params[2]) // $contextDataStr
						// in iOS we can track actions while in background which is not available on Android side!
						// on iOS, AIR is sending the third parameter "fromBackground as Boolean" but in Android, we are not using it
				);

				break;
			case Analytics_getTrackingIdentifier:

				result = Conversions.JavaToAir_String(Analytics_getTrackingIdentifier());

				break;
			case Analytics_trackLocation:

				Analytics_trackLocation(
						Conversions.AirToJava_Double($params[1]), // $lat
						Conversions.AirToJava_Double($params[2]), // $lng
						Conversions.AirToJava_String($params[3]) // $contextDataStr
				);

				break;
			case Analytics_trackTimedActionStart:

				Analytics_trackTimedActionStart(
						Conversions.AirToJava_String($params[1]), // $action
						Conversions.AirToJava_String($params[2]) // $contextDataStr
				);

				break;
			case Analytics_trackTimedActionUpdate:

				Analytics_trackTimedActionUpdate(
						Conversions.AirToJava_String($params[1]), // $action
						Conversions.AirToJava_String($params[2]) // $contextDataStr
				);

				break;
			case Analytics_trackTimedActionEnd:

				Analytics_trackTimedActionEnd(
						Conversions.AirToJava_String($params[1]), // $action
						Conversions.AirToJava_String($params[2]), // $contextDataStr
						Conversions.AirToJava_Boolean($params[3]) // $sendHit
				);

				break;
			case Analytics_trackLifetimeValueIncrease:

				Analytics_trackLifetimeValueIncrease(
						Conversions.AirToJava_Double($params[1]), // $amount
						Conversions.AirToJava_String($params[2]) // $contextDataStr
				);

				break;
			case Analytics_sendQueuedHits:

				Analytics.sendQueuedHits();

				break;
			case Analytics_getQueueSize:

				result = Conversions.JavaToAir_Long(Analytics.getQueueSize());

				break;
			case Analytics_clearQueue:

				Analytics.clearQueue();

				break;
			case Media_open:

				Media_open(
						Conversions.AirToJava_String($params[1]) // $mediaSettingStr
				);

				break;
			case Media_close:

				Media.close(Conversions.AirToJava_String($params[1])); // Closes the media item named name.

				break;
			case Media_play:

				Media_play(
						Conversions.AirToJava_String($params[1]), // $name
						Conversions.AirToJava_Double($params[2]) // $offset
				);

				break;
			case Media_complete:

				Media_complete(
						Conversions.AirToJava_String($params[1]), // $name
						Conversions.AirToJava_Double($params[2]) // $offset
				);

				break;
			case Media_stop:

				Media_stop(
						Conversions.AirToJava_String($params[1]), // $name
						Conversions.AirToJava_Double($params[2]) // $offset
				);

				break;
			case Media_click:

				Media_click(
						Conversions.AirToJava_String($params[1]), // $name
						Conversions.AirToJava_Double($params[2]) // $offset
				);

				break;
			case Media_track:

				Media_track(
						Conversions.AirToJava_String($params[1]), // $name
						Conversions.AirToJava_String($params[2]) // $contextDataStr
				);

				break;
		}

		return result;
	}

	private String Analytics_getTrackingIdentifier()
	{
		String result = Analytics.getTrackingIdentifier();

		if(result == null) return "";

		return result;
	}

	private void Analytics_trackLocation(double $lat, double $lng, String $contextDataStr)
	{
		Location location = new Location("manualADBMobileANE");
		location.setLatitude($lat);
		location.setLongitude($lng);

		Analytics.trackLocation(location, convertStrToContextDataMap($contextDataStr));
	}

	private void Media_track(String $name, String $contextDataStr)
	{
		Media.track($name, convertStrToContextDataMap($contextDataStr));
	}

	private void Media_click(String $name, double $offset)
	{
		Media.click($name, $offset);
	}

	private void Media_stop(String $name, double $offset)
	{
		Media.stop($name, $offset);
	}

	private void Media_complete(String $name, double $offset)
	{
		Media.complete($name, $offset);
	}

	private void Media_play(String $name, double $offset)
	{
		Media.play($name, $offset);
	}

	private void Media_open(String $mediaSettingStr)
	{
		MediaSettings settings = convertStrToMediaSettings($mediaSettingStr);

		Media.open(settings, new Media.MediaCallback()
		{
			@Override
			public void call(Object item)
			{
				// TODO: monitor callback if you want to be notified every second the media is playing
				//toTrace("Media.MediaCallback() " + item);
			}
		});
	}

	private void Analytics_trackLifetimeValueIncrease(double $amount, String $contextDataStr)
	{
		Analytics.trackLifetimeValueIncrease(BigDecimal.valueOf($amount), convertStrToContextDataMap($contextDataStr));
	}

	private void Analytics_trackTimedActionEnd(String $action, final String $contextDataStr, final boolean $sendHit)
	{
		Analytics.trackTimedActionEnd($action, new Analytics.TimedActionBlock<Boolean>()
		{
			@Override
			public Boolean call(long inAppDuration, long totalDuration, Map<String, Object> contextData)
			{
				updateContextDataWithNewFields(contextData, $contextDataStr);

				MyExtension.toDispatch(ExConsts.TIMED_ACTION_ENDED,
						inAppDuration+"|||"+totalDuration+"|||"+convertContextDataMapToJsonArray(contextData).toString());

				return $sendHit;
			}
		});
	}

	private void updateContextDataWithNewFields(Map<String, Object> contextData, String $contextDataStr)
	{
		if ($contextDataStr.length() < 1 || contextData == null) return;

		try
		{
			JSONArray arr = new JSONArray($contextDataStr);

			for (int i = 0; i < arr.length(); i++)
			{
				JSONObject obj = arr.getJSONObject(i);
				contextData.put(obj.getString("key"), obj.getString("value"));
			}
		}
		catch (Exception $exception)
		{
			toTrace($exception.getMessage());
		}
	}

	private void Analytics_trackTimedActionUpdate(String $action, String $contextDataStr)
	{
		Analytics.trackTimedActionUpdate($action, convertStrToContextDataMap($contextDataStr));
	}

	private void Analytics_trackTimedActionStart(String $action, String $contextDataStr)
	{
		Analytics.trackTimedActionStart($action, convertStrToContextDataMap($contextDataStr));
	}

	private void Analytics_trackAction(String $action, String $contextDataStr)
	{
		Analytics.trackAction($action, convertStrToContextDataMap($contextDataStr));
	}

	private void Analytics_trackState(String $state, String $contextDataStr)
	{
		Analytics.trackState($state, convertStrToContextDataMap($contextDataStr));
	}

	private void submitAdvertisingIdentifierTask(final String $adId)
	{
		final Callable<String> task = new Callable<String>()
		{
			@Override
			public String call() throws Exception
			{
				return $adId;
			}
		};

		Config.submitAdvertisingIdentifierTask(task);
	}

	private void setUserIdentifier(String $userId)
	{
		Config.setUserIdentifier($userId);
	}

	/**
	 * @return if userId is null, empty "" is returned to AIR
	 */
	private String getUserIdentifier()
	{
		String userId = Config.getUserIdentifier();

		if (userId == null)
		{
			return "";
		}

		return userId;
	}

	private void setPrivacyStatus(int $privacy)
	{
		MobilePrivacyStatus privacyStatus = MobilePrivacyStatus.MOBILE_PRIVACY_STATUS_UNKNOWN;

		switch ($privacy)
		{
			case 0:
				privacyStatus = MobilePrivacyStatus.MOBILE_PRIVACY_STATUS_OPT_IN;
				break;
			case 1:
				privacyStatus = MobilePrivacyStatus.MOBILE_PRIVACY_STATUS_OPT_OUT;
				break;
			case 2:
				privacyStatus = MobilePrivacyStatus.MOBILE_PRIVACY_STATUS_UNKNOWN;
				break;
		}

		Config.setPrivacyStatus(privacyStatus);
	}

	private int getPrivacyStatus()
	{
		int result = 2; // means MOBILE_PRIVACY_STATUS_UNKNOWN

		switch (Config.getPrivacyStatus())
		{
			case MOBILE_PRIVACY_STATUS_OPT_IN:
				result = 0;
				break;
			case MOBILE_PRIVACY_STATUS_OPT_OUT:
				result = 1;
				break;
			case MOBILE_PRIVACY_STATUS_UNKNOWN:
				result = 2;
				break;
		}

		return result;
	}

	/*private void registerAdobeDataCallback()
	{
		Config.registerAdobeDataCallback(new Config.AdobeDataCallback()
		{
			@Override
			public void call(Config.MobileDataEvent event, Map<String, Object> contextData)
			{
				String eCode = null;
				switch (event)
				{
					case MOBILE_EVENT_LIFECYCLE:

						eCode = "MOBILE_EVENT_LIFECYCLE";

						break;
					case MOBILE_EVENT_ACQUISITION_INSTALL:

						eCode = "MOBILE_EVENT_ACQUISITION_INSTALL";

						break;
					case MOBILE_EVENT_ACQUISITION_LAUNCH:

						eCode = "MOBILE_EVENT_ACQUISITION_LAUNCH";

						break;
				}

//				MyExtension.toDispatch(eCode, convertContextDataMapToJsonArray(contextData).toString());
			}
		});
	}*/

	/**
	 * @param $jsonPath path to ADBMobileConfig.json file
	 */
	private void initialize(String $jsonPath)
	{
		File file = new File($jsonPath);
		try
		{
			FileInputStream configInput = new FileInputStream(file);
			Config.overrideConfigStream(configInput);
		}
		catch (Exception e)
		{
			toTrace(e.getMessage());
		}
	}

	/**
	 * @param $contextDataStr JsonArray with this format: could be an empty ""
	 *                        [
	 *                        	{
	 *                        		"key": "myapp.category",
	 *                        		"value": "Game"
	 *                        	}
	 *                        ]
	 */
	private void collectLifecycleData(String $contextDataStr)
	{
		Config.collectLifecycleData(_activity, convertStrToContextDataMap($contextDataStr));
	}

	// --------------------------------------------------------------- convert data methods

	private JSONArray convertContextDataMapToJsonArray(Map<String, Object> $map)
	{
		JSONArray arr = new JSONArray();

		try
		{
			for (Map.Entry<String, Object> entry : $map.entrySet())
			{
				JSONObject obj = new JSONObject();
				obj.put("key", entry.getKey());
				obj.put("value", entry.getValue());

				arr.put(obj);
			}
		}
		catch (Exception e)
		{
			toTrace(e.getMessage());
		}

		return arr;
	}

	private HashMap<String, Object> convertStrToContextDataMap(String $str)
	{
		if ($str.length() < 1)
		{
			return null;
		}

		HashMap<String, Object> contextData = null;

		try
		{
			JSONArray arr = new JSONArray($str);
			contextData = new HashMap<String, Object>();

			for (int i = 0; i < arr.length(); i++)
			{
				JSONObject obj = arr.getJSONObject(i);
				contextData.put(obj.getString("key"), obj.getString("value"));
			}
		}
		catch (Exception $exception)
		{
			toTrace($exception.getMessage());
		}

		return contextData;
	}

	private MediaSettings convertStrToMediaSettings(String $mediaSettingStr)
	{
		MediaSettings settings = null;

		try
		{
			JSONObject obj = new JSONObject($mediaSettingStr);

			if(obj.getBoolean("isMediaAd"))
			{
				settings = Media.adSettingsWith(
						obj.getString("name"),
						obj.getDouble("lng"),
						obj.getString("playerName"),
						obj.getString("parentName"),
						obj.getString("parentPod"),
						obj.getDouble("parentPodPosition"),
						obj.getString("cpm")
				);
			}
			else
			{
				settings = Media.settingsWith(
						obj.getString("name"),
						obj.getDouble("lng"),
						obj.getString("playerName"),
						obj.getString("playerID")
				);
			}

			if(obj.has("milestones")) 				settings.milestones = obj.getString("milestones");
															settings.segmentByMilestones = obj.getBoolean("segmentByMilestones");
			if(obj.has("offsetMilestones")) 			settings.offsetMilestones = obj.getString("offsetMilestones");
															settings.segmentByOffsetMilestones = obj.getBoolean("segmentByOffsetMilestones");
															settings.trackSeconds = obj.getInt("trackSeconds");
		}
		catch (Exception e)
		{
			toTrace(e.getMessage());
		}

		return settings;
	}

	private void toTrace(String $msg)
	{
		com.myflashlab.dependency.overrideAir.MyExtension.toTrace(
				ExConsts.ANE_NAME,
				this.getClass().getSimpleName(),
				$msg);
	}
}