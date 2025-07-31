from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher


class ActionGiveOptions(Action):

    def name(self) -> Text:
        return "action_give_options"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        options=["Submit Grievance","Review Grievance","FAQs"]
        dispatcher.utter_message(text="Hey! How can I help you?",
                                 buttons=[{"title": c, "payload":c} for c in options])

        return []
