/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.controller 
{
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.services.IJabberService;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import mx.logging.ILogger;
    
    import org.robotlegs.mvcs.SignalCommand;

    public final class LoginCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var loginCredentials:LoginCredentialsVO;
        
        /** INJECTIONS **/
        [Inject]
        public var jabberService:IJabberService;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function LoginCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        /**
         * Method handle the logic for <code>LoginCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            jabberService.connect(loginCredentials);
        }
    }
}
