package com.myflashlab.air.extensions.adobeMobile
{
import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * This is the entry point for using AdobeMobile SDK in your app.
 *
 * @author Hadi Tavakoli - 10/5/2018 3:28 PM
 *
 */
public class ADBMobile
{
	private static const DEMO_ANE:Boolean = false;
	
	public static const EXTENSION_ID:String = "com.myflashlab.air.extensions.ADBMobile";
	public static const VERSION:String = "4.17.11";
	
	private static var _isInitialized:Boolean;
	private static var _ex:ADBMobile;
	private var _config:Config;
	private var _analytics:Analytics;
	private var _media:Media;
	
	private var OverrideClass:Class;
	private var _context:ExtensionContext;
	
	/** @private */
	public function ADBMobile($jsonPath:String):void
	{
		OverrideClass = getDefinitionByName("com.myflashlab.air.extensions.dependency.OverrideAir") as Class;

		if(OverrideClass["os"] == "desktop") return;
		
		OverrideClass["applyToAneLab"](getQualifiedClassName(this));
		
		// initialize the context
		_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		
		_context.call("command", "initialize", $jsonPath);
		
		if(DEMO_ANE) _context.call("command", "isTestVersion");
		
		_config = new Config(_context);
		_analytics = new Analytics(_context);
		_media = new Media(_context);
	}
	
	// ---------------------------------------------------------------------------------------- methods
	
	/**
	 * Call this method to initialize ADBMobile SDK in your app.
	 *
	 * @param $configFile	The config file 'ADBMobileConfig.json' you have downloaded from your AdobeMobile panel.
	 * This file must be placed inside 'File.applicationStorageDirectory' so the ANE can access it.
	 * @return
	 */
	public static function init($configFile:File):ADBMobile
	{
		if(!_ex) _ex = new ADBMobile($configFile.nativePath);
		
		_isInitialized = true;
		
		return _ex;
	}
	
	/**
	 * Indicates the version string of ADBMobile SDK.
	 */
	public static function get sdk_version():String
	{
		return _ex._context.call("command", "getVersion") as String;
	}
	
	/**
	 * Begins the collection of lifecycle data. This should be the first method called upon app launch.
	 *
	 * @param $contextData	ContextData to be added to the lifecycle hit.
	 */
	public static function collectLifecycleData($contextData:ContextData=null):void
	{
		_ex._context.call("command", "collectLifecycleData", ($contextData)?$contextData.data:"");
	}
	
	/**
	 * Required on Android side when app goes to background, on iOS side, this happens automatically.
	 * but on Android side, you must call this whenever your app goes to background. If you forget to call this
	 * method on Android, Analytics will show crash reports wrongly! Calling this method on iOS has not effect.
	 */
	public static function pauseCollectingLifecycleData():void
	{
		_ex._context.call("command", "pauseCollectingLifecycleData");
	}
	
	// ------------------------------------------------------------------------------------------ properties
	
	/**
	 * Gives you access to the <code>Config</code> api.
	 */
	public static function get config():Config
	{
		return _ex._config;
	}
	
	/**
	 * Gives you access to the <code>Analytics</code> api.
	 */
	public static function get analytics():Analytics
	{
		return _ex._analytics;
	}
	
	/**
	 * Gives you access to the <code>Media</code> api.
	 */
	public static function get media():Media
	{
		return _ex._media;
	}
	
	public static function get isInitialized():Boolean
	{
		return _isInitialized;
	}
}
}