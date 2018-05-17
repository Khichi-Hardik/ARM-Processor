    .text

    bl branch
branch: 
    add r1, r1, #1
    mov pc, lr

    .end