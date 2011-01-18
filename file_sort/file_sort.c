#include <stdio.h>
#include <stdlib.h>
#define MAX_SIZE   40000


int compare(const void* , const void*);

int main (int argc, char** argv)
{
    printf("123\n %d \n124",argc);

    int err,count = 0;
    int a[MAX_SIZE];

    FILE *fin, *fout;
    if(argc < 2 )
    {  
        return 1;
    }

    int i;
    for(i = 1; i < argc-1; i++)
    {    fin = fopen(argv[i],"r");
         if(!fin)
         {
             return 1; //error - not file
         }                
         while(!feof(fin))
         {   err = fscanf(fin,"%d",&a[count]);
             if(!err)
             {   close(fin);
                 return 1;         
             }
             count ++;
             if (count > MAX_SIZE)
             {    close(fin);
                  return 1;
             }             
         }
         fclose(fin);         
    }   
    qsort(a,count,sizeof(int),compare);
    fout = fopen(argv[argc-1],"w");
    if(!fout)
    {   return 1;
    }
    for(i = 0; i<count; i++)
    {   err = fprintf (fout,"%d\n",a[i]);
        if(!err)
        {   close(fout);
            return 1;
        }
    }
    
    
    close(fout);
    return 0;
}
int compare(const void *a, const void *b)
{   return ( *(int*)a - *(int*)b );
}
