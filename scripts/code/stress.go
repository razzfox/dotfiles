package main
import(."runtime"
f"flag"
."strconv"
."time")
func main(){f.Parse()
c:=NumCPU()*2
t,_:=Atoi(f.Arg(0))
GOMAXPROCS(c)
for;c>0;c--{go(func(){for{Now()}})()}
<-After(Duration(t)*1e9)}
