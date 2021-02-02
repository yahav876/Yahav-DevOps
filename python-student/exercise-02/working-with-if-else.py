#!/bin/python3  

# Exercise: Working with If/Else

users = [
    {'admin': True, 'active': True, 'name': 'yahav'},
    {'admin': True, 'active': True, 'name': 'shlomi'},
    {'admin': True, 'active': True, 'name': 'hen'},
    {'admin': True, 'active': True, 'name': 'dor'},
    ]

line = 1

for user in users:
    prefix = f"{line} "

    if user['admin'] and user['active']:
        prefix += "Active - (ADMIN)"
    print(prefix + user['name'])