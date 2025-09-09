from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import AllSlotsReset
import requests
import os
import logging

logger = logging.getLogger(__name__)


class ActionSubmitGrievance(Action):
    def name(self):
        return "action_submit_grievance"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict) -> List[Dict]:

        title = tracker.get_slot("title")
        description = tracker.get_slot("description")
        department_name = tracker.get_slot("department")
        code = "MOBILE"
        channel = "MOBILE"
        auth_token = tracker.latest_message.get("metadata", {}).get("auth_token")

        grievance_url = "https://43985c7c5131.ngrok-free.app/api/server/api/grievances"
        attachments_url = "https://43985c7c5131.ngrok-free.app/api/server/api/attachments"
        departments_url = "https://43985c7c5131.ngrok-free.app/api/server/api/departments"

        department_id = None

        try:
            dep_response = requests.get(departments_url)
            if dep_response.status_code == 200:
                dep_json = dep_response.json()
                if dep_json.get("success"):
                    departments = dep_json.get("data", [])
                    for dept in departments:
                        if dept.get("name", "").lower() == department_name.lower():
                            department_id = dept.get("_id")
                            break
        except Exception as e:
            logger.error(f"Error fetching departments: {e}")

        payload = {
            "title": title,
            "description": description,
            "departmentName": department_name,
            "departmentId": department_id,
            "code": code,
            "channel": channel
        }

        headers = {
            "Authorization": f'Bearer {auth_token}'
        }
        try:
            response = requests.post(grievance_url, json=payload, headers=headers)
            resp_json = response.json()
            if response.status_code in [200, 201] and resp_json.get("success"):
                grievance_id = resp_json.get("data", {}).get("_id")
                dispatcher.utter_message(
                    text=resp_json.get("message", "Your grievance was submitted successfully.")
                )
            else:
                dispatcher.utter_message(
                    text="Sorry, there was an issue submitting your grievance. Please try again later."
                )
                return []
        except Exception as e:
            logger.error(f"Error submitting grievance: {e}")
            dispatcher.utter_message(
                text="I am unable to reach the grievance server right now. Please try again later."
            )
            return []

        attachments = tracker.get_slot("attachments")
        if attachments and attachments.lower() != "skip":
            file_path = attachments.replace("Uploaded: ", "").strip()
            if os.path.exists(file_path) and grievance_id:
                try:
                    
                    with open(file_path, "rb") as f:
                        files=[("supporting_documents", (os.path.basename(file_path), f))]
                        upload_response = requests.post(
                            attachments_url,
                            data={"grievance": grievance_id},
                            files=files,
                            headers=headers
                        )
                    if upload_response.status_code == 200:
                        dispatcher.utter_message(text="Attachment sent successfully!")
                    else:
                        dispatcher.utter_message(
                            text=f"⚠️ Upload failed {upload_response.status_code}: {upload_response.text}"
                        )
                except Exception as e:
                    dispatcher.utter_message(text=f"❌ Error uploading attachment: {str(e)}")
            else:
                if not os.path.exists(file_path):
                    dispatcher.utter_message(text=f"⚠️ File not found: {file_path}")
                elif not grievance_id:
                    dispatcher.utter_message(text="⚠️ Cannot upload attachment without a valid grievance ID.")
        return []

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
            metadata={"type": "options"}
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

        department_url = "https://dpg-m7odk.ondigitalocean.app/api/server/api/departments"
        
        try:
            response = requests.get(department_url)
            if response.status_code == 200: 
                resp_json = response.json()
                if resp_json.get("success"):
                    departments_data = resp_json.get("data", [])

                    if not departments_data:
                        dispatcher.utter_message(text="Sorry, no departments found at the moment.")
                        return []

                    department_names = [dept.get("name") for dept in departments_data if dept.get("active")]

                    dispatcher.utter_message(text="Select the department", custom={"dropdown": department_names})
                else:
                    dispatcher.utter_message(text="Failed to fetch departments. Please try again later.")
            else:
                dispatcher.utter_message(text="Failed to fetch departments. Please try again later.")
        except Exception:
            dispatcher.utter_message(text="Unable to fetch departments right now. Please try again later.")
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
