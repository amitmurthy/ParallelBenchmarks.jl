using PyPlot

mpi=readdlm("MPImuck2.txt")
julia=readdlm("spawnmuck.txt")

mpi_serialize=mpi[(mpi[:,1].=="MPI_serialize"), :]
mpi_no_serialize=mpi[(mpi[:,1].=="MPI_no_serialize"), :]
julia_rcf=julia[sortperm(julia[:,2]), :]

plot(map(log10, mpi_serialize[:,2]), map(log10, mpi_serialize[:,3]), color="red", label="mpi_serialize", linewidth=2.0)
plot(map(log10, mpi_no_serialize[:,2]), map(log10, mpi_no_serialize[:,3]), color="green", label="mpi_no_serialize", linewidth=2.0)
plot(map(log10, julia_rcf[:,2]), map(log10, julia_rcf[:,3]), color="black", label="remotecall_fetch", linewidth=2.0)

legend(loc="upper left")

