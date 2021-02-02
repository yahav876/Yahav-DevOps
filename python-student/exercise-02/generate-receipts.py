import random
import os
import json

count = int(os.getenv("FILE_COUNT") or 100)
words = [word.strip() for word in open("/usr/share/dict/american-english", "r").readlines()]
pathto = "/home/yahav/Yahav-Student/python-student/exercise-02/receipts"

for identifier in range(count):
    amount = random.uniform(1.0, 1000)
    content = {
        'topic': random.choice(words),
        'value': "%.2f" % amount
    }

    with open(f"/home/yahav/Yahav-Student/python-student/exercise-02/receipts/receipts-{identifier}.json", "w") as f:
        json.dump(content, f)