/* Public defines ------------------------------------------------------------*/
#define NULL (void *)0

#define ADD_SYSCALL_NUMBER 4
#define MAX_SYSCALL 10

#define SVC_AARCH64 0b010101

#define GET_EC_BITS(reg) (((reg >> 26) << 32) >> 32)

/* Public types --------------------------------------------------------------*/
typedef unsigned long u64;
typedef struct __attribute__((aligned(1)))
{
    u64 spsr;
    u64 x0;
    u64 x1;
    u64 x2;
    u64 x3;
    u64 x4;
    u64 x5;
    u64 x6;
    u64 x7;
    u64 x8;
    u64 x9;
    u64 x10;
    u64 x11;
    u64 x12;
    u64 x13;
    u64 x14;
    u64 x15;
    u64 x16;
    u64 x17;
    u64 x18;
    u64 x19;
    u64 x20;
    u64 x21;
    u64 x22;
    u64 x23;
    u64 x24;
    u64 x25;
    u64 x26;
    u64 x27;
    u64 x28;
    u64 x29;
    u64 x30;
} trap_frame_t;

typedef void (*syscall)(trap_frame_t *trap_frame);

/* Public function prototypes ------------------------------------------------*/
void add_syscall_handler(trap_frame_t *trap_frame);

void svc_handler(trap_frame_t *trap_frame);

void print_uart0(const char *s);

void el1_sync_handler(trap_frame_t *trap_frame, u64 esr_el1);

void el0_main();

/* Public variables ----------------------------------------------------------*/
const syscall syscalls[MAX_SYSCALL] = {
    [ADD_SYSCALL_NUMBER] = add_syscall_handler};

volatile unsigned int *const UART0DR = (unsigned int *)0x09000000;

/* Public functions ----------------------------------------------------------*/
void print_uart0(const char *s)
{
    while (*s != '\0')
    {
        *UART0DR = (unsigned int)(*s);
        s++;
    }
}

void el1_sync_handler(trap_frame_t *trap_frame, u64 esr_el1)
{
    /* 1. Parse the Exception Class bits[31:26] in ESR_EL1. */
    if (GET_EC_BITS(esr_el1) == SVC_AARCH64)
    {
        svc_handler(trap_frame);
    }
    else
    { // Not implemented yet.
    }
}

void svc_handler(trap_frame_t *trap_frame)
{
    /* 1. Validate system call number. */
    if (trap_frame->x8 >= MAX_SYSCALL || syscalls[trap_frame->x8] == NULL)
    {
        print_uart0("Invalid syscall number!\n");
        return;
    }

    /* 2. Call corresponding system call. */
    syscalls[trap_frame->x8](trap_frame);
}

void add_syscall_handler(trap_frame_t *trap_frame)
{ // This syscall add two parameters and return the result.
    trap_frame->x0 = trap_frame->x0 + trap_frame->x1;
}

void el0_main()
{
    u64 result = 0;
    print_uart0("Enter el0_main!\n");

    /* 1. Request the syscall. */
    asm("mov x0, #1;" /* x0 -- holds the first parameter.   */
        "mov x1, #2;" /* x1 -- holds the second parameter.  */
        "mov x8, #4;" /* x8 -- holds the syscall number.    */
        "svc #0");

    /* 2. Get the syscall result. */
    asm("mov x0,%0" : "=r"(result));
    if (result != 3)
    {
        print_uart0("System call return a incorrect result.\n");
    }
    else
    {
        print_uart0("System call return a correct result.\n");
    }

    print_uart0("Exit el0_main!\n");
}
