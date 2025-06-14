alist<-seq(100)
blist<-alist
blist[alist%%3==0]<-"Fizz"
blist[alist%%5==0]<-"Buzz"
blist[alist%%15==0]<-"FizzBuzz"
print(blist)
