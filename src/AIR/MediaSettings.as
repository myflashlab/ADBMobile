package com.myflashlab.air.extensions.adobeMobile
{

/**
 *
 * @author Hadi Tavakoli - 10/6/2018 7:14 PM
 */
public class MediaSettings
{
	private var _isMediaAd:Boolean;
	
	// Media.settingsWith & Media.adSettingsWith
	private var _name:String;
	private var _lng:Number;
	private var _playerName:String;
	private var _milestones:String;
	private var _segmentByMilestones:Boolean = false;
	private var _offsetMilestones:String;
	private var _segmentByOffsetMilestones:Boolean = false;
	private var _trackSeconds:int = 0;
	
	// Media.adSettingsWith
	private var _parentName:String;
	private var _parentPod:String;
	private var _parentPodPosition:Number;
	private var _cpm:String;
	
	// Media.settingsWith
	private var _playerID:String;
	
	/**
	 * initialize an instance of this class while indicating if this is targeted for an ad media or not.
	 *
	 * @param $isMediaAd
	 */
	public function MediaSettings($isMediaAd:Boolean):void
	{
		_isMediaAd = $isMediaAd;
	}
	
	/** @private */
	internal function get data():String
	{
		var obj:Object = {};
		
		obj.isMediaAd = _isMediaAd;
		obj.name = _name;
		obj.lng = _lng;
		obj.playerName = _playerName;
		
		if(_milestones) obj.milestones = _milestones;
		obj.segmentByMilestones = _segmentByMilestones;
		if(_offsetMilestones) obj.offsetMilestones = _offsetMilestones;
		obj.segmentByOffsetMilestones = _segmentByOffsetMilestones;
		obj.trackSeconds = _trackSeconds;
		
		if(_isMediaAd)
		{
			obj.parentName = _parentName;
			obj.parentPod = _parentPod;
			obj.parentPodPosition = _parentPodPosition;
			obj.cpm = _cpm;
		} else
		{
			obj.playerID = _playerID;
		}
		
		return JSON.stringify(obj);
	}
	
	/**
	 * The interval at which tracking data should be sent, the default is 0.
	 * @param a
	 */
	public function set trackSeconds(a:int):void
	{
		_trackSeconds = a;
	}
	
	/**
	 * Indicates if segment info should be automatically generated for offset milestones or not, the default is false.
	 *
	 * @param a
	 */
	public function set segmentByOffsetMilestones(a:Boolean):void
	{
		_segmentByOffsetMilestones = a;
	}
	
	/**
	 * A comma-delimited list of intervals (in seconds) for sending tracking data.
	 *
	 * @param a
	 */
	public function set offsetMilestones(a:String):void
	{
		_offsetMilestones = a;
	}
	
	/**
	 * Indicates if segment info should be automatically generated for milestones generated or not, the default is false.
	 *
	 * @param a
	 */
	public function set segmentByMilestones(a:Boolean):void
	{
		_segmentByMilestones = a;
	}
	
	/**
	 * A comma-delimited list of intervals (as a percentage) for sending tracking data.
	 *
	 * @param a
	 */
	public function set milestones(a:String):void
	{
		_milestones = a;
	}
	
	/**
	 * ID of media player.
	 *
	 * @param a
	 */
	public function set playerID(a:String):void
	{
		_playerID = a;
	}
	
	public function set cpm(a:String):void
	{
		_cpm = a;
	}
	
	/**
	 * position of parent pod (in seconds).
	 *
	 * @param a
	 */
	public function set parentPodPosition(a:Number):void
	{
		_parentPodPosition = a;
	}
	
	/**
	 * of the media item that the media ad is playing in.
	 *
	 * @param a
	 */
	public function set parentPod(a:String):void
	{
		_parentPod = a;
	}
	
	/**
	 * name of the ads parent video.
	 *
	 * @param a
	 */
	public function set parentName(a:String):void
	{
		_parentName = a;
	}
	
	/**
	 * name of media player.
	 *
	 * @param a
	 */
	public function set playerName(a:String):void
	{
		_playerName = a;
	}
	
	/**
	 * length of media (in seconds).
	 *
	 * @param a
	 */
	public function set lng(a:Number):void
	{
		_lng = a;
	}
	
	/**
	 * name of media item.
	 *
	 * @param a
	 */
	public function set name(a:String):void
	{
		_name = a;
	}
}
	
}