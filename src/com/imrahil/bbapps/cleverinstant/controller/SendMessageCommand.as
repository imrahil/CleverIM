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
    import com.imrahil.bbapps.cleverinstant.model.vo.MessageItemVO;
    import com.imrahil.bbapps.cleverinstant.services.IJabberService;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.Message;
    import org.robotlegs.mvcs.SignalCommand;

    public final class SendMessageCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var messageTxt:String;

        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        [Inject]
        public var jabberService:IJabberService;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function SendMessageCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>SendMessageCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            var message:Message = new Message(cleverModel.currentChat.recipient.escaped, null, null, null, Message.TYPE_CHAT, null);
            message.from = cleverModel.currentUser.jid.escaped;
            message.body = messageTxt;

            jabberService.send(message);
            
            var selfMessage:MessageItemVO = new MessageItemVO();
            selfMessage.author = cleverModel.currentUser.displayName;
            selfMessage.message = messageTxt;
            
            cleverModel.addMessageToCurrentChatRoom(selfMessage);
        }
    }
}
