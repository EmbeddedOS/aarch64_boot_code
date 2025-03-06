volatile unsigned int *const UART0DR = (unsigned int *)0x09000000;

void print_uart0(const char *s)
{
    while (*s != '\0')
    {
        *UART0DR = (unsigned int)(*s); 
        s++;
    }
}

void el0_main()
{
    print_uart0("Enter el0_main!\n");

    asm("svc #0");

    print_uart0("Exit el0_main!\n");
}
