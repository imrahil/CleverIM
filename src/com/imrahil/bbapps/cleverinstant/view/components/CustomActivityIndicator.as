/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	import qnx.ui.progress.ActivityIndicator;
	
	public class CustomActivityIndicator extends Sprite
	{
		public var activityIndicator:ActivityIndicator;
		
		public function CustomActivityIndicator()
		{
			super();
			
            this.addEventListener(Event.ADDED_TO_STAGE, view_addedToStage);
        }
        
        protected function view_addedToStage(event:Event):void
        {
			activityIndicator = new ActivityIndicator();
			activityIndicator.setSkin(CustomActivityIndicatorSkin);
			activityIndicator.setPosition((this.stage.stageWidth - activityIndicator.width)/2, (this.stage.stageHeight - activityIndicator.height)/2);
			
            addChild(activityIndicator);
		}
	}
}
