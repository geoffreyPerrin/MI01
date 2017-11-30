; programme.asm
;
; MI01 - TP Assembleur 1
;
; Affiche un caract�re � l'�cran

title       programme.asm

.686
.model      flat, c

extern      putchar:near
extern      getchar:near

.data

cara        db  'A'

.code


; Sous-programme main, automatiquement appel� par le code de
; d�marrage 'C'
public      main
main        proc

            ; Conversion du caract�re en un double mot
            movzx   eax, byte ptr[cara]

            ; Appel � la fonction de biblioth�que �C� putchar(int c) 
            ; pour afficher un caract�re. La taille du type C 'int' 
            ; est de 32 bits sur IA-32. Le caract�re doit �tre fourni
            ; sur la pile.
            push    eax         ; Caract�re � afficher
            call    putchar     ; Appel de putchar
            add     esp, 4      ; Nettoyage de la pile apr�s appel
            ; Fin de l'appel � putchar

            call    getchar     ; Attente de l'appui sur "Entr�e"

            ret                 ; Retour au code de d�marrage 'C'

main        endp

            end