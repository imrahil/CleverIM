/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.components
{
	import qnx.ui.skins.SkinStates;
	import qnx.ui.skins.UISkin;
	
	public class CustomActivityIndicatorSkin extends UISkin
	{
		private var indicator:RoundActivityIndicator = new RoundActivityIndicator();
		
		public function CustomActivityIndicatorSkin()
		{
			super();

			indicator.width = 60;
			indicator.height = 60;
			addChild(indicator);
			indicator.stop();
		}
		
		public override function play():void
		{
			indicator.play();
		}
		
		protected override function initializeStates():void
		{
		}
		
		public override function stop():void
		{
			indicator.stop();
		}
		
		protected override function draw():void
		{
			if (indicator)
			{
				indicator.width = 60;
				indicator.height = 60;
			}
		}
	}
}
