from datetime import datetime

result = datetime.strptime("Tue, 14 Jul 2020 22:05:12 GMT", "%a, %d %b %Y %H:%M:%S %Z")

print(result)