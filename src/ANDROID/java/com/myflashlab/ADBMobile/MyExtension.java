package com.myflashlab.ADBMobile;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * This is the first class that flash connects to
 *
 * @author Hadi Tavakoli
 */
public class MyExtension implements FREExtension
{
	public static FREContext AS3_CONTEXT;


	public FREContext createContext(String $contextType)
	{
		MyExtension.AS3_CONTEXT = new MyContext();

		return MyExtension.AS3_CONTEXT;
	}

	public void dispose()
	{
		MyExtension.AS3_CONTEXT.dispose();
		MyExtension.AS3_CONTEXT = null;
	}

	public void initialize()
	{

	}

	public static void toDispatch(String $code, String $level)
	{
		try
		{
			AS3_CONTEXT.dispatchStatusEventAsync($code, $level);
		}
		catch (Exception exception)
		{
			com.myflashlab.dependency.overrideAir.MyExtension.toTrace(
					ExConsts.ANE_NAME,
					"MyExtension",
					exception.getMessage());
		}
	}

}
