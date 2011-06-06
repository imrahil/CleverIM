/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.controller 
{
    import com.imrahil.bbapps.cleverinstant.constants.ApplicationConstants;
    import com.imrahil.bbapps.cleverinstant.model.CleverModel;
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.signals.LoginSignal;
    import com.imrahil.bbapps.cleverinstant.signals.LogoutSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import flash.net.SharedObject;
    
    import mx.logging.ILogger;
    
    import org.robotlegs.mvcs.SignalCommand;

    public final class StartupCommand extends SignalCommand 
    {
        /** PARAMETERS **/

        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        [Inject]
        public var loginSignal:LoginSignal;

        [Inject]
        public var logoutSignal:LogoutSignal;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function StartupCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        /**
         * Method handle the logic for <code>StartupCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");
            
            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.CLEVERIM_SO_NAME);
            
            if (sessionSO.data.server != undefined)
            {
                logger.debug(": sharedObject exist");
                
                var loginCredentials:LoginCredentialsVO = new LoginCredentialsVO();
                loginCredentials.username = String(sessionSO.data.username);
                loginCredentials.password = String(sessionSO.data.password); 
                loginCredentials.server = String(sessionSO.data.server); 
                loginCredentials.serverPort = parseInt(sessionSO.data.serverPort);

                loginSignal.dispatch(loginCredentials);
            }
            else
            {
                logger.debug(": logged out");
                
                logoutSignal.dispatch();
            }
        }
    }
}
