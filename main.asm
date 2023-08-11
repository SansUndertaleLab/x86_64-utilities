section .data
    msg db "Input > ", 0

section .text
    global _start

_start:
    xor rax, rax
    xor rdi, rdi
    xor rsi, rsi
    xor rdx, rdx
    
    call main
    
    mov rdi, 0
    call exit
    
exit:
    mov rax, 60
    syscall

strlen:
    push rbp
    mov rbp, rsp
    sub rsp, 12

    mov qword [rbp - 8], rdi
    mov dword [rbp - 12], 0
    
    xor r8, r8
.body:
    inc dword [rbp - 12]
    inc r8
    mov rdi, qword [rbp - 8]
    movzx rax, byte [rdi + r8]
    cmp rax, 0
    jne .body
    
    mov eax, dword [rbp - 12]
    
    mov rsp, rbp
    pop rbp
    ret

print:
    push rbp
    mov rbp, rsp
    sub rsp, 12
    
    mov qword [rbp - 8], rdi
    call strlen

    mov dword [rbp - 12], eax
    
    mov rax, 1
    mov rdi, 1
    mov rsi, qword [rbp - 8]
    xor edx, edx
    mov edx, dword [rbp - 12]
    syscall

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret
    
print_int:
    push rbp
    mov rbp, rsp
    sub rsp, 12
    
    mov dword [rbp - 4], edi
    mov dword [rbp - 8], 0
    mov dword [rbp - 12], 0
    
.LC0:
    xor rdx, rdx
    xor rax, rax
    
    mov eax, dword [rbp - 4]
    mov esi, 10
    div esi
    
    mov dword [rbp - 4], eax
    mov dword [rbp - 8], edx
    
    xor rdi, rdi
    mov edi, dword [rbp - 8]
    add edi, 48
    push rdi
    
    inc dword [rbp - 12]
    
    mov eax, dword [rbp - 4]
    cmp eax, 0
    jg .LC0

.LC1:
    pop rdi
    
    call putchar
    
    dec dword [rbp - 12]
    mov eax, dword [rbp - 12]
    cmp eax, 0
    jne .LC1
    
    mov rsp, rbp
    pop rbp
    ret
    
putchar:
    push rbp
    mov rbp, rsp
    sub rsp, 4
    
    mov dword [rbp - 4], edi
    mov rax, 1
    mov rdi, 1
    lea rsi, dword [rbp - 4]
    mov edx, 1
    syscall
    
    mov rsp, rbp
    pop rbp
    ret

input:
    push rbp
    mov rbp, rsp
    sub rsp, 24

    mov qword [rbp - 8], rdi
    mov qword [rbp - 16], rsi
    mov qword [rbp - 24], 0

    mov rax, 0
    mov rdi, 0
    mov rsi, qword [rbp - 8]
    mov rdx, qword [rbp - 16]
    dec rdx
    syscall

    mov qword [rbp - 24], rax

    mov rax, qword [rbp - 8]
    mov rdi, qword [rbp - 24]
    mov byte [rax + rdi - 1], 0

    xor rax, rax 

    mov rsp, rbp
    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 100
    
    mov rdi, msg
    call print

    lea rdi, byte [rbp - 100]
    mov rsi, 100
    call input

    lea rdi, byte [rbp - 100]
    call print

    mov rdi, 10
    call putchar
    
    mov rsp, rbp
    pop rbp
    ret