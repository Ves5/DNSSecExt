import pandas as pd
from random import randint

names = []
basename = "example"
text2copy = ""
# 10k results
for i in range(10000):
    name = basename + str(i) + ".com"
    ip = "192.168." + str(randint(1, 254)) + "." + str(randint(1, 254))
    names.append(name)
    text2copy += f"    - domain: {name}\n      answer: {ip}\n"
with open('./server_data.txt', 'w') as f:
    f.write(text2copy)
dataframe = pd.DataFrame(names)
dataframe.to_csv("./self_hosted.csv", header=False)