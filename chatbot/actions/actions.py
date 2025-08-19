from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import AllSlotsReset

class ActionGiveOptions(Action):

    def name(self) -> Text:
        return "action_give_options"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        options = ["Submit Grievance", "Review Grievance", "FAQs"]
        dispatcher.utter_message(
            text="Hey! How can I help you?",
            buttons=[{"title": c, "payload": c} for c in options],
            metadata={"type": "options"}  # <-- added for frontend
        )
        return []

class ActionResetGrievanceForm(Action):
    def name(self) -> Text:
        return "action_reset_grievance_form"
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        return [AllSlotsReset()]
        

class ActionAskDepartment(Action):

    def name(self) -> Text:
        return "action_ask_department"
    
    async def run(self, dispatcher: CollectingDispatcher,
                  tracker: Tracker,
                  domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        departments = [
            "Agriculture Department",
            "Electricity Department",
            "Revenue Department",
            "Public Works Department",
            "Water Supply Department",
            "Health Department",
            "Education Department",
            "Transport Department",
            "Fisheries Department",
            "Tourism Department",
            "Labour and Employment Department",
            "Urban Development Department",
            "Rural Development Department",
            "Forest Department",
            "Food and Civil Supplies Department"
        ]
        
        dispatcher.utter_message(
            text="Select the department",
            #buttons=[{"title": c, "payload": c} for c in departments],
            custom={"dropdown": departments} 
        )
        return []


class ActionListPendingGrievances(Action):
    def name(self) -> str:
        return "action_list_pending_grievances"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[str, Any]) -> List[Dict[str, Any]]:

        buttons = []
        for grievance in pending_grievances:
            buttons.append({
                "title": grievance["title"],
                "payload": f'/select_grievance{{"grievance_id":"{grievance["id"]}"}}'
            })

        dispatcher.utter_message(
            text="Here is a list of your pending grievances:",
            buttons=buttons,
            metadata={"type": "options"}
        )
        return []


class ActionShowGrievanceStatus(Action):
    def name(self) -> str:
        return "action_show_grievance_status"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[str, Any]) -> List[Dict[str, Any]]:

        grievance_id = tracker.get_slot("grievance_id")
        if not grievance_id:
            dispatcher.utter_message(text="Sorry, I couldn't find which grievance you selected.")
            return []
        
        status_message = status_lookup.get(grievance_id, "Status information is not available.")
        dispatcher.utter_message(text=status_message)
        return []


pending_grievances = [
    {"id": "1342", "title": "Water Leakage Issue"},
    {"id": "2324", "title": "Road Repair Delay"},
    {"id": "3564", "title": "Garbage Collection Problem"}
]

status_lookup = {
    "1342": "Your water leakage complaint is being processed and will be fixed within 3 days.",
    "2324": "Road repair has been scheduled for next week.",
    "3564": "Garbage collection is delayed due to holidays."
}
