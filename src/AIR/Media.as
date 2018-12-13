package com.myflashlab.air.extensions.adobeMobile
{

import flash.external.ExtensionContext;

/**
 *
 * @author Hadi Tavakoli - 10/6/2018 7:27 PM
 */
public class Media
{
	private var _context:ExtensionContext;
	
	/** @private */
	public function Media($context:ExtensionContext):void
	{
		_context = $context;
	}
	
	/**
	 * Opens a media item for tracking based on the provided MediaSettings instance.
	 *
	 * @param $mediaSettings
	 */
	public function open($mediaSettings:MediaSettings):void
	{
		_context.call("command", "Media_open", $mediaSettings.data);
	}
	
	/**
	 * Closes a media item.
	 * @param $name
	 */
	public function close($name:String):void
	{
		_context.call("command", "Media_close", $name);
	}
	
	/**
	 * Begins tracking a media item.
	 *
	 * @param $name		name of media item.
	 * @param $offset	point that the media items is being played from (in seconds)
	 */
	public function play($name:String, $offset:Number):void
	{
		_context.call("command", "Media_play", $name, $offset);
	}
	
	/**
	 * Notifies the media module that the media item has been paused or stopped.
	 *
	 * @param $name		name of media item.
	 * @param $offset	point that the media item was stopped (in seconds)
	 */
	public function stop($name:String, $offset:Number):void
	{
		_context.call("command", "Media_stop", $name, $offset);
	}
	
	/**
	 * Notifies the media module that the media item has been clicked.
	 *
	 * @param $name		name of media item.
	 * @param $offset	point that the media item was clicked (in seconds)
	 */
	public function click($name:String, $offset:Number):void
	{
		_context.call("command", "Media_click", $name, $offset);
	}
	
	/**
	 * Sends a track event with the current media state
	 *
	 * @param $name			name of media item.
	 * @param $contextData	optional ContextData containing context data to track with this media action.
	 */
	public function track($name:String, $contextData:ContextData=null):void
	{
		_context.call("command", "Media_track", $name, ($contextData)?$contextData.data:"");
	}
	
	// ------------------------------------------------------------------------------------------------ properties
}
}