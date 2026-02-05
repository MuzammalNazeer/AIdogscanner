import json
import os
import glob

def add_keys():
    directory = os.path.dirname(os.path.abspath(__file__))
    arb_files = glob.glob(os.path.join(directory, "app_*.arb"))

    new_keys = {
        "errorPleaseEnterAmountFor": "Please enter amount for {activityName}",
        "@errorPleaseEnterAmountFor": {
            "placeholders": {
                "activityName": {
                    "type": "String"
                }
            }
        },
        "errorNameOrTypeRequiredFor": "Name or Type required for {activityName}",
        "@errorNameOrTypeRequiredFor": {
            "placeholders": {
                "activityName": {
                    "type": "String"
                }
            }
        }
    }

    for file_path in arb_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            modified = False
            for key, value in new_keys.items():
                if key not in data:
                    data[key] = value
                    modified = True
            
            if modified:
                with open(file_path, 'w', encoding='utf-8') as f:
                    json.dump(data, f, indent=4, ensure_ascii=False)
                print(f"Updated {os.path.basename(file_path)}")
            else:
                print(f"No changes needed for {os.path.basename(file_path)}")
                
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

if __name__ == "__main__":
    add_keys()
