import json
import subprocess
import ollama

SYSTEM_PROMPT = """
You are LabGPT.

Return JSON only.

Do not use markdown.
Do not use ```json.
Do not explain anything.

Schema:

{
  "LabName": "",
  "Domain": "",
  "Machines": [
    {
      "Name": "",
      "Role": "",
      "Template": "",
      "Memory": 4,
      "IP": ""
    }
  ]
}

Rules:

DC:
- Template = WIN2022.vhdx
- Memory = 4

CLIENT:
- Template = WIN11.vhdx
- Memory = 4

APP:
- Template = WIN2022.vhdx
- Memory = 4

Naming Convention:

DC01
CLIENT01
CLIENT02
CLIENT03
APP01
APP02
APP03

DC IP:
192.168.100.10

Clients:
192.168.100.20+
"""

prompt = input("LabGPT> ")

response = ollama.chat(
    model="qwen2.5-coder",
    messages=[
        {
            "role": "system",
            "content": SYSTEM_PROMPT
        },
        {
            "role": "user",
            "content": prompt
        }
    ]
)

json_text = response["message"]["content"]

# Clean markdown fences
json_text = json_text.replace("```json", "")
json_text = json_text.replace("```", "")
json_text = json_text.strip()

try:

    plan = json.loads(json_text)

    required = ["LabName", "Domain", "Machines"]

    for field in required:
        if field not in plan:
            raise Exception(
                f"Missing required field: {field}"
            )

    json_path = r"C:\LabGPT\Config\AI-LAB.json"

    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(plan, f, indent=4)

    print("\n=== Deployment Plan ===\n")
    print(json.dumps(plan, indent=4))

    print(f"\n✅ Plan saved: {json_path}")

except json.JSONDecodeError as e:

    print("\n❌ Invalid JSON returned by AI")
    print(e)
    exit()

except Exception as e:

    print(f"\n❌ Validation Error: {e}")
    exit()

if subprocess.run == "y":

    print("\n🚀 Starting Lab Deployment...\n")

    subprocess.run(
        [
            "powershell",
            "-ExecutionPolicy",
            "Bypass",
            "-File",
            r"C:\LabGPT\Scripts\Deploy-Lab.ps1",
            "-ConfigFile",
            json_path
        ]
    )

else:

    print("\nDeployment cancelled.")