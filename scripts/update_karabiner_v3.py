import json
import os

karabiner_path = os.path.expanduser("~/.dotfiles/config/karabiner/karabiner.json")

# Rule 1: Caps Lock -> Ctrl (Hold) / Esc (Tap)
caps_rule = {
    "description": "Caps Lock -> Ctrl (Hold) / Esc (Tap)",
    "manipulators": [
        {
            "from": {"key_code": "caps_lock", "modifiers": {"optional": ["any"]}},
            "to": [{"key_code": "left_control"}],
            "to_if_alone": [{"key_code": "escape"}],
            "type": "basic"
        }
    ]
}

# Rule 2: Left Control -> Hyper (Cmd + Alt + Ctrl)
# We explicitly do NOT map Shift, so the user can physically press Shift + Left Control
# and the result will be Cmd + Alt + Ctrl + Shift.
hyper_rule = {
    "description": "Left Control -> Hyper (Cmd + Alt + Ctrl)",
    "manipulators": [
        {
            "from": {"key_code": "left_control", "modifiers": {"optional": ["any"]}},
            "to": [
                {
                    "key_code": "left_command",
                    "modifiers": ["left_option", "left_control"]
                }
            ],
            "type": "basic"
        }
    ]
}

new_rules = [caps_rule, hyper_rule]

# --- Load and Update JSON ---
try:
    with open(karabiner_path, 'r') as f:
        data = json.load(f)
    
    # Update the first profile's rules
    if data['profiles']:
        data['profiles'][0]['complex_modifications']['rules'] = new_rules
        print("Updated rules in profile 0.")
    else:
        print("No profiles found!")
        exit(1)

    with open(karabiner_path, 'w') as f:
        json.dump(data, f, indent=4)
        print("Successfully wrote karabiner.json")

except Exception as e:
    print(f"Error: {e}")
