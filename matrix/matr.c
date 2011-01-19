#include <stdio.h>
#include <time.h>

#define  MAX_SIZE_Y 5000        
#define  MAX_SIZE_X 100

int main()
{   
    FILE   *fout;
    fout = fopen("result.txt","w");
    if(!fout)
    {   printf("Error");
        return 1;
    }
   
    
    int a[MAX_SIZE_Y][MAX_SIZE_X], i,j,k, s = 0, fl = 1, cache = 0;
    int x = MAX_SIZE_X, y = MAX_SIZE_Y, k_max = 100,  d1,d2;
    
    for(i = 0; i < y; i++)  
        for(j = 0; j < x; j++ )
              a[i][j] = 0;  

    do{
    time_t t1 = clock();
  
    for(k = 0; k < k_max;k++)
        for(i = 0; i < y; i++)  
             for(j = 0; j < x; j++ )
                s += a[i][j];  
    time_t t2 = clock();
    
    
  
    for(k = 0; k < k_max; k++)
        for(i = 0; i < y; i++)  
            for(j = 0; j < x; j++ )
                s += a[j][i];  
    time_t t3 = clock();
    
    d1 = (int)t2-t1 ;
    d2 = (int)t3-t2;
    
    printf("Row-time: %d\nColomn-time: %d\nx = %d y = %d\n", (int)t2-t1,(int)t3-t2,x,y);
    fprintf(fout, "Row-time: %d\nColomn-time: %d\nx = %d y = %d\n", (int)t2-t1,(int)t3-t2,x,y);
    
    if(d2-d1 < 10)
    {        fl = 0;
             cache = x*y*4;
    }
    
    x -= 10;
     
   } while(x > 10 && fl);
     system ("pause");
    
    if(cache)
        fprintf(fout, "Cache priblisitelno raven %d\n", cache) ;
    else
        fprintf(fout, "Cache horosho opredelit ne udalos. Poprobuyte drugie parametri matrici.\n");
    close(fout);
    return 0;          
}
