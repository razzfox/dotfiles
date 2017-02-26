#echo {1..254}.{1..254}.{1..254}.0/255.255.255.0,

for i in {1..254}; do
  for j in {1..254}; do
    for k in {1..254}; do
      echo -n $i.$j.$k.0/255.255.255.0,
    done
  done
done
