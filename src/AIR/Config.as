package com.myflashlab.air.extensions.adobeMobile
{

import flash.external.ExtensionContext;

/**
 *
 * @author Hadi Tavakoli - 10/6/2018 7:21 PM
 */
public class Config
{
	private var _context:ExtensionContext;
	
	/** @private */
	public function Config($context:ExtensionContext):void
	{
		_context = $context;
	}
	
	/**
	 * Use this method to submit the advertising ID of your app to ADBMobile. You should get the adId of your app using
	 * the UDID ANE: https://github.com/myflashlab/UDID-ANE/
	 *
	 * @param $adId
	 */
	public function submitAdvertisingIdentifierTask($adId:String):void
	{
		_context.call("command", "Config_submitAdvertisingIdentifierTask", $adId);
	}
	
	/**
	 * Submits a PII collection request
	 *
	 * @param $contextData	containing PII data
	 */
	public function collectPII($contextData:ContextData=null):void
	{
		_context.call("command", "Config_collectPII", ($contextData)?$contextData.data:"");
	}
	
	// ------------------------------------------------------------------------------------------------ properties
	
	/** @private */
	public function set debugLogging(a:Boolean):void
	{
		_context.call("command", "Config_setDebugLogging", a);
	}
	
	/**
	 * indicating the preference for debug log output.
	 */
	public function get debugLogging():Boolean
	{
		return _context.call("command", "Config_getDebugLogging") as Boolean;
	}
	
	/** @private */
	public function set userIdentifier(a:String):void
	{
		if(!a) a = "";
		
		_context.call("command", "Config_setUserIdentifier", a);
	}
	
	/**
	 * indicating the user identifier value.
	 */
	public function get userIdentifier():String
	{
		var userId:String = _context.call("command", "Config_getUserIdentifier") as String;
		
		if(userId.length < 1) return null;
		
		return userId;
	}
	
	/**
	 * Gets user's current lifetime value
	 */
	public function get lifetimeValue():Number
	{
		return _context.call("command", "Config_getLifetimeValue") as Number;
	}
	
	/**
	 * Gets the privacy status which is one of the below statuses:
	 *
	 * <ul>
	 *     <li>MobilePrivacyStatus.STATUS_OPT_IN</li>
	 *     <li>MobilePrivacyStatus.STATUS_OPT_OUT</li>
	 *     <li>MobilePrivacyStatus.STATUS_UNKNOWN</li>
	 * </ul>
	 */
	public function get privacyStatus():int
	{
		return _context.call("command", "Config_getPrivacyStatus") as int;
	}
	
	/** @private */
	public function set privacyStatus(a:int):void
	{
		_context.call("command", "Config_setPrivacyStatus", a);
	}
}
	
}