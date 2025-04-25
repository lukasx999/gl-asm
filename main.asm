extern puts
extern glfwInit
extern glfwTerminate
extern glfwCreateWindow
extern glfwMakeContextCurrent
extern gladLoadGL
extern glfwGetProcAddress
extern glfwSwapInterval
extern glGenBuffers
extern glBindBuffer
extern glBufferData
extern glGenVertexArrays
extern glBindVertexArray
extern glCreateShader
extern glShaderSource
extern glCompileShader
extern glAttachShader
extern glLinkProgram
extern glCreateProgram
extern glEnableVertexAttribArray
extern glVertexAttribPointer
extern glfwWindowHint
extern glfwWindowShouldClose
extern glClear
extern glUseProgram
extern glBindVertexArray
extern glDrawArrays
extern glfwSwapBuffers
extern glfwPollEvents
extern glfwDestroyWindow
extern glfwWindowHint
extern glfwSetErrorCallback
extern glfwGetFramebufferSize
extern glViewport

%define GL_ARRAY_BUFFER 0x8892
%define GL_STATIC_DRAW 0x88E4
%define GL_VERTEX_SHADER 0x8B31
%define GL_FRAGMENT_SHADER 0x8B30
%define GL_FLOAT 0x1406
%define GL_COLOR_BUFFER_BIT 0x00004000
%define GL_TRIANGLES 0x0004
%define GLFW_CONTEXT_VERSION_MAJOR 0x00022002
%define GLFW_OPENGL_PROFILE 0x00022008
%define GLFW_OPENGL_CORE_PROFILE 0x00032001
%define GLFW_CONTEXT_VERSION_MINOR 0x00022003
%define VPOS 0







section .text

error_callback:
push rbp
mov rbp, rsp

mov rdi, rsi
call puts

mov rsp, rbp
pop rbp
ret






global main
main:
push rbp
mov rbp, rsp



call glfwInit
cmp rax, 0
je .failure

lea rdi, error_callback
call glfwSetErrorCallback



mov edi, 640   ; width
mov esi, 480   ; height
mov rdx, title ; title
mov rcx, 0     ; ...
mov r8, 0      ; ...
call glfwCreateWindow
mov [window], rax
cmp rax, 0
je .failure



mov rdi, [window] ; window
call glfwMakeContextCurrent

lea rdi, glfwGetProcAddress ; load
call gladLoadGL

mov rdi, 1 ; interval
call glfwSwapInterval


mov rdi, 1 ; n
mov rsi, vbo ; buffers
call glGenBuffers

mov rdi, GL_ARRAY_BUFFER ; target
mov esi, [vbo] ; buffer
call glBindBuffer

mov rdi, GL_ARRAY_BUFFER ; target
mov rsi, [vertices_len]  ; size
mov rdx, vertices        ; data
mov rcx, GL_STATIC_DRAW  ; usage
call glBufferData



mov rdi, GL_VERTEX_SHADER
call glCreateShader
mov [shader_vert], eax

mov rdi, shader_vert
mov rsi, 1
mov rdx, vert_text
mov rcx, 0
call glShaderSource

mov rdi, shader_vert
call glCompileShader

mov rdi, GL_FRAGMENT_SHADER
call glCreateShader
mov [shader_frag], eax

mov rdi, shader_frag
mov rsi, 1
mov rdx, frag_text
mov rcx, 0
call glShaderSource

mov rdi, [shader_frag]
call glCompileShader

call glCreateProgram
mov [program], eax

mov rdi, [program]
mov rsi, [shader_vert]
call glAttachShader

mov rdi, [program]
mov rsi, [shader_frag]
call glAttachShader

mov rdi, [program]
call glLinkProgram




mov rdi, 1
mov rsi, vao
call glGenVertexArrays

mov edi, [vao]
call glBindVertexArray


mov edi, VPOS
call glEnableVertexAttribArray

mov edi, VPOS
mov rsi, 2
mov rdx, GL_FLOAT
mov rcx, 0
mov r8, 12
mov r9, 0
call glVertexAttribPointer



jmp .cond
.loop:


mov rdi, [window]
mov rsi, width
mov rdx, height
call glfwGetFramebufferSize

mov rdi, 0
mov rsi, 0
mov rdx, [width]
mov rcx, [height]
call glViewport



mov rdi, GL_COLOR_BUFFER_BIT
call glClear


mov rdi, [program]
call glUseProgram

mov rdi, [vao]
call glBindVertexArray

mov rdi, GL_TRIANGLES
mov rsi, 0
mov rdx, 3
call glDrawArrays

mov rdi, [window]
call glfwSwapBuffers

call glfwPollEvents


.cond:
mov rdi, [window]
call glfwWindowShouldClose
cmp rax, 0
je .loop


mov rdi, [window]
call glfwDestroyWindow


call glfwTerminate


mov rax, 0
jmp .end
.failure:
mov rax, 45
.end:

mov rsp, rbp
pop rbp
ret




section .bss

width       resd 1
height      resd 1
vbo         resd 1
vao         resd 1
shader_vert resd 1
shader_frag resd 1
program     resd 1
window      resq 1



section .data

vertices:
dd -0.5, -0.5, 0.0, ; left
dd 0.5, -0.5, 0.0,  ; right
dd 0.0,  0.5, 0.0   ; top

vertices_len:
dq $-vertices

title:
db "Hello OpenGL", 0

title_len:
dq $-title

vert_text:
db "#version 330", 10, "layout(location = 0) in vec2 vPos;", 10, "void main() { gl_Position = vec4(vPos, 0.0, 1.0); }", 10, 0

frag_text:
db "#version 330", 10, "out vec4 fragment;", 10, "void main() { fragment = vec4(1.0, 1.0, 1.0, 1.0); }", 10, 0
