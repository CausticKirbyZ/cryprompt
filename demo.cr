

bs = "hello world"
ln = "hel" 

ind = bs.index(ln)
if ind
  puts bs[(ind + ln.size)..]
end
