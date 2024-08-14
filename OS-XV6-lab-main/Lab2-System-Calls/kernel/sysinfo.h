struct sysinfo {
  uint64 freemem;   // amount of free memory (bytes)
  uint64 nproc;     // number of process
};
uint64 get_nproc();
uint64 get_freemem(void);

