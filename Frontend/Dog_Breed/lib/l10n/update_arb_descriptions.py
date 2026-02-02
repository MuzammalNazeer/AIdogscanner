import os
import json

l10n_dir = r'd:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n'
files = [f for f in os.listdir(l10n_dir) if f.startswith('app_') and f.endswith('.arb')]

updates = {
    "gpsAlertsDescription": "Get instant pet location updates, avoiding the hassle of traditional emails",
    "vetContactsDescription": "Contacts of the vet, co-owner, and caretaker in \n case the main phone isn’t available",
    "messengerDescription": "An alternative way to contact the owner if it is impossible to call them"
}

for filename in files:
    path = os.path.join(l10n_dir, filename)
    try:
        with open(path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Update keys
        for k, v in updates.items():
            data[k] = v
            
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print(f"Updated {filename}")
    except Exception as e:
        print(f"Error updating {filename}: {e}")
