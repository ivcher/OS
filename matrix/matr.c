#include <stdio.h>
#include <time.h>

#define  MAX_SIZE_Y 1000        
#define  MAX_SIZE_X 100

int main()
{   
    int a[MAX_SIZE_Y][MAX_SIZE_X], i,j,k, s = 0;
    int x = MAX_SIZE_X, y = MAX_SIZE_Y, k_max = 500;


    for(i = 0; i < y; i++)  
        for(j = 0; j < x; j++ )
              a[i][j] = 0;  
    
    time_t t1 = clock();
  
    for(k = 0; k < k_max;k++)
        for(i = 0; i < y; i++)  
             for(j = 0; j < x; j++ )
                s += a[i][j];  
    time_t t2 = clock();
  
    for(k = 0; k < k_max;k++)
        for(i = 0; i < y; i++)  
            for(j = 0; j < x; j++ )
                s += a[j][i];  
    time_t t3 = clock();
    
    printf("Row-time: %d\nColomn-time: %d\n", (int)t2-t1,(int)t3-t2);
    
    system ("pause");
 
    FILE   *fout;
    fout = fopen("result.txt","w");
    if(!fout)
    {   printf("Error");
        return 1;
    }
    fprintf(fout, "Row-time: %d\nColomn-time: %d", (int)t2-t1,(int)t3-t2);
    close(fout);
    return 0;          
}
