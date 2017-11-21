; conversion.asm
;
; MI01 - TP Assembleur 1
;
; Affiche un nombre de 32 bits sous forme lisible

title conversion.asm

.686
.model 		flat, c

extern      putchar:near
extern      getchar:near

.data

nombre      dd      95c8ah          ; Nombre � convertir
chaine      db      10 dup(?)       ; Remplacer xx par la longueur maximale n de la cha�ne

.code

; Sous-programme main, automatiquement appel� par le code de
; d�marrage 'C'
public      main
main        proc

			push    ebx             ; Sauvegarde pour le code 'C'

			xor		ebx, ebx
			xor		eax, eax
			mov		ecx, 16
			mov		eax, [nombre]
suivant :	div		dword ptr ecx
			push	edx

			mov		[chaine+ebx], dl
			add     esp, 4      ; Nettoyage de la pile apr�s appel
            inc		ebx
			cmp		edx, 0
			jne		suivant

			xor ebx, ebx

affichage : movzx   eax, byte ptr[ebx + chaine]

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
            jne     affichage         ; si non, passer au suivant

            call    getchar         ; Attente de l'appui sur "Entr�e"

			pop     ebx

            ret                     ; Retour au code de d�marrage 'C'

main       endp

            end