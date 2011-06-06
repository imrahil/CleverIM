/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals.signaltons
{
	import org.osflash.signals.Signal;
	
	public class DisplayActivityIndicatorSignal extends Signal
	{
		public function DisplayActivityIndicatorSignal()
		{
			super(Boolean);
		}
	}
}
