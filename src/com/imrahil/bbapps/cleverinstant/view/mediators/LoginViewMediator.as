/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.mediators
{
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.signals.LoginSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.DisplayActivityIndicatorSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    import com.imrahil.bbapps.cleverinstant.view.LoginView;
    
    import flash.events.MouseEvent;
    
    import mx.logging.ILogger;
    
    import org.robotlegs.mvcs.Mediator;
    
    public class LoginViewMediator extends Mediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:LoginView;
        
        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var loginSignal:LoginSignal;
        
        /** variables **/
        private var logger:ILogger; 
        
        /** 
         * CONSTRUCTOR 
         */
        public function LoginViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */		
        override public function onRegister():void
        {
            logger.debug(": onRegister");
            
            view.loginClicked.add(handleLoginClicked);
        }
        
        /** methods **/	
        
        private function handleLoginClicked(loginCredentials:LoginCredentialsVO):void
        {
            logger.debug(": handleLoginClicked");
            
            loginSignal.dispatch(loginCredentials);
        }
    }
}
