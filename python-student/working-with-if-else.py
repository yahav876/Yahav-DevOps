#!/bin/python3  

# Exercise: Working with If/Else

user = {'admin': True, 'active': False, 'name': 'yahav'}

if user['admin'] and user['active']:
    prefix = "ACTIVE -(ADMIN)"
elif user['admin']:
    prefix = "(ADMIN)"
elif user['active']:
    prefix = "ACTIVE"

print(prefix + user['name']) 