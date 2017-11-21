; hello2.asm
;
; MI01 - TP Assembleur 1
;
; Affiche une cha�ne de caract�res � l'�cran

title hello2.asm

.686
.model      flat, c

extern      putchar:near
extern      getchar:near

.data

msg db "bonjour tout le monde", 0
; Ajoutez les variables msg et longueur ici

.code

; Sous-programme main, automatiquement appel� par le code de
; d�marrage 'C'
public      main
main        proc

            push    ebx             ; Sauvegarde pour le code 'C'

            mov     ebx, 0

            ; On suppose que la longueur de la cha�ne est non nulle
            ; => pas de test de la condition d'arr�t au d�part
suivant:    movzx   eax, byte ptr[ebx + msg]

            ; Appel � la fonction de biblioth�que �C� putchar(int c) 
            ; pour afficher un caract�re. La taille du type C 'int' 
            ; est de 32 bits sur IA-32. Le caract�re doit �tre fourni
            ; sur la pile.
            push    eax         ; Caract�re � afficher
            call    putchar     ; Appel de putchar
            add     esp, 4      ; Nettoyage de la pile apr�s appel
            ; Fin de l'appel � putchar

            inc     ebx             ; Caract�re suivant
            cmp     eax, 0 ; Toute la longueur ?
            jne     suivant         ; si non, passer au suivant

            call    getchar         ; Attente de l'appui sur "Entr�e"
            pop     ebx

            ret                     ; Retour au code de d�marrage 'C'

main        endp

            end