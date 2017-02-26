#25
#53

# Receiver:
for i in $(seq 100); do sudo nc -l $i & done
# Sender:
for i in $(seq 100); do echo $i | nc -w1 73.24.248.58 $i; done
