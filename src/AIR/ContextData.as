package com.myflashlab.air.extensions.adobeMobile
{

/**
 *
 *
 * @author Hadi Tavakoli - 10/8/2018 11:34 AM
 */
public class ContextData
{
	private var _data:Object;
	
	public function ContextData():void
	{
		_data = {};
	}
	
	/** @private */
	internal function get data():String
	{
		var arr:Array = [];
		
		for(var name:String in _data)
		{
			arr.push({key: name, value: _data[name]});
		}
		
		return JSON.stringify(arr);
	}
	
	public function put($key:String, $value:String):void
	{
		if(!$key) return;
		
		if($key.length < 1) return;
		
		_data[$key] = $value;
	}
	
	public function toString():String
	{
		return data;
	}
}
	
}