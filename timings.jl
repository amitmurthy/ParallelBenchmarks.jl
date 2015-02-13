addprocs(1)

@everywhere echo(x)=x

ls = listen(11000)
client = connect("localhost", 11000)
server = accept(ls)
Base.wait_connected(client)

function timings(n)
    a=ones(10^n)
    io=IOBuffer()

    serialize(io, a); serialize(io, a); seekstart(io); deserialize(io); deserialize(io);
    serialize(io, (1,2)); serialize(io, (1,2)); seekstart(io); deserialize(io); deserialize(io);
    serialize(io, :some_sym); serialize(io, :some_sym); seekstart(io); deserialize(io); deserialize(io);
    serialize(io, echo); seekstart(io); deserialize(io);


    @time for i in 1:10^3; remotecall_fetch(2, echo, a); end
    @time for i in 1:10^3
        serialize(io, a); serialize(io, a); seekstart(io); deserialize(io); deserialize(io);
        serialize(io, (1,2)); serialize(io, (1,2)); seekstart(io); deserialize(io); deserialize(io);
        serialize(io, :some_sym); serialize(io, :some_sym); seekstart(io); deserialize(io); deserialize(io);
        serialize(io, echo); seekstart(io); deserialize(io);
    end

    @time for i in 1:10^3; remotecall_fetch(2, echo, a); end
    @time for i in 1:10^3
        serialize(io, a);
        serialize(io, (1,2));
        serialize(io, :some_sym);
        serialize(io, echo);

        write(client, takebuf_array(io));

        deserialize(server);
        deserialize(server);
        deserialize(server);
        deserialize(server);

        serialize(io, a);
        serialize(io, (1,2));
        serialize(io, :some_sym);

        write(server, takebuf_array(io));

        deserialize(client);
        deserialize(client);
        deserialize(client);
    end
end

timings(1)

timings(2)

timings(3)


