volatile unsigned int *const UART0DR = (unsigned int *)0x09000000;

void print_uart0(const char *s)
{
    while (*s != '\0')
    {                                  /* Loop until end of string */
        *UART0DR = (unsigned int)(*s); /* Transmit char */
        s++;                           /* Next char */
    }
}

int x = 0;

void __attribute__((naked)) svc_handler_c()
{
    
}

void main()
{
    long result;
   // asm volatile("mov %0, x1" : "=r"(result)::);
    print_uart0("hello\n");
    if (result == 0)
    {
        print_uart0("0\n");
    }
    else if (result & 0b0100)
    {
        print_uart0("1\n");
    }
    else if (result & 0b1000)
    {
        print_uart0("2\n");
    }
    else if (result & 0b1100)
    {
        print_uart0("3\n");
    }

    // if (x == 1)
    // {
    // print_uart0("Hello word\n");

    // }
    

}
