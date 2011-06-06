/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.controller 
{
    import com.imrahil.bbapps.cleverinstant.model.CleverModel;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.SignalCommand;

    public final class UserLoggedCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var currentUser:RosterItemVO;
        
        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function UserLoggedCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>UserLoggedCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");
            
            cleverModel.currentUser = currentUser;
        }
    }
}
