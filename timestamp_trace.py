#!/usr/bin/python3

import datetime
import subprocess

import os

cmd = f"""colcon build --event-handlers console_direct+ --executor sequential --packages-select sensor_msgs --cmake-args ' -DCMAKE_TOOLCHAIN_FILE={os.path.dirname(__file__)}/profile.toolchain.cmake'"""

first_time = datetime.datetime.now()
last_time = first_time

timed_lines = []

proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
for line in proc.stdout:
    current_time = datetime.datetime.now()
    delta = current_time - last_time
    last_time = current_time
    l = line.decode().rstrip()
    timed_lines.append((delta, l))
    print(f'{delta.microseconds:6}', l)


total_duration = last_time - first_time

print(f"Sorting and ranking {len(timed_lines)} outputs")
sorted_times = sorted([d for d, _ in timed_lines], reverse=True)
results = [(sorted_times.index(d), d, l) for d, l in timed_lines]

for r, d, l in results:
    percent = d/total_duration*100
    print(f"r={r:4} {'highest' if r < len(timed_lines) / 10  else '       '}  {percent:.2f}% dt ={d.microseconds / 1000000.0:06f}s", l)

    
