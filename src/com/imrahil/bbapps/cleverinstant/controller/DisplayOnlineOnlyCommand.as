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
    
    import qnx.ui.data.DataProvider;
    import qnx.ui.data.SectionDataProvider;

    public final class DisplayOnlineOnlyCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var displayOnlineOnlyFlag:Boolean;

        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function DisplayOnlineOnlyCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>DisplayOnlineOnlyCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            cleverModel.displayOnlineOnly = displayOnlineOnlyFlag;
            
            if (displayOnlineOnlyFlag)
            {
                var newRoster:SectionDataProvider = new SectionDataProvider();

                // check all sections for offline users
                for each (var section:Object in cleverModel.fullChatUserRoster.data)
                {
                    var newSection:Object = new Object();
                    newSection.label = section.label;
                    
                    newRoster.addItem(newSection);
                    
                    var sectionChildren:DataProvider = cleverModel.fullChatUserRoster.getChildrenForItem(section);
                    
                    // if user is online add him to new roster list
                    for each (var item:RosterItemVO in sectionChildren.data)
                    {
                        if (item.online)
                        {
                            newRoster.addChildToItem(item, newSection);
                        }
                    }
                }
                
                // check sections for empty ones
                for each (var possibleEmptySection:Object in newRoster.data)
                {
                    if (newRoster.getChildrenLengthForItem(possibleEmptySection) == 0)
                    {
                        newRoster.removeItem(possibleEmptySection)
                    }
                }
                
                cleverModel.chatUserRoster = newRoster;
            }
            else
            {
                cleverModel.chatUserRoster = cleverModel.fullChatUserRoster;
            }
        }
    }
}
