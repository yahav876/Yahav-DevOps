import os 
import glob
import json
import shutil


try:
    os.mkdir('./proccess')
except OSError:
    print("'proccess' directory already exists")

receipts = glob.glob('./receipts/receipts-[0-9]*.json')
subtotal = 0.0 

for path in receipts:
    with open(path) as f:
        content = json.load(f)
        subtotal += float(content['value'])
    name = path.split("/")[-1]
    destination = f"./proccess/{name}"
    shutil.move(path, destination)
    print(f"Moved from '{path}' to '{destination}'")

print("Receipt subtotal: $%.2f" % subtotal)