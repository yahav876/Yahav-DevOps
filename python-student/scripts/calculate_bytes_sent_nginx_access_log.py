import json

# Initialize a dictionary to store the count of body_bytes_sent values
byte_counts = {}

# Initialize a variable to keep track of the total bytes sent
total_bytes_sent = 0

# Read the access log file
with open('layoutapi.access.json.log-20230815-1692071341', 'r') as log_file:
    for line in log_file:
        try:
            log_entry = json.loads(line.strip())
            access_time = log_entry.get('accesstime', '')
            body_bytes_sent = log_entry.get('body_bytes_sent')

            if '15/Aug/2023' in access_time and body_bytes_sent:
                # Convert body_bytes_sent to an integer
                bytes_sent = int(body_bytes_sent)

                # Update the count for each body_bytes_sent value
                byte_counts[bytes_sent] = byte_counts.get(bytes_sent, 0) + 1

                # Update the total bytes_sent
                total_bytes_sent += bytes_sent * byte_counts[bytes_sent]
        except ValueError:
            pass  # Ignore lines that are not valid JSON

# Print the count of body_bytes_sent values
for size, count in byte_counts.items():
    print('Bytes Sent: %d, Count: %d' % (size, count))

# Print the total bytes_sent
print('Total Bytes Sent:', total_bytes_sent)
