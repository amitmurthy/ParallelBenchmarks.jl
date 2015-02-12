function ser_timings(x)
    io=PipeBuffer()
    serialize(io, x)
    deserialize(io)

    @elapsed for n in 1:10^5
        serialize(io, x)
        deserialize(io)
    end
end

function all_timings()
    ser_timings(1)
    anon_func = x->x

    for t in (1, 1.0, "Hello", 'c', :a_symbol, x->x, anon_func, myid, (1,1), ones(1), ones(10), ones(1000), fill(1, 1), fill(1, 10), fill(1,1000))
        println(isa(t, Array) ? string(typeof(t),":", length(t)) : typeof(t), "   : ", ser_timings(t))
    end
end

all_timings()
