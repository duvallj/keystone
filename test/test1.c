/* test1.c */
#include <stdio.h>
#include <keystone/keystone.h>

// separate assembly instructions by ; or \n
char *CODE = "sub eax, lol\n";

int main(int argc, char **argv)
{
  ks_engine *ks;
  ks_err err;
  size_t count;
  ks_instruction (*kptrs)[] = NULL;

  err = ks_open(KS_ARCH_X86, KS_MODE_64, &ks);
  if (err != KS_ERR_OK) {
      printf("ERROR: failed on ks_open(), quit\n");
      return -1;
  }

  if (ks_asm_new(ks, CODE, 0, &count, &kptrs) != KS_ERR_OK) {
      printf("ERROR: ks_asm() failed & count = %lu, error = %u\n",
             count, ks_errno(ks));
  } else {
      size_t i;

      printf("%s = \n", CODE);

      for (i = 0; i < count; i++) {
        for(int y = 0; y < (*kptrs)[i].size; ++y)
            printf("%02x ", (*kptrs)[i].instruction[y]);
          puts("");
      }
  }

  // NOTE: free encode after usage to avoid leaking memory

  ks_free_new(kptrs, count);

  // close Keystone instance when done
  ks_close(ks);

  return 0;
}
