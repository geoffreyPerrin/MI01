; IMAGE_SIMD.ASM
;
; MI01 - TP Assembleur 2 à 5
;
; R?alise le traitement d'une image 32 bits.

.686
.XMM
.MODEL FLAT, C

.DATA

.CODE

; **********************************************************************
; Sous-programme _process_image_simd
;
; R?alise le traitement d'une image 32 bits avec des instructions SIMD.
;
; Entrées sur la pile : Largeur de l'image (entier 32 bits)
;           Hauteur de l'image (entier 32 bits)
;           Pointeur sur l'image source (d?pl. 32 bits)
;           Pointeur sur l'image tampon 1 (d?pl. 32 bits)
;           Pointeur sur l'image tampon 2 (d?pl. 32 bits)
;           Pointeur sur l'image finale (d?pl. 32 bits)
; **********************************************************************
PUBLIC      process_image_simd
process_image_simd   PROC NEAR       ; Point d'entrée du sous programme

        push    ebp
        mov     ebp, esp

        push    ebx
        push    esi
        push    edi

        mov     ecx, [ebp + 8]
        imul    ecx, [ebp + 12]
		sub		ecx,2

        mov     esi, [ebp + 16]
        mov     edi, [ebp + 20]

	;chargement des coeff

	mov eax, 4C961Dh
	movd xmm2, eax
	psllq xmm2, 32
	movd xmm1, eax
	paddw xmm1,xmm2
	pxor xmm3, xmm3
	punpcklbw  xmm1, xmm3


boucle:

    ;on récupère deux pixels de l'image source à traiter
   	movq xmm0, qword ptr[esi+ecx*4]
	punpcklbw  xmm0, xmm3
	pmaddwd xmm0, xmm1
	phaddd xmm0,xmm3

;premier pixel
	movd eax, xmm0 ;on récupère le premier coefficient
	shr eax, 8 ;on divise par 256
	mov [edi+ecx*4], eax

	psrlq xmm0, 32

;deuxieme pixel
	movd eax, xmm0
	shr  eax, 8
	mov [edi+ecx*4+4], eax

	sub ecx, 2

        ja     boucle

fin:
        pop     edi
        pop     esi
        pop     ebx

        pop     ebp

        ret                         ; Retour à la fonction MainWndProc

process_image_simd   ENDP
END
