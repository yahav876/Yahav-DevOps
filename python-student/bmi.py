#!/usr/bin/python3

# BMI = (weight in kg / height in meters squared)

def gather_info():
    height = float(input("What is your height? (inches or meters) "))
    weight = float(input("What is your weight? (kg or pounds) "))
    system = input("Are your measurements in metric or imperial units? ").lower().strip()
    return (height, weight, system)

def calculate_bmi(height, weight, system='metric'):
    """
    Return the body mass index (BMI) for the given weight and height.
    """
    if system == 'metric':
        bmi = (weight / (height ** 2))
    else:
        bmi = 703 * (weight / (height ** 2))
    return bmi

while True:
    height, weight, system = gather_info()
    if system.startswith('i'):
        bmi = calculate_bmi(height, weight, system)
        print(f"Your BMI is: {bmi}")
        break
    elif system.startswith('m'):
        bmi = calculate_bmi(height, weight, system)
        print(f"You bmi is: {bmi}")
        break
    else:
        print("Error , Unknown measurement")
        break
