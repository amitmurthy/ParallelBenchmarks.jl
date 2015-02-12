np = nprocs()
testns = shuffle(2.^[0:26])
ltns = length(testns)
tMean = Float64[]
tStd = Float64[]
tMin = Float64[]

for j = 1:100
    [@elapsed remotecall_fetch(i, randn, 2) for i in workers()]
end

for n in testns
    a = randn(n)
    tmp = [@elapsed remotecall_fetch(i, x->x, a) for i in workers(), j = 1:20]
    push!(tMean, mean(tmp))
    push!(tStd, std(tmp))
    push!(tMin, minimum(tmp))
end

writedlm("spawnmuck.txt", hcat(fill("@spawn", length(testns)), testns, tMean, tStd, tMin))

function serialize_rcv(io, args...)
    # twice to simulate both legs
    for i in 1:2
        for arg in args
            serialize(io, arg)
        end
        for arg in args
            deserialize(io)
        end
    end
end

tMean = Float64[]
tStd = Float64[]
tMin = Float64[]

serialize_rcv(Base.PipeBuffer(), :call_fetch, Base.next_id(), x->x, randn(2))

for n in testns
    a = randn(n)
    io = Base.PipeBuffer()
    tmp = [@elapsed serialize_rcv(io, :call_fetch, Base.next_id(), x->x, a) for i in workers(), j = 1:20]
    push!(tMean, mean(tmp))
    push!(tStd, std(tmp))
    push!(tMin, minimum(tmp))
end

writedlm("sermuck.txt", hcat(fill("serdeser", length(testns)), testns, tMean, tStd, tMin))

