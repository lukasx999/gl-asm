section .text

global main
main:
push rbp
mov rbp, rsp


mov rax, 1
mov rdi, 1
mov rsi, vert_text
mov rdx, vert_len
syscall


mov rax, 0
mov rsp, rbp
pop rbp
ret

section .data
txt:
db "Hello, World!", "foo", 10
len:
db $-txt

vert_text:
db "#version 330", 10, "in vec2 vPos;", 10, "void main() { gl_Position = vec4(vPos, 0.0, 1.0); }", 10

vert_len:
dq $-vert_text

frag_text:
db "#version 330", 10, "out vec4 fragment;", 10, "void main() { fragment = vec4(1.0, 1.0, 1.0, 1.0); }", 10

frag_len:
dq $-vert_text
