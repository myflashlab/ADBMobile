package com.myflashlab.air.extensions.adobeMobile
{

import flash.events.EventDispatcher;
import flash.external.ExtensionContext;
import flash.events.StatusEvent;

/**
 *
 *
 * @author Hadi Tavakoli - 10/6/2018 7:26 PM
 */
public class Analytics extends EventDispatcher
{
	private var _context:ExtensionContext;
	
	/** @private */
	public function Analytics($context:ExtensionContext):void
	{
		_context = $context;
		_context.addEventListener(StatusEvent.STATUS, onStatus);
	}
	
	private function onStatus(e:StatusEvent):void
	{
		var arr:Array;
		
		switch(e.code)
		{
			case ADBMobileEvents.TIMED_ACTION_ENDED:
				
				arr = e.level.split("|||");
				var inAppDuration:Number = arr[0];
				var totalDuration:Number = arr[1];
				var contextDataRaw:String = arr[2];
				
				dispatchEvent(new ADBMobileEvents(ADBMobileEvents.TIMED_ACTION_ENDED,
						contextDataRaw,
						inAppDuration,
						totalDuration));
				
				break;
		}
	}
	
	/**
	 * Tracks a state with context data. This method increments page views.
	 *
	 * @param $state		The state value to be tracked
	 * @param $contextData	ContextData to be tracked
	 */
	public function trackState($state:String, $contextData:ContextData=null):void
	{
		_context.call("command", "Analytics_trackState", $state, ($contextData)?$contextData.data:"");
	}
	
	/**
	 * Tracks an action with ContextData. This method does not increment page views.
	 *
	 * @param $action				the action value to be tracked
	 * @param $contextData			ContextData to be tracked
	 * @param $fromBackground		no effect on Android side. on iOS though, it is intended to be called while your
	 * app is in the background (it will not cause lifecycle data to send if the session timeout has been exceeded)
	 */
	public function trackAction($action:String, $contextData:ContextData=null, $fromBackground:Boolean=false):void
	{
		_context.call("command", "Analytics_trackAction", $action, ($contextData)?$contextData.data:"", $fromBackground);
	}
	
	/**
	 * Tracks a location with ContextData. This method does not increment page views.
	 *
	 * @param $latitude
	 * @param $longitude
	 * @param $contextData	ContextData to be tracked
	 */
	public function trackLocation($latitude:Number, $longitude:Number, $contextData:ContextData=null):void
	{
		_context.call("command", "Analytics_trackLocation", $latitude, $longitude, ($contextData)?$contextData.data:"");
	}
	
	/**
	 * Tracks the start of a timed event. This method does not send a tracking hit. If an action with the same name
	 * already exists it will be deleted and a new one will replace it.
	 *
	 * @param $action		String value that denotes the action name to track.
	 * @param $contextData	optional ContextData containing context data to track with this timed action.
	 */
	public function trackTimedActionStart($action:String, $contextData:ContextData=null):void
	{
		_context.call("command", "Analytics_trackTimedActionStart", $action, ($contextData)?$contextData.data:"");
	}
	
	/**
	 * Tracks the start of a timed event. This method does not send a tracking hit. When the timed event is updated, the
	 * contents of the parameter data will overwrite existing context data keys and append new ones.
	 *
	 * @param $action		String value that denotes the action name to track.
	 * @param $contextData	optional ContextData containing context data to track with this timed action.
	 */
	public function trackTimedActionUpdate($action:String, $contextData:ContextData=null):void
	{
		_context.call("command", "Analytics_trackTimedActionUpdate", $action, ($contextData)?$contextData.data:"");
	}
	
	/**
	 * Tracks the end of a timed event. This method will send a tracking hit if the <code>$sendHit</code> parameter
	 * is true.
	 *
	 * @param $action		String pointer that denotes the action name to finish tracking.
	 * @param $contextData	optional ContextData containing context data
	 * @param $sendHit
	 */
	public function trackTimedActionEnd($action:String, $contextData:ContextData=null, $sendHit:Boolean=true):void
	{
		_context.call("command", "Analytics_trackTimedActionEnd", $action, ($contextData)?$contextData.data:"", $sendHit);
	}
	
	/**
	 * Tracks an increase in a user's lifetime value. This method does not increment page views.
	 *
	 * @param $amount		a positive Number detailing the amount to increase lifetime value by.
	 * @param $contextData	ContextData to be tracked
	 */
	public function trackLifetimeValueIncrease($amount:Number, $contextData:ContextData=null):void
	{
		_context.call("command", "Analytics_trackLifetimeValueIncrease", $amount, ($contextData)?$contextData.data:"");
	}
	
	/**
	 * Force library to send all queued hits regardless of current batch options
	 */
	public function sendQueuedHits():void
	{
		_context.call("command", "Analytics_sendQueuedHits");
	}
	
	/**
	 * Retrieves the number of hits currently in the tracking queue
	 * @return	indicating the size of the queue
	 */
	public function getQueueSize():Number
	{
		return _context.call("command", "Analytics_getQueueSize") as Number;
	}
	
	/**
	 * Clears any hits out of the tracking queue and removes them from the database
	 */
	public function clearQueue():void
	{
		_context.call("command", "Analytics_clearQueue");
	}
	
	// ------------------------------------------------------------------------------------------------ properties
	
	/**
	 * Retrieves the analytics tracking identifier.
	 */
	public function get trackingIdentifier():String
	{
		return _context.call("command", "Analytics_getTrackingIdentifier") as String;
	}
}
	
}