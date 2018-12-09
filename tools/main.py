import time

def main():
  print("START")
  stop = time.monotonic() + 1000
  while True:
    if time.monotonic() > stop:
      print("STOP")
      break

main()