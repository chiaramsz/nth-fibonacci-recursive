# Ü 3.5 Chiara Szolderits

#Schreiben Sie eine MIPS-Assembler-Funktion, die die n-te Fibonacci-Zahl F(n) durch Rekursion berechnet (n ≥ 1 und ganzzahlig). 
#Die Fibonacci-Zahlen sind wie folgt definiert3:
#𝐹𝐹(1) = 𝐹𝐹(2) =1 
#𝐹𝐹(𝑛𝑛)=𝐹𝐹(𝑛𝑛−1)+𝐹𝐹(𝑛𝑛−2) für 𝑛𝑛>2

#Übernehmen Sie das Hauptprogramm aus Übungsaufgabe 3.2, um die ersten zehn Fibonacci- Zahlen (n = 1, 2, ..., 10) am 
#Bildschirm auszugeben.




.data
input:    .asciiz     "Enter n for fibonacci(n): "
output:   .asciiz     "fibonacci(n) is: "
enter:    .asciiz     "\n"


.text
main:
    # prompt user
    la      $a0, input
    li      $v0,4
    syscall

    # get number from user
    li      $v0,5
    syscall
    move    $a0,$v0
    bltz    $a0, exit

    jal     check_number
    move    $t2,$v0                 # save the result

    # print message
    la      $a0, output
    li      $v0,4
    syscall

    # print the result
    li      $v0,1
    move    $a0,$t2
    syscall

    # print message
    la      $a0, enter
    li      $v0,4
    syscall

    j       main

exit:
    li      $v0,10
    syscall

# fibo -- recursive fibonacci---------------------------------------------
#v0 = fionacci(n)
#a0: the "n" for the Nth fibonacci number

check_number:
    # fibo(0) is 0 and fibo(1) is 1 -- no need to establish a stack frame
    bgt     $a0,1,fibo        # n > 1 --> rekursion, else: fibo_full
    move    $v0,$a0                 #set return value
    jr      $ra                     # fast return



    # establish stack frame
    # we need an extra cell (to preserve the result of fibo(n-1))
fibo:
    # this gives us a temp word at 0($sp)
    addu    $sp,$sp,-12              # one more than we need
    sw      $ra,4($sp)
    sw      $a0,8($sp)

    addu   $a0,$a0,-1               # call for fibo(n-1)
    jal     check_number                   # recursive
    sw      $v0,0($sp)              # save result in our frame (in extra cell)

    addu    $a0,$a0,-1               # call for fibo(n-2)
    jal     check_number                   # recursive

    lw      $t0,0($sp)              # restore fibo(n-1) from our stack frame
    add     $v0,$t0,$v0             # result is: fibo(n-1) + fibo(n-2)


    # restore from stack frame
    lw      $ra,4($sp)
    lw      $a0,8($sp)
    addu    $sp,$sp,12

    jr      $ra                     # return
