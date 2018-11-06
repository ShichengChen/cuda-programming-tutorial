all:	cfd

cfd:	kernel.o main.o
	nvcc -arch=sm_61 kernel.o main.o -o cfd

main.o:	main.cu
	nvcc -arch=sm_61 -c main.cu -o main.o

kernel.o: kernel.cu
	nvcc -arch=sm_61 -c kernel.cu -o kernel.o

clean:
	rm -f *.o cfd	
