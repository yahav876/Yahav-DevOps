import os
import jwt
import requests
import json
from time import time
from dotenv import load_dotenv

load_dotenv()

# Enter your API key and your API secret
API_KEY = os.getenv("API_KEY")
API_SEC = os.getenv("API_SEC")

BS_HOST = os.getenv("BS_HOST")
DIG_HOST = os.getenv("DIG_HOST")
HR_HOST = os.getenv("HR_HOST")
IN_HOST = os.getenv("IN_HOST")
SU_HOST = os.getenv("SU_HOST")


# create a function to generate a token
# using the pyjwt library
def generateToken():
  token = jwt.encode(
    # Create a payload of the token containing
    # API Key & expiration time
    {
      'iss': API_KEY,
      'exp': time() + 5000
    },

    # Secret used to generate token signature
    API_SEC,

    # Specify the hashing alg
    algorithm='HS256')
  return token


# create json data for post requests
meetingdetails = {
  "topic": "Meeting was auto generated in ",
  "type": 2,
  "start_time": "2019-06-14T10: 21: 57",
  "duration": "400",
  "timezone": "Europe/Madrid",
  "agenda": "test",
  "recurrence": {
    "type": 1,
    "repeat_interval": 1
  },
  "settings": {
    "host_video": "true",
    "participant_video": "true",
    "join_before_host": "true",
    "jbh_time": 0,
    "mute_upon_entry": "False",
    "watermark": "true",
    "audio": "voip",
    "auto_recording": "cloud",
    "waiting_room": "False"
  }
}

# send a request with headers including
# a token and meeting details


def createMeeting(user_id, host_key):
  headers = {
    'authorization': 'Bearer ' + generateToken(),
    'content-type': 'application/json'
  }
  r = requests.post(f'https://api.zoom.us/v2/users/{user_id}/meetings',
                    headers=headers,
                    data=json.dumps(meetingdetails))

  #print("\n creating zoom meeting ... \n")
  # print(r.text)
  # converting the output into json and extracting the details
  y = json.loads(r.text)
  join_URL = y["join_url"]
  #meetingPassword = y["password"]
#   with open("output.txt", "w") as f:
#     f.write("\n here is your zoom meeting link " + join_URL +
#             " and your \ Host Key: " + str(host_key))
  print(
    f'{join_URL},{host_key},{user_id}'
  )


def getMeetings():
  headers = {
    'authorization': 'Bearer ' + generateToken(),
    'content-type': 'application/json'
  }
  r = requests.get(f'https://api.zoom.us/v2/metrics/meetings?type=live',
                   headers=headers)
  response = json.loads(r.text)
  meetings_array = response["meetings"]
  return meetings_array


mit = getMeetings()
my_dict = {
  "bensiboni10@gmail.com": [0, BS_HOST],
  "support@ecomschool.co.il": [0, SU_HOST],
  "inna@ecomschool.co.il": [0, IN_HOST],
  "digital@ecomschool.co.il": [0, DIG_HOST],
  "HR@ecomschool.co.il": [0, HR_HOST],
  "simon@ecomschool.co.il": [0, "HostKey"],
  "emil@ecomschool.co.il": [0, "HostKey"],
  "cofounder@ecomschool.co.il": [0, "HostKey"]
}

for i in range(len(mit)):
  my_dict[mit[i]["email"]][0] += 1

for key in my_dict:
  if my_dict[key][0] < 2:
    if my_dict[key][1] != "HostKey":
      createMeeting(key, my_dict[key][1])
      break

# for key in my_dict:
#   print(key)
#   print(my_dict[key])
