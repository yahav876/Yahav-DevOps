#!/bin/python3

#import time

# To use time function without using the time word before calling the method.
from time import localtime, mktime, strftime


start_time = localtime()
print(f"Timer Starts at {strftime('%X',start_time)}")

# Wait for user to stop timer
input("Press 'Enter' to stop the timer")

stop_time = localtime()
difference = mktime(stop_time) - mktime(start_time)


print(f"Timer Stopped at {strftime('%X',stop_time)}")
print(f"Total time: {difference} seconds.")
