
NVCC    = nvcc
OBJ     = main.o kernel.o
DEPS    = grav.h timer.h
EXE     = grav


default: $(EXE)

%.o: %.cu
	$(NVCC) -c -o $@ $<

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE)

clean:
	rm -rf $(OBJ) $(EXE)

