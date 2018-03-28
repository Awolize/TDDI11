#include <libepc.h>

int main(int argc, char *argv[])
{
   ClearScreen(0x07);
   SetCursorPosition(0, 0);
   
   PutString("     Name            LIU-ID        DATE");
   SetCursorPosition(1, 0);
   PutString("  Kristoffer        krika694      20-3-28");
   SetCursorPosition(2, 0);
   PutString("  Alexander         aleer778      20-3-28");
   return 0;
}
