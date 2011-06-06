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
    import com.imrahil.bbapps.cleverinstant.signals.DisplayOnlineOnlySignal;
    import com.imrahil.bbapps.cleverinstant.utils.CustomRoster;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.im.RosterGroup;
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.SignalCommand;
    
    import qnx.ui.data.SectionDataProvider;

    public final class ChatUserRosterLoadedCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var chatUserRoster:CustomRoster;
        
        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        [Inject]
        public var displayOnlineOnlySignal:DisplayOnlineOnlySignal;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function ChatUserRosterLoadedCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>ChatUserRosterLoadedCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");
     
            var rosterGroupsSDP:SectionDataProvider = new SectionDataProvider();

            for each (var group:RosterGroup in chatUserRoster.groups)
            {
//                var statusSF:SortField = new SortField("online");
//                statusSF.compareFunction = myBooleanCompare;
//                var nameSF:SortField = new SortField("displayName", true);
//                nameSF.compareFunction = SortUtil.sortComparePL;
//                
//                var s:ISort = new Sort();
//                s.fields = [statusSF, nameSF];
//                s.compareFunction = myBooleanCompare;
//                
//                group.items.sort = s;
//                group.items.refresh();
                
                var section:Object = new Object();
                section.label = group.label;
                
                rosterGroupsSDP.addItem(section);
                
                for each (var rosterItem:RosterItemVO in group.items)
                {
                    rosterGroupsSDP.addChildToItem(rosterItem, section);
                }
            }

            cleverModel.fullChatUserRoster = rosterGroupsSDP.clone() as SectionDataProvider;

            if (cleverModel.displayOnlineOnly)
            {
                displayOnlineOnlySignal.dispatch(cleverModel.displayOnlineOnly);
            }
            else
            {
                cleverModel.chatUserRoster = rosterGroupsSDP;
            }
        }
    }
}
