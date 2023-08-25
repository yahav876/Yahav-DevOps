total_bytes = 0

# Read the text file
with open('yahav.txt', 'r') as file:
    for line in file:
        parts = line.split(', ')
        bytes_sent = int(parts[0].split(': ')[1])
        count = int(parts[1].split(': ')[1])
        total_bytes += bytes_sent * count

print("Total Bytes Sent:", total_bytes)