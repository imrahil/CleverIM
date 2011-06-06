/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view
{
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    import com.riaspace.as3viewnavigator.ViewNavigator;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    import mx.logging.ILogger;
    
    import org.osflash.signals.Signal;
    
    public class MainAppNavigator extends Sprite
    {
        public var mainNavigator:ViewNavigator;
        public var loginView:LoginView;
        
        public var creationCompleteSignal:Signal = new Signal();

        private var logger:ILogger;
        
        public function MainAppNavigator():void 
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
            
            this.addEventListener(Event.ADDED_TO_STAGE, view_addedToStage);
        }
        
        protected function view_addedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, view_addedToStage);
            
            initUI();
        }
        
        protected function initUI():void
        {
            logger.debug(": initUI");

            mainNavigator = new ViewNavigator();
            addChild(mainNavigator);
            
            creationCompleteSignal.dispatch();
        }
    }
}
